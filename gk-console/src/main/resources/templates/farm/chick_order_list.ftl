<!DOCTYPE html>
<html>
<head>
<#include "/layout/header.ftl">
<script src="/bootstrap-fileinput/js/fileinput.js"></script>
<script src="/ossInput.js"></script>

<script>
$(function() {

    $(".date").datetimepicker({
        minView: "month",
        format: 'yyyy-mm-dd',
        autoclose: true,
        todayBtn: true
    });

    $.ajax("/get_signature", {
        dataType: "json",
        cache: false,
        method: "post"
    }).done(function (signature) {
        $("#pictureUpd").ossInput(signature, "#pictureUrlUpd");
    });

    var farmArray =new Array();
    <#list farmMap as k>
        farmArray[${k_index}] = {"id":'${k.id}',"name":'${k.farmName}'};
    </#list>;

    var supplierArray = new Array();
    <#list supplierMap as k>
        supplierArray[${k_index}] = {"id":'${k.id}',"name":'${k.name}'};
    </#list>;

    var chickTypeArray = new Array();
    <#list chickType as k>
        chickTypeArray[${k_index}] = '${k}';
    </#list>;

    var chickenStatusArray = new Array();
    <#list chickenStatus as k,v>
        chickenStatusArray[${k_index}] = {"id":'${k}',"desc":'${v}'};
    </#list>;


    $("#queryForm").resetForm();

    $("#queryBtn").on("click",function(){
        $("#dataTable").DataTable().ajax.reload();
    })

    $("#resetBtn").on("click",function(){
        $("#queryForm").resetForm();
        $("#typeQ").val("");
        $("#typeQ").trigger("change");
        $("#farmQ").val("");
        $("#farmQ").trigger("change");
        $("#supplierQ").val("");
        $("#supplierQ").trigger("change");
        $("#dataTable").DataTable().ajax.reload();
    })

    $(".farmSel").select2();
    $(".supplierSel").select2();
    $(".typeSel").select2();

    var oTable = $('#dataTable').DataTable({
        "processing": true,
        "serverSide": true,
        "retrieve": true,
        "bSort": false, //排序功能
        "bFilter": false, //过滤功能
        "bLengthChange": false,
        "oLanguage": {
            "sLengthMenu": "每页显示 _MENU_ 条记录",
            "sZeroRecords": "抱歉， 没有找到",
            "sInfo": "从 _START_ 到 _END_ /共 _TOTAL_ 条数据",
            "sInfoEmpty": "没有数据",
            "sInfoFiltered": "(从 _MAX_ 条数据中检索)",
            "oPaginate": {
                "sFirst": "首页",
                "sPrevious": "前一页",
                "sNext": "后一页",
                "sLast": "尾页"
            },
            "sZeroRecords": "没有检索到数据"
        },
        ajax: function (data, callback, settings) {
            //封装请求参数
            var param = {};
            param.length = data.length;//每页显示记录条数
            param.start = (data.start / data.length);//当前页码
            var type = $("#typeQ option:selected").val();
            if (type){
                param.type = type;
            }
            var farmId = $("#farmQ option:selected").val();
            if (farmId){
                param.farmId = farmId;
            }
            var supplierId = $("#supplierQ option:selected").val();
            if (supplierId){
                param.supplierId = supplierId;
            }

            $.ajax({
                type: "GET",
                url: "/chickOrder/list",
                cache: false,
                data: param,
                dataType: "json",
                success: function (res) {
                    setTimeout(function () {
                        var returnData = {};
                        returnData.recordsTotal = res.value.totalElements;//返回数据全部记录
                        returnData.recordsFiltered = res.value.totalElements;//后台不实现过滤功能，每次查询均视作全部结果
                        returnData.data = res.value.content;//返回的数据列表
                        callback(returnData);
                    }, 200);
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    console.log("查询失败");
                }
            });
        },
        columns: [
            {data: "id"},
            {data: "orderNo"},
            {data: "type"},
            {data: "farmId",
                render: function (data, type, full, meta) {
                    for(var i=0;i<farmArray.length;i++){
                        if (farmArray[i].id == data){
                            return farmArray[i].name;
                        }
                    }
                    return null;
                }
            },
            {data: "supplierId",
                render: function (data, type, full, meta) {
                    for(var i=0;i<supplierArray.length;i++){
                        if (supplierArray[i].id == data){
                            return supplierArray[i].name;
                        }
                    }
                    return null;
                }
            },
            {data: "amount"},
            {data: "inDate"},
            {data: "dayAge"},
            {data: "inWeight"},
            {data: "predictOutDate"},
            {data: "outDate"},
            {data: "outWeight"},
            {data: "status",
                render: function (data, type, full, meta) {
                    for(var i=0;i<chickenStatusArray.length;i++){
                        if (chickenStatusArray[i].id == data){
                            return chickenStatusArray[i].desc;
                        }
                    }
                    return null;
                }
            },
            {data: "id",
                render: function (data, type, full) {
                    return '<button type="button" class="btn btn-default" data-toggle="modal" data-target="#edit" data-id="'+data+'">编辑</button>' +
                            "&nbsp;"+'<button type="button" class="btn btn-default" data-toggle="modal" data-target="#out" data-id="'+data+'">出栏</button>' +
                            "&nbsp;"+'<button type="button" class="btn btn-danger delete" value="' + data + '">删除</button>';
                }
            }
        ]
    });

    //新增
    $('#submitBtn').on('click', function () {
        var type = $('#type').val();
        if (isNull(type)) {
            alert("请选择品种");
            return;
        }

        var farmId = $('#farm').val();
        var farmName = $('#farm').find("option:selected").text();
        if (isNull(farmId)) {
            alert("请选择农场");
            return;
        }

        var supplierId = $('#supplier').val();
        var supplierName = $('#supplier').find("option:selected").text();
        if (isNull(supplierId)) {
            alert("请选择供应商");
            return;
        }

        var amount = $('#amount').val();
        if (isNaN(amount)){
            alert("请输入数量");
            return;
        }

        var location = $('#location').val();
        if (isNull(location)){
            alert("请输入产地");
            return;
        }

        var inDate = $('#inDate').val();
        if (isNull(inDate)) {
            alert("请选择入栏日期");
            return;
        }

        var dayAge = $('#dayAge').val();
        if (isNaN(dayAge)) {
            alert("请输入入栏日龄");
            return;
        }

        var inWeight = $('#inWeight').val();
        if (isNaN(inWeight)) {
            alert("请输入入栏体重");
        }

        var predictOutDate = $('#predictOutDate').val();
        if (isNull(predictOutDate)) {
            alert("请选择预计出栏日期");
            return;
        }
        var predictOutDateTmp = new Date(predictOutDate);
        var inDateTmp = new Date(inDate);
        if (inDateTmp > predictOutDateTmp){
            alert("预计出栏日期早于入栏日期");
            return;
        }


        $.ajax({
            url: '/chickOrder/add',
            method: 'POST',
            dataType: 'json',
            data: {
                type: type,
                farmId: farmId,
                farmName: farmName,
                supplierId: supplierId,
                supplierName: supplierName,
                inDate: inDate,
                amount: amount,
                location: location,
                dayAge: dayAge,
                inWeight: inWeight,
                predictOutDate: predictOutDate,
            },
            success: function (rs) {
                if (rs.success) {
                    if (rs.value) {
                        window.location.href = "/chickOrder/page";
                    } else {
                        alert(rs.errorMessage);
                        return;
                    }
                } else {
                    alert(rs.errorMessage);
                    return;
                }
            }
        })
    });

    $('#edit').on('shown.bs.modal', function (event) {
        var button = $(event.relatedTarget); // Button that triggered the modal
        var id = button.data('id');
        var obj;
        $.ajax({
            url: '/chickOrder/query/' + id,
            type: 'GET',
            dataType: 'json',
            async : false,
            success: function (rs) {
                if (rs) {
                    obj = rs.value;
                }
            }
        });
        var modal = $(this);
        modal.find('#id').val(obj.id);
        $('#typeUpd').val(obj.type).trigger('change');
        $('#farmUpd').val(obj.farmId).trigger('change');
        $('#supplierUpd').val(obj.supplierId).trigger('change');
        modal.find('#amountUpd').val(obj.amount);
        modal.find('#locationUpd').val(obj.location);
        modal.find('#inDateUpd').val(obj.inDate);
        modal.find('#dayAgeUpd').val(obj.dayAge);
        modal.find('#inWeightUpd').val(obj.inWeight);
        modal.find('#predictOutDateUpd').val(obj.predictOutDate);
    });

    $('#edit').on('hidden.bs.modal', function (event) {
        var button = $(event.relatedTarget); // Button that triggered the modal
        var modal = $(this);
        modal.find('#id').val("");
        modal.find('#amountUpd').val("");
        modal.find('#locationUpd').val("");
        modal.find('#inDateUpd').val("");
        modal.find('#dayAgeUpd').val("");
        modal.find('#inWeightUpd').val("");
        modal.find('#predictOutDateUpd').val("");
    });

    $(document).on('click', '#submitUpd', function () {
        var id = $("#id").val();

        var type = $('#typeUpd').val();
        if (isNull(type)) {
            alert("请选择品种");
            return;
        }

        var farmId = $('#farmUpd').val();
        var farmName = $('#farmUpd').find("option:selected").text();
        if (isNull(farmId)) {
            alert("请选择农场");
            return;
        }

        var supplierId = $('#supplierUpd').val();
        var supplierName = $('#supplierUpd').find("option:selected").text();
        if (isNull(supplierId)) {
            alert("请选择供应商");
            return;
        }

        var amount = $('#amountUpd').val();
        if (isNaN(amount)){
            alert("请输入数量");
            return;
        }

        var location = $('#locationUpd').val();
        if (isNull(location)) {
            alert("请输入产地");
            return;
        }

        var inDate = $('#inDateUpd').val();
        if (isNull(inDate)) {
            alert("请选择入栏日期");
            return;
        }

        var dayAge = $('#dayAgeUpd').val();
        if (isNaN(dayAge)) {
            alert("请输入入栏日龄");
            return;
        }

        var inWeight = $('#inWeightUpd').val();
        if (isNaN(inWeight)) {
            alert("请输入入栏体重");
        }

        var predictOutDate = $('#predictOutDateUpd').val();
        if (isNull(predictOutDate)) {
            alert("请选择预计出栏日期");
            return;
        }

        var predictOutDateTmp = new Date(predictOutDate);
        var inDateTmp = new Date(inDate);
        if (inDateTmp > predictOutDateTmp){
            alert("预计出栏日期早于入栏日期");
            return;
        }

        $.ajax({
            url: '/chickOrder/update',
            method: 'POST',
            dataType: 'json',
            data: {
                id: id,
                type: type,
                farmId: farmId,
                farmName: farmName,
                supplierId: supplierId,
                supplierName: supplierName,
                inDate: inDate,
                amount: amount,
                location: location,
                dayAge: dayAge,
                inWeight: inWeight,
                predictOutDate: predictOutDate,
            },
            success: function (rs) {
                if (rs.success) {
                    if (rs.value) {
                        window.location.href = "/chickOrder/page";
                    } else {
                        alert(rs.errorMessage);
                        return;
                    }
                } else {
                    alert(rs.errorMessage);
                    return;
                }
            }
        })
    });

    $('#out').on('shown.bs.modal', function (event) {
        var button = $(event.relatedTarget); // Button that triggered the modal
        var id = button.data('id');
        var obj;
        $.ajax({
            url: '/chickOrder/query/' + id,
            type: 'GET',
            dataType: 'json',
            async : false,
            success: function (rs) {
                if (rs) {
                    obj = rs.value;
                }
            }
        });
        var modal = $(this);
        modal.find('#outId').val(obj.id);
        modal.find('#outDateUpd').val(obj.outDate);
        modal.find('#statusUpd').val(obj.status).trigger("change");
        modal.find('#outWeightUpd').val(obj.outWeight);
        modal.find('#slaughterHouseUpd').val(obj.slaughterHouse);
        modal.find('#pictureUrlUpd').val(obj.quarantinePic);
        modal.find('#quarantineResultUpd').val(obj.quarantineResult);
        modal.find('#quarantineDateUpd').val(obj.quarantineDate);
        modal.find('#quarantineAgenciesUpd').val(obj.quarantineAgencies);
    });

    $('#out').on('hidden.bs.modal', function (event) {
        var button = $(event.relatedTarget); // Button that triggered the modal
        var modal = $(this);
        modal.find('#outId').val("");
        modal.find('#outDateUpd').val("");
        modal.find('#outWeightUpd').val("");
        modal.find('#slaughterHouseUpd').val("");
        modal.find('#pictureUrlUpd').val("");
        modal.find('#quarantineResultUpd').val("");
        modal.find('#quarantineDateUpd').val("");
        modal.find('#quarantineAgenciesUpd').val("");
        modal.find('#statusUpd').val("");
    });

    $(document).on('click', '#submitOutUpd', function () {
        var id = $("#outId").val();

        var outDate = $('#outDateUpd').val();
        if (isNull(outDate)) {
            alert("请选择出栏日期");
            return;
        }

        var outWeight = $('#outWeightUpd').val();
        if (isNull(outWeight)) {
            alert("请输入出栏体重");
            return;
        }

        var status = $('#statusUpd').val();
        if (isNull(status)) {
            alert("请输入出栏体重");
            return;
        }

        var slaughterHouse = $('#slaughterHouseUpd').val();

        var quarantinePic = $('#pictureUrlUpd').val();

        var quarantineResult = $('#quarantineResultUpd').val();

        var quarantineDate = $('#quarantineDateUpd').val();

        var quarantineAgencies = $('#quarantineAgenciesUpd').val();

        $.ajax({
            url: '/chickOrder/slaughter',
            method: 'POST',
            dataType: 'json',
            data: {
                id: id,
                slaughterHouse: slaughterHouse,
                quarantinePic: quarantinePic,
                quarantineResult: quarantineResult,
                outDate: outDate,
                status: status,
                outWeight: outWeight,
                quarantineDate: quarantineDate,
                quarantineAgencies: quarantineAgencies,
            },
            success: function (rs) {
                if (rs.success) {
                    if (rs.value) {
                        window.location.href = "/chickOrder/page";
                    } else {
                        alert(rs.errorMessage);
                        return;
                    }
                } else {
                    alert(rs.errorMessage);
                    return;
                }
            }
        })
    });

    // 删除
    $(document).on('click', '.delete', function () {
        var id= $(this).val();
        if(confirm("确定删除？")) {
            $.ajax({
                url: '/chickOrder/del/'+id,
                type: 'DELETE',
                dataType: 'json',
                success: function (rs) {
                    if (rs.success) {
                        alert("删除成功");
                        window.location.href = "/chickOrder/page";
                    } else {
                        alert(rs.errorMessage);
                    }
                }
            });
        }
    });
 });
