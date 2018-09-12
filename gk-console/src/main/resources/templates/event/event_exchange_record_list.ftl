<!DOCTYPE html>
<html>
<head>
<#include "/layout/header.ftl" />
<script>
$(function(){
  $("#queryForm").resetForm();
  $("#queryBtn").on("click",function(){
    $("#dataTable").DataTable().ajax.reload();
  })
  $("#resetBtn").on("click",function(){
    $("#queryForm").resetForm();
    $("#dataTable").DataTable().ajax.reload();
  })
  
  var table = $('#dataTable').DataTable({
    filter: false,
    lengthChange: false,
    processing: true,
    ordering: false,
    serverSide: true,
    stateSave:false,
    ajax : {
      url:"/event/exchange/record/list",
      type:"post",
      data:function(d){
      }
    },
    columns:[
      { data : "openId" },
      { data : "userName" },
      { data : "phone" },
      { data : "address" },
      { data : "productId" },
	]
  });
  
})

</script>
<style type="text/css">
</style>
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
                  <strong>兑换记录</strong>
                </h3>
              </div>
              <div class="box-body">
                <table id="dataTable" class="table table-bordered table-hover">
                  <thead>
                    <tr>
                      <th>openId</th>
                      <th>用户名</th>
                      <th>手机号</th>
                      <th>收货地址</th>
                      <th>商品id</th>
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
  
  
</body>
</html>