<!DOCTYPE html>
<html>
<head>
<#include "/layout/header.ftl">

<script>
$(function() {

    $(".date").datetimepicker({
        minView: "day",
        format: 'yyyy-mm-dd hh:mm:ss',
        autoclose: true,
        todayBtn: true
    });

    var farmPurchaseArray =new Array();
    <#list farmPurchasesMap as k,v>
        farmPurchaseArray[${k_index}] = {"id":'${k}',"type":'${v.type}',"content":'${v.content}'};
    </#list>;

    $("#queryForm").resetForm();

    $("#queryBtn").on("click",function(){
        $("#dataTable").DataTable().ajax.reload();
    })

    $("#resetBtn").on("click",function(){
        $("#queryForm").resetForm();
        $("#orderNoQ").val("");
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
            var orderNo = $("#orderNoQ").val();
            if (orderNo){
                param.orderNo = orderNo;
            }

            $.ajax({
                type: "GET",
                url: "/farmPurchaseUsage/list",
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
            {data: "content"},
            {data: "usageTime"},
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
            alert("请输入内容");
            return;
        }

        var orderNo = $('#orderNo').val();
        if (isNull(orderNo)) {
            alert("请输入订单编号");
            return;
        }

        var usageTime = $('#usageTime').val();
        if (isNull(usageTime)) {
            alert("请选择使用时间");
            return;
        }

        $.ajax({
            url: '/farmPurchaseUsage/add',
            method: 'POST',
            dataType: 'json',
            data: {
                type: type,
                content: content,
                usageTime: usageTime,
                orderNo: orderNo,
            },
            success: function (rs) {
                if (rs.success) {
                    if (rs.value) {
                        window.location.href = "/farmPurchaseUsage/page";
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
            url: '/farmPurchaseUsage/query/' + id,
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
        modal.find('#usageTimeUpd').val(obj.usageTime);
    });

    $('#edit').on('hidden.bs.modal', function (event) {
        var button = $(event.relatedTarget); // Button that triggered the modal
        var modal = $(this);
        modal.find('#id').val("");
        modal.find('#usageTimeUpd').val("");
    });

    $(document).on('click', '#submitUpd', function () {
        var id = $("#id").val();

        var usageTime = $('#usageTimeUpd').val();
        if (isNull(usageTime)) {
            alert("请选择使用时间");
            return;
        }

        $.ajax({
            url: '/farmPurchaseUsage/update',
            method: 'POST',
            dataType: 'json',
            data: {
                id: id,
                usageTime: usageTime,
            },
            success: function (rs) {
                if (rs.success) {
                    if (rs.value) {
                        window.location.href = "/farmPurchaseUsage/page";
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
                url: '/farmPurchaseUsage/del/'+id,
                type: 'DELETE',
                dataType: 'json',
                success: function (rs) {
                    if (rs.success) {
                        alert("删除成功");
                        window.location.href = "/farmPurchaseUsage/page";
                    } else {
                        alert(rs.errorMessage);
                    }
                }
            });
        }
    });

    $('#type').change(function () {
        var type = $('#type').val();
        if (isNull(type)){
            $("#content").val("");
            return;
        }

        var content = "";
        for(var i=0;i<farmPurchaseArray.length;i++){
            if (farmPurchaseArray[i].id == type){
                content = farmPurchaseArray[i].content;
            }
        }
        $("#content").val(content);
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
                  <strong>日常使用记录</strong>
                </h3>
                <button type="button" class="btn btn-primary pull-right" data-toggle="modal"
                        data-target="#create_modal">
                    新增使用记录
                </button>
              </div>
              <div class="box-body">
                <form id="queryForm" class="form-horizontal">
                  <div class="form-group">
                    <label class="control-label col-md-1">鸡苗订单编号</label>
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
                      <th>鸡苗订单编号</th>
                      <th>种类</th>
                      <th>内容</th>
                      <th>使用时间</th>
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
                          <label class="col-sm-2 control-label">种类<span style="color:red">*</span></label>
                          <div class="col-sm-9">
                              <select class="TypeSel" id="type" style="width: 100%">
                                  <option></option>
                                  <#list farmPurchasesMap as k,v>
                                      <option value="${k}">${v.type}</option>
                                  </#list>
                              </select>
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">内容<span style="color:red">*</span></label>
                          <div class="col-sm-9">
                              <input type="text" class="form-control" id="content" >
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">订单编号<span style="color:red">*</span></label>
                          <div class="col-sm-9">
                              <input type="text" class="form-control" id="orderNo" >
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">使用时间<span style="color:red">*</span></label>
                          <div class="col-sm-9">
                              <input type="text" class="form-control date" id="usageTime" >
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
                          <label class="col-sm-2 control-label">使用时间<span style="color:red">*</span></label>
                          <div class="col-sm-9">
                              <input type="text" class="form-control date" id="usageTimeUpd" >
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