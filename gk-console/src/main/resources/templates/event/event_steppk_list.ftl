<!DOCTYPE html>
<html>
<head>
<#include "/layout/header.ftl" />
<script>
$(function(){
  var pkStatus={"1":"发起成功","2":"应战结束","10":"超时取消"};
  var pkResult={"1":"发起胜","2":"应战胜","10":"超时取消"};
  var pkLevel={"1":"大排档","10":"农家乐","30":"小餐馆","100":"大酒店","500":"米其林"}
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
      url:"/event/steppk/list",
      type:"post",
      data:function(d){
        var userName = $("#queryForm input[name='userName']").val();
        userName && (d.userName = userName)
      }
    },
    columns:[
      { data : "starter",render:function(data,type,full){
        return "openId: "+full.starter +
        "<br>微信昵称: "+full.starterName +
        "<br>品种(步数): "+full.starterChick.name + " ("+full.starterChick.step+")" +
        "<br>pk前连"+ bar(full.startervPreWinNo) + ",pk后连"+ bar(full.startervPostWinNo)
      } },
      { data : "responder",render:function(data,type,full){
        if(!data){
          return ""
        }else{
          return "openId: "+full.responder +
          "<br>微信昵称: "+full.responderName +
          "<br>品种(步数): "+(full.responderChick||{}).name + " ("+(full.responderChick||{}).step+")" +
          "<br>pk前连"+ bar(full.responderPreWinNo) + ",pk后连"+ bar(full.responderPostWinNo)
        }
      } },
      { data : "pkLevel",render:function(data){
        return pkLevel[data] || "";
      } },
      { data : "pkLegs" },
      { data : "status",render:function(data){
        return data && pkStatus[data] || "";
      } },
      { data : "result",render:function(data){
        return data && pkResult[data] || "";
      } },
      { data : "pkDate",defaultContent:"",render:function(data){
          return data && new moment(data).format("YYYY-MM-DD HH:mm:ss") || "";
      } },
	]
  });
  
})

function bar(num){
  if(num<0){
    return "败："+(-num);
  }else{
    return "胜："+num;
  }
}

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
                  <strong>pk记录</strong>
                </h3>
              </div>
              <div class="box-body">
                <form id="queryForm" class="form-inline">
                  <div class="form-group">
                    <label for="" class="control-label">用户</label>
                    <input type="text" name="userName" id="" class="form-control" placeholder="发起者/迎战者，openId/微信昵称" style="width: 300px"/>
                  </div>
<!--                   <div class="form-group"> -->
<!--                     <label for="" class="control-label">应战者</label> -->
<!--                     <input type="text" name="" id="" class="form-control" placeholder=""/> -->
<!--                   </div> -->
                  <div class="form-group text-center">
                    <button id="queryBtn" class="btn btn-primary" type="button">查询</button>
                    <button id="resetBtn" class="btn btn-default" type="button">重置</button>
                  </div>
                </form>
                <table id="dataTable" class="table table-bordered table-hover">
                  <thead>
                    <tr>
                      <th>发起者</th>
<!--                       <th>昵称</th> -->
<!--                       <th>品种</th> -->
<!--                       <th>步数</th> -->
                      <th>迎战者</th>
<!--                       <th>昵称</th> -->
<!--                       <th>品种</th> -->
<!--                       <th>步数</th> -->
                      <th>pk级别</th>
                      <th>消耗鸡腿</th>
                      <th>状态</th>
                      <th>结果</th>
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