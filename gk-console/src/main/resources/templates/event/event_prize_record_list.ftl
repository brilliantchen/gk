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
  
  $('#dataTable').DataTable({
    filter: false,
    lengthChange: false,
    processing: true,
    ordering: false,
    serverSide: true,
    stateSave:false,
    paging:false,
    info:false,
    ajax : {
      url:"/event/prize/record/list",
      dataType:"json",
      type:"post",
      cache:false,
      dataSrc:"",
      data:function(d){
        d.openId = $("#q_openId").val();
        d.phone = $("#q_phone").val();
        d.userName = $("#q_username").val();
      }
    },
    columns:[
//       { render : function(data, type, full, meta){
//       	return meta.row + 1 + meta.settings._iDisplayStart;
//       }},
      { data : "prizeName" },
      { data : "openId" },
      { data : "phone" },
      { data : "userName" },
      { data : "address" },
      { data : "gmtCreated",render:function(data){
        return new moment(data).format("YYYY-MM-DD HH:mm:ss");
      } }
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
                  <strong>中奖纪录</strong>
                </h3>
              </div>
              <div class="box-body">
                <form id="queryForm" class="form-inline">
                  <div class="form-group">
                    <label for="" class="control-label">openId</label>
                    <input type="text" name="" id="q_openId" class="form-control" placeholder=""/>
                  </div>
                  <div class="form-group">
                    <label for="" class="control-label">手机号</label>
                    <input type="text" name="" id="q_phone" class="form-control" placeholder=""/>
                  </div>
                  <div class="form-group">
                    <label for="" class="control-label">用户名</label>
                    <input type="text" name="" id="q_username" class="form-control" placeholder=""/>
                  </div>
                  <div class="form-group text-center">
                    <button id="queryBtn" class="btn btn-primary" type="button">查询</button>
                    <button id="resetBtn" class="btn btn-default" type="button">重置</button>
                  </div>
                </form>
                <table id="dataTable" class="table table-bordered table-hover">
                  <thead>
                    <tr>
                      <th>奖品</th>
                      <th>openId</th>
                      <th>手机号</th>
                      <th>用户名</th>
                      <th>地址</th>
                      <th>时间</th>
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
  
  <div id="" class="modal fade">
    <div class="modal-dialog" role="document">
      <div class="modal-content">
        <div class="modal-header">
        </div>
        <div class="modal-body">
          
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
          <button id="" type="button" class="btn btn-primary" data-loading-text="提交中...">确定</button>
        </div>
      </div>
    </div>
  </div>
</body>
</html>