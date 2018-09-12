<!DOCTYPE html>
<html>
<head>
<#include "/layout/header.ftl">
<script>
  $(function() {
    $("#queryForm").clearForm();
    var orderNo = "${orderNo}";
    $("#orderNo").val(orderNo);

    $("#queryBtn").on("click", function() {
      $("#dataTable").DataTable().ajax.reload();
    })
    $("#resetBtn").on("click", function() {
      $("#queryForm").clearForm();
      $("#dataTable").DataTable().ajax.reload();
    })
    $('#dataTable').DataTable({
      filter : false,
      lengthChange : false,
      processing : true,
      ordering : false,
      serverSide : true,
      stateSave : false,
      scrollX : true,
      ajax : {
        url : "page",
        dataType : "json",
        type : "post",
        data : function(d) {
          d.expressNo = $("#expressNo").val();
          d.orderNo = $("#orderNo").val();
          d.facilityNo = $("#facilityNo").val();
        }
      },
      columns : [
        { "data" : "expressNo" },
        { "data" : "orderNo" },
        { "data" : "facilityNo" },
        { "data" : "consignee" },
        { "data" : "consigneePhone" },
        { "data" : "consigneeMobile" },
        { "data" : "consigneeEmail" },
        { "data" : "province" },
        { "data" : "city" },
        { "data" : "district" },
        { "data" : "address" },
        { "data" : "freight" },
        { "data" : "entryTime" },
        { "data" : "deliveryTime" },
        { "data" : "statusName" },
        { render : function(data, type, full, meta) {
            return ""
        } } 
      ]
    });
  })
</script>
</head>
<body class="hold-transition skin-blue sidebar-mini">
<div class="wrapper">
<#include "/layout/left.ftl">
<div class="content-wrapper">
  <section class="content" layout:fragment="content">
    <div class="row">
      <div class="col-md-12">
        <div class="box">
          <div class="box-header with-border">
            <h3 class="box-title">
              <strong>快递运单</strong>
            </h3>
          </div>
          <div class="box-body">
            <form id="queryForm" class="form-horizontal">
              <div class="form-group">
                <label for="" class="control-label col-md-1">快递单号</label>
                <div class="col-md-3">
                  <input type="text" name="expressNo" id="expressNo" class="form-control col-md-2" />
                </div>
                <label for="" class="control-label col-md-1">订单编号</label>
                <div class="col-md-3">
                  <input type="text" name="orderNo" id="orderNo" class="form-control col-md-2" />
                </div>
                <label for="" class="control-label col-md-1">鸡只编号</label>
                <div class="col-md-3">
                  <input type="text" name="facilityNo" id="facilityNo" class="form-control col-md-2" />
                </div>
              </div>
              <div class="form-group text-center">
                <button id="queryBtn" class="btn btn-primary" type="button">查询</button>
                <button id="resetBtn" class="btn btn-default" type="button">取消</button>
              </div>
            </form>
            <table id="dataTable" class="table table-bordered table-hover" style="width: 100%">
              <thead>
                <tr>
                  <th>快递单号</th>
                  <th>订单号</th>
                  <th>鸡只编号</th>
                  <th>收货人</th>
                  <th>座机</th>
                  <th>手机</th>
                  <th>邮箱</th>
                  <th>省</th>
                  <th>市</th>
                  <th>区</th>
                  <th>地址</th>
                  <th>运费</th>
                  <th>入场时间</th>
                  <th>发货时间</th>
                  <th>配送状态</th>
                  <th>操作</th>
                </tr>
              </thead>
            </table>


          </div>
        </div>
      </div>
    </div>
  </section>
  <!-- <script src="/plupload/plupload.full.min.js"></script> -->
  <!-- <script src="/plupload/jquery.plupload.queue.min.js"></script> -->
  <!-- <script src="/plupload/upload.js"></script> -->
</div>
</div>
</body>
</html>