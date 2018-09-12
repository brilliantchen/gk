<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  <title>登录</title>
  <!-- Tell the browser to be responsive to screen width -->
  <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport" />
  <!-- Bootstrap 3.3.6 -->
  <link rel="stylesheet" href="/AdminLTE/bootstrap/css/bootstrap.min.css" />
  <!-- Font Awesome -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.5.0/css/font-awesome.min.css" />
  <!-- Ionicons -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/ionicons/2.0.1/css/ionicons.min.css" />
  <!-- Theme style -->
  <link rel="stylesheet" href="/AdminLTE/dist/css/AdminLTE.min.css" />
  <!-- iCheck -->
  <link rel="stylesheet" href="/AdminLTE/plugins/iCheck/square/blue.css" />
</head>
<body class="hold-transition login-page">
  <div class="login-box">
    <!--   <div class="login-logo"> -->
    <!--     <a href="../../index2.html"><b>Admin</b>LTE</a> -->
    <!--   </div> -->
    <!-- /.login-logo -->
    <div class="login-box-body">
      <p class="login-box-msg">登 录</p>
      <form action="/loginVefify" method="post">
        <div class="form-group has-feedback">
          <input type="text" id="username" name="username" class="form-control" placeholder="用户名/手机号/邮箱" />
          <span class="glyphicon glyphicon-user form-control-feedback"></span>
        </div>
        <div class="form-group has-feedback">
          <input type="password" id="password" name="password" class="form-control" placeholder="密码" />
          <span class="glyphicon glyphicon-lock form-control-feedback"></span>
        </div>
        <div class="row">
          <div class="col-xs-8">
            <div class="checkbox icheck">
              <label> <input name="remember-me" type="checkbox" /> 记住我
              </label>
            </div>
          </div>
          <!-- /.col -->
          <div class="col-xs-4">
            <button type="submit" class="btn btn-primary btn-block btn-flat">登录</button>
          </div>
          <!-- /.col -->
        </div>
      </form>


      <a href="#">忘记密码？联系管理员</a><br />

    </div>
    <!-- /.login-box-body -->
  </div>
  <!-- /.login-box -->

  <!-- jQuery 2.2.3 -->
  <script src="/AdminLTE/plugins/jQuery/jquery-2.2.3.min.js"></script>
  <!-- Bootstrap 3.3.6 -->
  <script src="/AdminLTE/bootstrap/js/bootstrap.min.js"></script>
  <!-- iCheck -->
  <script src="/AdminLTE/plugins/iCheck/icheck.min.js"></script>
  <script>
    $(function() {
      $('input').iCheck({
        checkboxClass : 'icheckbox_square-blue',
        radioClass : 'iradio_square-blue',
        increaseArea : '20%' // optional
      });

    });
  </script>
</body>
</html>
