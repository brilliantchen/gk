<!DOCTYPE html>
<html>
<head>
<#include "/layout/header.ftl">
</head>
<body class="hold-transition skin-blue sidebar-mini">
<div class="wrapper">
<#include "/layout/left.ftl">
  <div class="content-wrapper">
    <section class="content">
      <!--page content start-->
      <div class="row">
        <div class="col-md-12">

          <div class="box">
            <div class="box-header with-border">
              <h1 class="box-title"><strong>退款审批</strong></h1>
            </div>

            <div class="box-body">
              <table id="paging_tbl" class="table table-bordered">
                <thead>
                <tr>
                  <th>序号</th>
                  <th>退款订单</th>
                  <th>支付方式</th>
                  <th>退款原因</th>
                  <th>退款状态</th>
                  <th>退款申请时间</th>
                  <th>更新时间</th>
                  <th>操作</th>
                </tr>
                </thead>

              </table>
            </div>


          </div>
        </div>
      </div>

      <!--page content end-->
    </section>
  </div>
</div>
<script>


  $(function () {
    initPage();
    showPage();
  });

  var initPage = function () {

  }

  var showPage = function () {
    var tbl = $("#paging_tbl").DataTable({
      lengthChange: false,
      processing: true,
      serverSide: true,
      "ajax": {
        "url": "/crowd/refund/list",
        'dataType': 'json',
        "type": "POST",
        "data": function (d) {

        },
        "complete": function () {
        }
      },
      "columns": [
        {
          "data": null,
          "render": function (data, type, full, meta) {
            return meta.row + 1 + meta.settings._iDisplayStart;
          }
        },
        {
          "data": null, "render": function (data, type, full, meta) {
            return "<a  href='#'>" + data.orderNo + "</a>";
          }
        },
        {"data": "payWayName"},
        {"data": "reason" , defaultContent:"无"},
        {"data": "statusName"},
        {
          "data": null, "render": function (data, type, full, meta) {
            return timestampConvert(data.gmtCreated);
          }
        },
        {
          "data": null, "render": function (data, type, full, meta) {
              return timestampConvert(data.gmtModified);
            }
        },
        {
            "data": null, "render": function (data, type, full, meta) {
              var orderNo = data.orderNo;
              var payWay = data.payWay;
              var payStatus = data.payStatus;

              if(payStatus === 25){ //申请退款状态
                  return "<button class='btn btn-sm btn-info' onclick='refund(\""+orderNo+"\", \""+payWay+"\")'>通过</button>"+
                          "<button class='btn btn-sm btn-danger' onclick='reject(\"" + orderNo + "\")'>拒绝</button>";
              } else if(payStatus === 28){//申请退款失败
                  return "<button class='btn btn-sm btn-info' onclick='refund(\""+orderNo+"\", \""+payWay+"\")'>通过</button>";
              } else if(payStatus === 30) {//退款中
                  return "退款中";
              } else if(payStatus === 40) {//退款成功
                  return "退款成功";
              } else {
                  return "<button class='btn btn-sm btn-info' onclick='refund(\""+orderNo+"\", \""+payWay+"\")'>通过</button>";
              }
            }
        }
      ]
    });

  }

  function add0(m) {
    return m < 10 ? '0' + m : m
  }

  function timestampConvert(shijianchuo) {
    if(!shijianchuo){
      return "";
    }
    var time = new Date(shijianchuo);
    var y = time.getFullYear();
    var m = time.getMonth() + 1;
    var d = time.getDate();
    var h = time.getHours();
    var mm = time.getMinutes();
    var s = time.getSeconds();
    return y + '-' + add0(m) + '-' + add0(d) + ' ' + add0(h) + ':' + add0(mm) + ':' + add0(s);
  }

  function refund(orderNo, payWay) {
      console.log('orderNo:'+orderNo+',payWay:'+payWay);
      $.ajax({
          url:"/crowd/order/refund",
          method:'POST',
          dataType:"json",
          data:{
              orderNo:orderNo,
              payWay:payWay
          },
          success:function (rs) {
              if(rs.success){
                  alertify.alert("审核通过！");
                  $('#paging_tbl').DataTable().ajax.reload();
              } else {
                  alertify.alert(rs.errorMessage);
              }
          }
      });
  }
  function reject(orderNo) {
      $.ajax({
          url:"/crowd/refund/reject",
          method:'POST',
          dataType:"json",
          data:{
              orderNo:orderNo
          },
          success:function (rs) {
              if(rs.success){
                  alertify.alert("已拒绝！");
                  $('#paging_tbl').DataTable().ajax.reload();
              } else {
                  alertify.alert(rs.errorMessage);
              }
          }
      });
  }
</script>
</body>
</html>