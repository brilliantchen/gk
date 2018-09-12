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

    var farmArray =new Array();
    <#list farmMap as k>
        farmArray[${k_index}] = {"id":'${k.id}',"name":'${k.farmName}'};
    </#list>;

    var sexTypeArray =new Array();
    <#list sexTypeMap as k,v>
        sexTypeArray[${k_index}] = {"code":'${k}',"desc":'${v}'};
    </#list>;

    var chickenStatusArray = new Array();
    <#list chickenStatusMap as k,v>
        chickenStatusArray[${k_index}] = {"id":'${k}',"desc":'${v}'};
    </#list>;

    $("#queryForm").resetForm();

    $("#queryBtn").on("click",function(){
        $("#dataTable").DataTable().ajax.reload();
    })

    $("#resetBtn").on("click",function(){
        $("#queryForm").resetForm();
        $("#farmQ").val("");
        $("#farmQ").trigger("change");
        $("#dataTable").DataTable().ajax.reload();
    })

    $(".farmSel").select2();
    $(".statusSel").select2();

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
            var orderNo = $("#orderNoQ").val();
            if (orderNo){
                param.orderNo = orderNo;
            }
            var facilityNo = $("#facilityNoQ").val();
            if (facilityNo){
                param.facilityNo = facilityNo;
            }
            var farmId = $("#farmQ option:selected").val();
            if (farmId){
                param.farmId = farmId;
            }

            $.ajax({
                type: "GET",
                url: "/orderDetail/list",
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
            {data: "facilityNo"},
            {data: "orderNo"},
            {data: "sex",
                render: function (data, type, full, meta) {
                    for(var i=0;i<sexTypeArray.length;i++){
                        if (sexTypeArray[i].code == data){
                            return sexTypeArray[i].desc;
                        }
                    }
                    return null;
                }
            },
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
            {data: "deadTime"},
            {data: "id",
                render: function (data, type, full) {
                    return '<button type="button" class="btn btn-danger delete" value="' + data + '">删除</button>';
                }
            }
        ]
    });

    $('#edit').on('shown.bs.modal', function (event) {
        var button = $(event.relatedTarget); // Button that triggered the modal
        var id = button.data('id');
        var obj;
        $.ajax({
            url: '/orderDetail/query/' + id,
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
        $('#statusUpd').val(obj.status).trigger('change');
        modal.find('#deadTime').val(obj.deadTime);
    });

    $('#edit').on('hidden.bs.modal', function (event) {
        var button = $(event.relatedTarget); // Button that triggered the modal
        var modal = $(this);
        modal.find('#id').val("");
        modal.find('#deadTime').val("");
    });

    $(document).on('click', '#submitUpd', function () {
        var id = $("#id").val();

        var status = $('#statusUpd').val();
        if (isNull(status)) {
            alert("请选择状态");
            return;
        }

        var deadTime = $('#deadTimeUpd').val();
        if (isNull(deadTime)) {
            alert("请选择死亡日期");
            return;
        }

        $.ajax({
            url: '/orderDetail/update',
            method: 'POST',
            dataType: 'json',
            data: {
                id: id,
                inWeight: inWeight,
                outWeight: outWeight,
                status: status,
                deadTime: deadTime,
            },
            success: function (rs) {
                if (rs.success) {
                    if (rs.value) {
                        window.location.href = "/orderDetail/page";
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
                url: '/orderDetail/del/'+id,
                type: 'DELETE',
                dataType: 'json',
                success: function (rs) {
                    if (rs.success) {
                        alert("删除成功");
                        window.location.href = "/orderDetail/page";
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
                  <strong>鸡只档案管理</strong>
                </h3>
              </div>
              <div class="box-body">
                <form id="queryForm" class="form-horizontal">
                  <div class="form-group">
                    <label for="" class="control-label col-md-1">设备号</label>
                      <div class="col-md-3">
                          <input type="text" id="facilityNoQ" class="form-control col-md-2" />
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
                  </div>
                    <div class="form-group">
                        <label for="" class="control-label col-md-1">订单号</label>
                        <div class="col-md-3">
                            <input type="text" id="orderNoQ" class="form-control col-md-2" />
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
                      <th>设备号</th>
                      <th>订单编号</th>
                      <th>性别</th>
                      <th>农场名</th>
                      <th>当前状态</th>
                      <th>死亡日期</th>
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
                          <label class="col-sm-2 control-label">当前状态<span style="color:red">*</span></label>
                          <div class="col-sm-9">
                              <select class="statusSel" id="statusUpd" style="width: 100%">
                              <#list chickenStatusMap as k,v>
                                  <option value="${k}">${v}</option>
                              </#list>
                              </select>
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">死亡日期<span style="color:red">*</span></label>
                          <div class="col-sm-9">
                              <input type="text" class="form-control date" id="deadTimeUpd">
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