<!DOCTYPE html>
<html>
<head>
<#include "/layout/header.ftl">

<script>
$(function() {

    $(".date").datetimepicker({
        minView: "month",
        format: 'yyyy-mm-dd',
        autoclose: true,
        todayBtn: true
    });

    $("#queryForm").resetForm();

    $("#queryBtn").on("click",function(){
        $("#dataTable").DataTable().ajax.reload();
    })

    $("#resetBtn").on("click",function(){
        $("#queryForm").resetForm();
        $("#typeQ").val("");
        $("#supplierQ").val("");
        $("#supplierQ").trigger("change");
        $("#dataTable").DataTable().ajax.reload();
    })

    $(".supplierSel").select2();

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
            var type = $("#typeQ").val();
            if (type){
                param.type = type;
            }
            var supplierId = $("#supplierQ option:selected").val();
            if (supplierId){
                param.supplierId = supplierId;
            }

            $.ajax({
                type: "GET",
                url: "/farmPurchase/list",
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
            {data: "type"},
            {data: "content"},
            {data: "supplierName"},
            {data: "purchaseDate"},
            {data: "number"},
            {data: "amount"},
            {data: "id",
                render: function (data, type, full) {
                    return '<button type="button" class="btn btn-default" data-toggle="modal" data-target="#edit" data-id="'+data+'">编辑</button>' +
                            "&nbsp;"+'<button type="button" class="btn btn-danger delete" value="' + data + '">删除</button>';
                }
            }
        ]
    });

    //新增
    $('#submitBtn').on('click', function () {
        var type = $('#type').val();
        if (isNull(type)) {
            alert("请输入种类");
            return;
        }

        var content = $('#content').val();
        if (isNull(content)) {
            alert("请输入采购内容");
            return;
        }

        var supplierId = $('#supplier').val();
        var supplierName = $('#supplier').find("option:selected").text();
        if (isNull(supplierId)) {
            alert("请选择供应商");
            return;
        }

        var amount = $('#amount').val();

        var number = $('#number').val();
        if (isNull(number)) {
            alert("请输入采购份额");
            return;
        }

        var purchaseDate = $('#purchaseDate').val();
        if (isNull(purchaseDate)) {
            alert("请选择采购时间");
            return;
        }

        $.ajax({
            url: '/farmPurchase/add',
            method: 'POST',
            dataType: 'json',
            data: {
                type: type,
                content: content,
                supplierId: supplierId,
                supplierName: supplierName,
                number: number,
                purchaseDate: purchaseDate,
                amount: amount,
            },
            success: function (rs) {
                if (rs.success) {
                    if (rs.value) {
                        window.location.href = "/farmPurchase/page";
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
            url: '/farmPurchase/query/' + id,
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
        modal.find('#typeUpd').val(obj.type);
        $('#supplierUpd').val(obj.supplierId).trigger('change');
        modal.find('#amountUpd').val(obj.amount);
        modal.find('#numberUpd').val(obj.number);
        modal.find('#purchaseDateUpd').val(obj.purchaseDate);
        modal.find('#contentUpd').val(obj.content);
    });

    $('#edit').on('hidden.bs.modal', function (event) {
        var button = $(event.relatedTarget); // Button that triggered the modal
        var modal = $(this);
        modal.find('#id').val("");
        modal.find('#typeUpd').val("");
        modal.find('#amountUpd').val("");
        modal.find('#numberUpd').val("");
        modal.find('#purchaseDateUpd').val("");
        modal.find('#contentUpd').val("");
    });

    $(document).on('click', '#submitUpd', function () {
        var id = $("#id").val();

        var type = $('#typeUpd').val();
        if (isNull(type)) {
            alert("请输入种类");
            return;
        }

        var content = $('#contentUpd').val();
        if (isNull(content)) {
            alert("请输入采购内容");
            return;
        }

        var supplierId = $('#supplierUpd').val();
        var supplierName = $('#supplierUpd').find("option:selected").text();
        if (isNull(supplierId)) {
            alert("请选择供应商");
            return;
        }

        var amount = $('#amountUpd').val();

        var number = $('#numberUpd').val();
        if (isNull(number)) {
            alert("请输入采购份额");
            return;
        }

        var purchaseDate = $('#purchaseDateUpd').val();
        if (isNull(purchaseDate)) {
            alert("请选择采购时间");
            return;
        }

        $.ajax({
            url: '/farmPurchase/update',
            method: 'POST',
            dataType: 'json',
            data: {
                id: id,
                type: type,
                content: content,
                supplierId: supplierId,
                supplierName: supplierName,
                number: number,
                purchaseDate: purchaseDate,
                amount: amount
            },
            success: function (rs) {
                if (rs.success) {
                    if (rs.value) {
                        window.location.href = "/farmPurchase/page";
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
                url: '/farmPurchase/del/'+id,
                type: 'DELETE',
                dataType: 'json',
                success: function (rs) {
                    if (rs.success) {
                        alert("删除成功");
                        window.location.href = "/farmPurchase/page";
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
                  <strong>日常采购登记</strong>
                </h3>
                <button type="button" class="btn btn-primary pull-right" data-toggle="modal"
                        data-target="#create_modal">
                    新增采购
                </button>
              </div>
              <div class="box-body">
                <form id="queryForm" class="form-horizontal">
                  <div class="form-group">
                    <label class="control-label col-md-1">品种</label>
                    <div class="col-md-3">
                        <input type="text" id="typeQ" class="form-control col-md-2" />
                    </div>
                      <label class="control-label col-md-1">供应商名</label>
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
                      <th>采购种类</th>
                      <th>采购内容</th>
                      <th>供应商</th>
                      <th>采购时间</th>
                      <th>采购份额</th>
                      <th>采购金额</th>
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
                          <label class="col-sm-2 control-label">采购种类<span style="color:red">*</span></label>
                          <div class="col-sm-9">
                              <input type="text" class="form-control" id="type">
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">采购内容<span style="color:red">*</span></label>
                          <div class="col-sm-9">
                              <input type="text" class="form-control" id="content">
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">供应商名<span style="color:red">*</span></label>
                          <div class="col-sm-9">
                              <input type="hidden" id="selected_farm" value="${info.farm.farmCode}">
                              <select class="supplierSel" id="supplier" style="width: 100%">
                                  <#list supplierMap as k>
                                      <option value="${k.id}">${k.name}</option>
                                  </#list>
                              </select>
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">采购时间<span style="color:red">*</span></label>
                          <div class="col-sm-9">
                              <input type="text" class="form-control date" id="purchaseDate" >
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">采购份额<span style="color:red">*</span></label>
                          <div class="col-sm-9">
                              <input type="text" class="form-control" id="number" placeholder="100斤，200袋，500盒">
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">采购金额</label>
                          <div class="col-sm-9">
                              <input type="text" class="form-control" id="amount">
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
                          <label class="col-sm-2 control-label">采购种类<span style="color:red">*</span></label>
                          <div class="col-sm-9">
                              <input type="text" class="form-control" id="typeUpd">
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">采购内容<span style="color:red">*</span></label>
                          <div class="col-sm-9">
                              <input type="text" class="form-control" id="contentUpd">
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
                          <label class="col-sm-2 control-label">采购时间<span style="color:red">*</span></label>
                          <div class="col-sm-9">
                              <input type="text" class="form-control date" id="purchaseDateUpd" >
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">采购份额<span style="color:red">*</span></label>
                          <div class="col-sm-9">
                              <input type="text" class="form-control" id="numberUpd" placeholder="100斤，200袋，500盒">
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">采购金额</label>
                          <div class="col-sm-9">
                              <input type="text" class="form-control" id="amountUpd">
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