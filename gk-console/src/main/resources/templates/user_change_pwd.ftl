<!DOCTYPE html>
<html>
<head>
<#include "/layout/header.ftl" />
<script>
$(function(){
  $("#changePwdForm").ajaxForm({
    dataType:"json",
    success:function(data){
      if(data.success){
        alertify.alert("修改密码成功",function(){
          location.href="/logout"
        })
      }else{
        alertify.alert(data.errMsg||data.errorMessage);
      }
    },error:function(jq,status,e){
      alertify.alert(status);
    }
  })
  $("input").on("input",function(){
  })

  
})

</script>
<style type="text/css">
 input:invalid,input:focus:invalid {
   border-color: #dd4b39
 }
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
                  <strong>修改密码</strong>
                </h3>
              </div>
              <div class="box-body">
                <form id="changePwdForm" action="/user/changePwd/do" class="form-horizontal">
                  <div class="form-group">
                    <label class="control-label col-sm-2">用户名</label>
                    <div class="col-sm-8">
                      <p class="form-control-static">${username!}</p>
                    </div>
                  </div>
                  <div class="form-group">
                    <label class="control-label col-sm-2">原密码</label>
                    <div class="col-sm-8">
                      <input class="form-control" type="password" name="initPwd" required />
                    </div>
                  </div>
                  <div class="form-group">
                    <label class="control-label col-sm-2">新密码</label>
                    <div class="col-sm-8">
                      <input class="form-control" type="password" name="password" required />
                    </div>
                  </div>
                  <div class="form-group">
                    <div class="col-sm-offset-2 col-sm-8">
                      <button type="submit" class="btn btn-default">确定</button>
                    </div>
                  </div>
                
                </form>
              
              </div>
            </div>
          </div>
        </div>
      </section>
    </div>
  </div>
  
 
</body>
</html>