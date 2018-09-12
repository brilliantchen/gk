<!DOCTYPE html>
<html>
<head>
<#include "/layout/header.ftl" />
<script>
$(function(){
  var eventType={"1":"初始化","2":"首次关注","3":"每日签到","10":"小鸡PK","50":"购买步步鸡","60":"兑换商品","70":"抽奖"}
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
      url:"/event/chickleg/log/list",
      type:"post",
      data:function(d){
        var openId = $("#queryForm input[name='openId']").val();
        openId && (d.openId = openId)
        d.eventType = $("#queryForm select[name='eventType']").val()||null
      }
    },
    columns:[
      { data : "openId" },
      { data : "eventId" },
      { data : "eventType",render:function(data){
        return eventType[data];
      } },
      { data : "participantRole" },
      { data : "desc" },
      { data : "num" },
      { data : "date",render:function(data){
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
                  <strong>鸡腿记录</strong>
                </h3>
              </div>
              <div class="box-body">
                <form id="queryForm" class="form-inline">
                  <div class="form-group">
                    <label for="" class="control-label">openId</label>
                    <input type="text" name="openId" class="form-control" placeholder=""/>
                  </div>
                  <div class="form-group">
                    <label for="" class="control-label">类型</label>
                    <select name="eventType" class="form-control" placeholder="">
                      <option></option>
                      <option value="1">初始化</option>
                      <option value="2">首次关注</option>
                      <option value="3">每日签到</option>
                      <option value="10">小鸡PK</option>
                      <option value="50">购买步步鸡</option>
                      <option value="60">兑换商品</option>
                      <option value="70">抽奖</option>
                    </select>
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
                      <th>关联id</th>
                      <th>活动类型</th>
                      <th>参与角色</th>
                      <th>说明</th>
                      <th>数量</th>
                      <th>日期</th>
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