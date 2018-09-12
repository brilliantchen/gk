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
              <#--<h1 class="box-title"><strong>众筹管理</strong></h1>
              <div class="pull-right">
                <a type="button" class="btn btn-primary" href="/crowd/add/page">
                  +发起众筹
                </a>
              </div>-->
            </div>


          <#--<div class="box-body">
            <form class="form-horizontal" role="form">
              <div class="form-group">
                <label for="status" class="control-label col-sm-1">类型</label>
                <div class="col-sm-1">
                  <select class="form-control" id="type" name="type">
                    <option value="0" selected="selected">请选择</option>

                  </select>
                </div>

                <label for="status" class="control-label col-sm-1">状态</label>
                <div class="col-sm-1">
                  <select class="form-control" id="stage" name="stage">
                    <option value="0" selected="selected">请选择</option>

                  </select>
                </div>


                <label class="col-sm-1 control-label">计划日期</label>
                <div class="col-sm-2">
                  <input type="text" class="form-control" id="planDate" name="planDate"
                         placeholder="计划日期">
                </div>

              </div>
              <div class="form-group">
                <label class="control-label col-sm-1">所在地点</label>
                <div data-toggle="distpicker" id="distpicker2">
                  <div class=" col-sm-2"><select class="form-control" id="stq_provinceId"
                                                 data-province="选择省 "></select></div>
                  <div class=" col-sm-2"><select class=form-control id="stq_cityId"
                                                 data-city="选择市 "></select></div>
                  <div class=" col-sm-2"><select class="form-control" id="stq_countyId"
                                                 data-district="选择区 "></select></div>
                </div>

                <div class=" col-sm-2">
                  <button type="button" class="btn btn-primary" id="queryBtn">查询</button>
                </div>
              </div>
            </form>
          </div>-->

            <div class="box-body">
              <table id="paging_tbl" class="table table-bordered">
                <thead>
                <tr>
                  <th>序号</th>
                  <th>单号</th>
                  <th>考拉错误</th>
                  <th>管易错误</th>
                  <th class="col-sm-2">操作</th>
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
      "bFilter": false, //过滤功能
      "bSort": false, //排序功能
      "bLengthChange": false, //改变每页显示数据数量
      "oLanguage": {
        "sLengthMenu": "每页显示 _MENU_ 条记录",
        "sZeroRecords": "抱歉， 没有找到",
        "sInfo": "从 _START_ 到 _END_ /共 _TOTAL_ 条数据",
        "sInfoEmpty": "没有数据",
        "sInfoFiltered": "(从 _MAX_ 条数据中检索)",
        "oPaginate": {
          "sFirst": "首页",
          "sPrevious": "前一页",
          "sNext": "后一页",
          "sLast": "尾页"
        },
        "sZeroRecords": "没有检索到数据"
      },
      "processing": true,
      "serverSide": true,
      "ajax": {
        "url": "/gk/gy/order/error/list",
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
                  return "<a  href='#'>" + data.orderId + "</a><br>"+data.thirdPartyId;
              }
          },
          {
              "data": null, "render": function (data, type, full, meta) {
                  var el = "";
                  if (data.klConfirmError != null && data.klConfirmError != "") {
                      el += "<div>下单错误：\""+data.klConfirmError+"\"</div><br>"
                  }
                  if (data.klPayError != null && data.klPayError != "") {
                      el += "<div>支付错误：\""+data.klPayError+"\"</div><br>"
                  }
                  if (data.klCancelError != null && data.klCancelError != "") {
                      el += "<div>取消错误：\""+data.klCancelError+"\"</div><br>"
                  }
                  return el;
              }
          },
          {
              "data": null, "render": function (data, type, full, meta) {
                  var el = "";
                  if (data.gyWhousError != null && data.gyWhousError != "") {
                      el += "<div>转入外仓错误：\""+data.gyWhousError+"\"</div><br>"
                  }
                  if (data.gyPrintExpressError != null && data.gyPrintExpressError != "") {
                      el += "<div>打单错误：\""+data.gyPrintExpressError+"\"</div><br>"
                  }
                  if (data.gySyncExpressError != null && data.gySyncExpressError != "") {
                      el += "<div>同步物流错误：\""+data.gySyncExpressError+"\"</div><br>"
                  }
                  return el;
              }
          },

        /*{
          "data": null, "render": function (data, type, full, meta) {
          return timestampConvert(data.projectCreatedTime);
          }
        },
        {
          "data": null, "render": function (data, type, full, meta) {
          return timestampConvert(data.projectFundraisingEndTime);
        }
        },*/
        {
          "data": null, "render": function (data, type, full, meta) {
           var ope = "<div>创建：\""+timestampConvert(data.createTime)+"\"</div><br><div>更新：\""+timestampConvert(data.updateTime)+"\"</div><br>";
           ope += "<a  href='javascript:void(0)' type='button' onclick='del(\"" + data.orderId
                  + "\")' >删除</a>&nbsp;&nbsp;";
            return ope;
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
        url: '/gk/gy/order/error/'+id+'/del',
        method: 'GET',
        dataType: 'json',
        success: function (rs) {
          if (rs.respCode == 200) {
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
        url: '/crowd/product/status/' + id + "/" + status,
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

</script>
</body>
</html>