<!DOCTYPE html>
<html>
<head>
<#include "/layout/header.ftl" />
<style type="text/css">
  .wxPic{
    max-width: 100px;
    max-height: 100px;
  }
</style>
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
      url:"/event/user/list",
      type:"post",
      data:function(d){
        var openId = $("#queryForm input[name='openId']").val();
        openId && (d.openId = openId)
        var wxName = $("#queryForm input[name='wxName']").val();
        wxName && (d.wxName = wxName)
        var mobile = $("#queryForm input[name='mobile']").val();
        mobile && (d.mobile = mobile)
      }
    },
    columns:[
      { data : "openId" },
      { data : "wxName" },
      { data : "wxPic",render:function(data){
        if(!data){
          return "";
        }
        return "<img src='"+data+"' class='wxPic'>"
      } },
      { data : "mobile" },
      { data : "chickLegNo" },
      { data : "winNo" },
      { data : "prizeTimes" },
      { data : "stepPkTimes" },
      { data : "repickChickTimes" },
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
                  <strong>活动用户</strong>
                </h3>
              </div>
              <div class="box-body">
                <form id="queryForm" class="form-inline">
                  <div class="form-group">
                    <label for="" class="control-label">openId</label>
                    <input type="text" name="openId" id="" class="form-control"/>
                  </div>
                  <div class="form-group">
                    <label for="" class="control-label">微信昵称</label>
                    <input type="text" name="wxName" id="" class="form-control"/>
                  </div>
                  <div class="form-group">
                    <label for="" class="control-label">手机号</label>
                    <input type="text" name="mobile" id="" class="form-control"/>
                  </div>
                  <div class="form-group text-center">
                    <button id="queryBtn" class="btn btn-primary" type="button">查询</button>
                    <button id="resetBtn" class="btn btn-default" type="button">重置</button>
                  </div>
                </form>
                <table id="dataTable" class="table table-bordered table-hover">
                  <thead>
                    <tr>
                      <th>openId</th>
                      <th>微信昵称</th>
                      <th>头像</th>
                      <th>手机号</th>
                      <th>鸡腿数</th>
                      <th>连胜数</th>
                      <th>剩余抽奖数</th>
                      <th>剩余pk数</th>
                      <th>剩余重选数</th>
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