</script>

</head>
<body class="hold-transition skin-blue sidebar-mini">
  <div class="wrapper">
    <#include "/layout/left.ftl">
    <div class="content-wrapper">

      <section class="content">
        <div class="row">
          <div class="col-md-12">
            <div class="box">
              <div class="box-header with-border">
                <h3 class="box-title">
                  <strong>鸡只出入栏信息</strong>
                </h3>
                <button type="button" class="btn btn-primary pull-right" data-toggle="modal"
                        data-target="#create_modal">
                    新增入栏订单
                </button>
              </div>
              <div class="box-body">
                <form id="queryForm" class="form-horizontal">
                  <div class="form-group">
                    <label for="" class="control-label col-md-1">品种</label>
                    <div class="col-md-3">
                        <select class="typeSel" id="typeQ" style="width: 100%">
                            <option></option>
                            <#list chickType as k>
                                <option>${k}</option>
                            </#list>
                        </select>
                    </div>
                      <label for="" class="control-label col-md-1">农场名</label>
                      <div class="col-md-3">
                          <select class="farmSel" id="farmQ" style="width: 100%">
                              <option></option>
                              <#list farmMap as k>
                                  <option value="${k.id}">${k.farmName}</option>
                              </#list>
                          </select>
                      </div>
                      <label for="" class="control-label col-md-1">供应商名</label>
                      <div class="col-md-3">
                          <select class="supplierSel" id="supplierQ" style="width: 100%">
                              <option></option>
                              <#list supplierMap as k>
                                  <option value="${k.id}">${k.name}</option>
                              </#list>
                          </select>
                      </div>
                  </div>
                  <div class="form-group text-center">
                    <button id="queryBtn" class="btn btn-primary" type="button">查询</button>
                    <button id="resetBtn" class="btn btn-default" type="button">重置</button>
                  </div>
                </form>
                <table id="dataTable" class="table table-bordered table-hover" style="width: 100%">
                  <thead>
                    <tr>
                      <th>id</th>
                      <th>订单编号</th>
                      <th>品种</th>
                      <th>农场名</th>
                      <th>供应商名</th>
                      <th>数量</th>
                      <th>入栏日期</th>
                      <th>入栏日龄</th>
                      <th>入栏体重</th>
                      <th>预计出栏日期</th>
                      <th>出栏日期</th>
                      <th>出栏体重</th>
                      <th>状态</th>
                      <th>操作</th>
                    </tr>
                  </thead>
                </table>
              </div>
            </div>
          </div>
        </div>
      </section>
    </div>
  </div>

  <div class="modal fade" id="create_modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
      <div class="modal-dialog" role="document">
          <div class="modal-content">
              <div class="modal-body">
                  <form id="farm_form" class="form-horizontal">
                      <div class="form-group">
                          <label class="col-sm-2 control-label">品种<span style="color:red">*</span></label>
                          <div class="col-sm-9">
                              <select class="typeSel" id="type" style="width: 100%">
                              <#list chickType as k>
                                  <option>${k}</option>
                              </#list>
                              </select>
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">农场名<span style="color:red">*</span></label>
                          <div class="col-sm-9">
                              <select class="farmSel" id="farm" style="width: 100%">
                              <#list farmMap as k>
                                  <option value="${k.id}">${k.farmName}</option>
                              </#list>
                              </select>
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">供应商名<span style="color:red">*</span></label>
                          <div class="col-sm-9">
                              <select class="supplierSel" id="supplier" style="width: 100%">
                              <#list supplierMap as k>
                                  <option value="${k.id}">${k.name}</option>
                              </#list>
                              </select>
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">数量<span style="color:red">*</span></label>
                          <div class="col-sm-9">
                              <input type="text" class="form-control" id="amount">
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">产地<span style="color:red">*</span></label>
                          <div class="col-sm-9">
                              <input type="text" class="form-control" id="location">
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">入栏日期<span style="color:red">*</span></label>
                          <div class="col-sm-9">
                              <input type="text" class="form-control date" id="inDate" >
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">入栏日龄<span style="color:red">*</span></label>
                          <div class="col-sm-9">
                              <input type="text" class="form-control" id="dayAge">
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">入栏体重<span style="color:red">*</span></label>
                          <div class="col-sm-9">
                              <input type="text" class="form-control" id="inWeight">
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">预计出栏日期<span style="color:red">*</span></label>
                          <div class="col-sm-9">
                              <input type="text" class="form-control date" id="predictOutDate">
                          </div>
                      </div>
                  </form>
              </div>
              <div class="modal-footer">
                  <button type="button" class="btn btn-default" data-dismiss="modal" id="cancel">取消</button>
                  <button type="button" class="btn btn-primary" id="submitBtn">确定</button>
              </div>
          </div>
      </div>
  </div>

  <div class="modal fade" id="out" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
      <div class="modal-dialog" role="document">
          <div class="modal-content">
              <div class="modal-body">
                  <form id="farm_form" class="form-horizontal">
                      <div class="form-group">
                          <div class="col-sm-10">
                              <input type="hidden" class="form-control" id="outId"/>
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">出栏日期<span style="color:red">*</span></label>
                          <div class="col-sm-9">
                              <input type="text" class="form-control date" id="outDateUpd">
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">状态<span style="color:red">*</span></label>
                          <div class="col-sm-9">
                              <select class="statusSel" id="statusUpd" style="width: 100%">
                                  <#list chickenStatus as k,v>
                                      <option value="${k}">${v}</option>
                                  </#list>
                              </select>
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">出栏体重<span style="color:red">*</span></label>
                          <div class="col-sm-9">
                              <input type="text" class="form-control" id="outWeightUpd">
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">屠宰场</label>
                          <div class="col-sm-9">
                              <input type="text" class="form-control" id="slaughterHouseUpd">
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">检疫机构</label>
                          <div class="col-sm-9">
                              <input type="text" class="form-control" id="quarantineAgenciesUpd">
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">检疫日期</label>
                          <div class="col-sm-9">
                              <input type="text" class="form-control date" id="quarantineDateUpd" >
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">检疫结果</label>
                          <div class="col-sm-9">
                              <input type="text" class="form-control" id="quarantineResultUpd">
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">检疫结果照片</label>
                          <div class="col-sm-9">
                              <input type="file" class="form-control" id="pictureUpd" name="pictureUpd">
                          </div>
                          <div class="col-sm-9 help-block">
                              <input type="hidden" id="pictureUrlUpd" value="">
                          </div>
                      </div>
                  </form>
              </div>
              <div class="modal-footer">
                  <button type="button" class="btn btn-default" data-dismiss="modal" id="cancel">取消</button>
                  <button type="button" class="btn btn-primary" id="submitOutUpd">确定</button>
              </div>
          </div>
      </div>
  </div>


  <div class="modal fade" id="edit" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
      <div class="modal-dialog" role="document">
          <div class="modal-content">
              <div class="modal-body">
                  <form id="farm_form" class="form-horizontal">
                      <div class="form-group">
                          <div class="col-sm-10">
                              <input type="hidden" class="form-control" id="id"/>
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">品种<span style="color:red">*</span></label>
                          <div class="col-sm-9">
                              <select class="typeSel" id="typeUpd" style="width: 100%">
                              <#list chickType as k>
                                  <option>${k}</option>
                              </#list>
                              </select>
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">农场名<span style="color:red">*</span></label>
                          <div class="col-sm-9">
                              <select class="farmSel" id="farmUpd" style="width: 100%">
                              <#list farmMap as k>
                                  <option value="${k.id}">${k.farmName}</option>
                              </#list>
                              </select>
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">供应商名<span style="color:red">*</span></label>
                          <div class="col-sm-9">
                              <select class="supplierSel" id="supplierUpd" style="width: 100%">
                              <#list supplierMap as k>
                                  <option value="${k.id}">${k.name}</option>
                              </#list>
                              </select>
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">数量<span style="color:red">*</span></label>
                          <div class="col-sm-9">
                              <input type="text" class="form-control" id="amountUpd">
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">产地<span style="color:red">*</span></label>
                          <div class="col-sm-9">
                              <input type="text" class="form-control" id="locationUpd">
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">入栏日期<span style="color:red">*</span></label>
                          <div class="col-sm-9">
                              <input type="text" class="form-control date" id="inDateUpd" >
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">入栏日龄<span style="color:red">*</span></label>
                          <div class="col-sm-9">
                              <input type="text" class="form-control" id="dayAgeUpd">
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">入栏体重<span style="color:red">*</span></label>
                          <div class="col-sm-9">
                              <input type="text" class="form-control" id="inWeightUpd">
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">预计出栏日期<span style="color:red">*</span></label>
                          <div class="col-sm-9">
                              <input type="text" class="form-control date" id="predictOutDateUpd">
                          </div>
                      </div>
                  </form>
              </div>
              <div class="modal-footer">
                  <button type="button" class="btn btn-default" data-dismiss="modal" id="cancel">取消</button>
                  <button type="button" class="btn btn-primary" id="submitUpd">确定</button>
              </div>
          </div>
      </div>
  </div>

</body>
</html>