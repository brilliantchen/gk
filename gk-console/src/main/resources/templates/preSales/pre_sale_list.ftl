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
                  <h1 class="box-title"><strong>预售项目管理</strong></h1>
                  <div class="pull-right">
                    <a type="button" class="btn btn-primary" href="/pre/add/page">
                      +项目制定
                    </a>
                  </div>
                </div>

                <div class="box-body">
                  <table id="paging_tbl" class="table table-bordered">
                    <thead>
                    <tr>
                      <th>序号</th>
                      <th>项目名称</th>
                      <th>开始日期</th>
                      <th>创建者</th>
                      <th>状态</th>
                      <th>创建日期</th>
                      <th>渠道</th>
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
        "url": "/pre/list/query",
        'dataType': 'json',
        "type": "POST"
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
          return "<a  href='/pre/detail/page/" + data.id + "'>" + data.name + "</a>";
        }
        },
        {
          "data": null, "render": function (data, type, full, meta) {
          return timestampConvert(data.startTime);
        }
        },
        {"data": "creator"},
        {
          "data": null, "render": function (data, type, full, meta) {
          if (data.projectStatus == 10) {
            return "<span class='label label-warning'>待发布</span>";
          } else if (data.projectStatus == 20) {
            return "<span class='label label-success'>已发布</span>";
          }else if (data.projectStatus == 100) {
            return "<span class='label label-default'>已售罄</span>";
          }
          return "";
        }
        },
        {
          "data": null, "render": function (data, type, full, meta) {
          return timestampConvert(data.gmtCreated);
        }
        },
        {
          "data": null, "render": function (data, type, full, meta) {

          if (data.channel == 10) {
            return "<span class='label label-info'>自营</span>";
          } else if (data.channel == 20) {
            return "<span class='label label-info'>提货券</span>";
          }else if (data.channel == 21) {
            return "<span class='label label-info'>提货券-最福利专供</span>";
          }else if (data.channel == 30) {
            return "<span class='label label-info'>活动-微信卡券</span>";
          }
          return "";
        }
        },
        {
          "data": null, "render": function (data, type, full, meta) {
          var el = "<button  class=\"btn btn-default btn-sm\" type='button' onclick='view(\""+data.id+"\")' >详情</button>&nbsp;&nbsp;";
          if (data.projectStatus < 20) {
            el += "<button class=\"btn btn-primary btn-sm\" onclick='edit(\""+data.id+"\")' type='button'  >编辑</button>&nbsp;&nbsp;"
          }
          if (data.projectStatus == 10) {
            el += "<button class=\"btn btn-primary btn-sm\" type=\"button\" onclick='verify(\"" + data.id
                + "\",\"20\")' >发布</button>&nbsp;&nbsp;";
          } else if (data.projectStatus == 20) {
            el += "<button  class=\"btn btn-primary btn-sm\" type='button' onclick='verify(\"" + data.id
                + "\",\"10\")' >停止</button>&nbsp;&nbsp;";
          }
          el += "<button class='btn btn-sm' onclick='showOrders(\""+data.id+"\")'>查看订单</button>&nbsp;&nbsp;"
          el += "<button class='btn btn-sm' onclick='downloadOrders(\""+data.id+"\")'>下载已支付订单</button>"
          return el;
        }
        }
      ]
    });

    $("#queryBtn").on("click", function () {
      $('#paging_tbl').DataTable().ajax.reload();
    });

  }

  var del = function (id) {
    alertify.confirm("确认删除？", function () {
      $.ajax({
        url: '/pre/product/' + id,
        method: 'DELETE',
        dataType: 'json',
        success: function (rs) {
          if (rs.success) {
            alertify.alert("删除成功！");
            $('#paging_tbl').DataTable().ajax.reload();
          } else {
            alertify.alert(rs.msg);
          }
        }
      });
    });
  }

  var verify = function (id, status) {
    alertify.confirm("确认操作？", function () {
      $.ajax({
        url: '/pre/product/status/' + id + "/" + status,
        method: 'GET',
        dataType: 'json',
        success: function (rs) {
          if (rs.success) {
            alertify.success("操作成功！");
            $('#paging_tbl').DataTable().ajax.reload();
          } else {
            alertify.alert(rs.msg);
          }
        }
      });
    });
  }

  function edit(id) {
    window.location.href="/pre/edit/page/"+id;
  }

  function view(id) {
    window.location.href="/pre/detail/page/"+id;
  }

  function add0(m) {
    return m < 10 ? '0' + m : m
  }

  function timestampConvert(shijianchuo) {
    var time = new Date(shijianchuo);
    var y = time.getFullYear();
    var m = time.getMonth() + 1;
    var d = time.getDate();
    var h = time.getHours();
    var mm = time.getMinutes();
    var s = time.getSeconds();
    return y + '-' + add0(m) + '-' + add0(d) + ' ' + add0(h) + ':' + add0(mm) + ':' + add0(s);
  }
  function showOrders(id){
    window.location.href="/order/page?projectId="+id
  }
  function downloadOrders(id){
    window.location.href="/order/downloadPaidOrder?projectId="+id
  }
</script>
</body>
</html>