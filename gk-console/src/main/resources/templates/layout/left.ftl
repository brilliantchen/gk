  <header class="main-header">
    <!-- Logo -->
    <a class="logo">
      <!-- mini logo for sidebar mini 50x50 pixels -->
      <span class="logo-mini"><b>M</b></span>
      <!-- logo for regular state and mobile devices -->
      <span class="logo-lg"><b onclick="javascript:window.location.href='/';" style="cursor:default;">管理系统</b></span>
    </a>

    <!-- Header Navbar: style can be found in header.less -->
    <nav class="navbar navbar-static-top" role="navigation">
      <!-- Sidebar toggle button-->
      <a href="#" class="sidebar-toggle" data-toggle="offcanvas" role="button">
        <span class="sr-only"></span>
      </a>
      <!-- Navbar Right Menu -->
      <div class="navbar-custom-menu">
        <ul class="nav navbar-nav">
          <!-- Messages: style can be found in dropdown.less-->
          <!-- User Account: style can be found in dropdown.less -->
          <li class="dropdown user user-menu">
            <a href="#" class="dropdown-toggle" data-toggle="dropdown">
              <img src="/AdminLTE/dist/img/user2-160x160.jpg" class="user-image" alt="User Image"> <span class="hidden-xs">${Session.SPRING_SECURITY_CONTEXT.authentication.principal.username}</span>
            </a>
            <ul class="dropdown-menu">
              <!-- User image -->
              <li class="user-header"><img src="/AdminLTE/dist/img/user2-160x160.jpg" class="img-circle" alt="User Image">
                <p>${Session.SPRING_SECURITY_CONTEXT.authentication.principal.realName}</p>
              </li>
              <!-- Menu Footer-->
              <li class="user-footer">
                <div class="pull-left">
                  <a href="/user/changePwd/page" class="btn btn-default btn-flat">修改密码</a>
                </div>
                <div class="pull-right">
                  <a href="/logout" class="btn btn-default btn-flat">注销</a>
                </div>
              </li>
            </ul>
          </li>
        </ul>
      </div>
    </nav>
  </header>

<aside class="main-sidebar">
  <section class="sidebar">
    <ul class="sidebar-menu">
      <li class="header">MAIN NAVIGATION</li>

        <li class="treeview">
            <a href="#">
                <i class="fa fa-edit"></i> <span>考拉订单</span>
                <span class="pull-right-container">
              <i class="fa fa-angle-left pull-right"></i>
            </span>
            </a>
            <ul class="treeview-menu">
                <li><a href="/gk/kl/order/page"><i class="fa fa-circle-o"></i>订单查看</a></li>
                <li><a href="#"><i class="fa fa-circle-o"></i>订单取消</a></li>
            </ul>
        </li>

        <li class="treeview">
            <a href="#">
                <i class="fa fa-edit"></i> <span>管易发货单</span>
                <span class="pull-right-container">
              <i class="fa fa-angle-left pull-right"></i>
            </span>
            </a>
            <ul class="treeview-menu">
                <li><a href="/gk/gy/order/error/page"><i class="fa fa-circle-o"></i>下单异常监控</a></li>
            </ul>
        </li>

    </ul>
  </section>
</aside>
<script>
  $(function(){
	var url = window.location.pathname;
    var a=$(".sidebar-menu a[href='"+url+"']");
    a.closest(".menuLi").addClass("active");
    a.closest(".menuTopLi").addClass("active");
  })
</script>