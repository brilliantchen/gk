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
              <h1 class="box-title"><strong>众筹管理</strong></h1>
              <div class="pull-right">
                <a type="button" class="btn btn-primary" href="/crowd/add/page">
                  +发起众筹
                </a>
              </div>
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
                  <th>项目名称</th>
                  <th>金额/份</th>
                  <th>目标金额</th>
                <#--<th>支持人数</th>
                <th>已筹集金额</th>-->
                  <th>开始日期</th>
                  <th>结束日期</th>
                  <th>状态</th>
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
        "url": "/crowd/product/list",
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
          return "<a  href='/crowd/view/page/" + data.id + "'>" + data.projectName + "</a>";
        }
        },
        {"data": "minFundraising"},
        {"data": "fundraisingGoal"},
        /*{"data": "fundraisingUserNum"},
        {"data": "fundraisingAmount"},*/
        {
          "data": null, "render": function (data, type, full, meta) {
          return timestampConvert(data.projectCreatedTime);
        }
        },
        {timestampConvert
          "data": null, "render": function (data, type, full, meta) {
          return timestampConvert(data.projectFundraisingEndTime);
        }
        },
        {"data": "statusName"},
        {
          "data": null, "render": function (data, type, full, meta) {
          var el = "<a  href='/crowd/product/progress/page/" + data.id
              + "' type='button' >进度</a>&nbsp;&nbsp;";
          if (data.projectStatus < 20) {
            el += "<a  href='/crowd/edit/page/" + data.id + "' type='button'  >编辑</a>&nbsp;&nbsp;"
            el += "<a  href='javascript:void(0)' type='button' onclick='del(\"" + data.id
                + "\")' >删除</a>&nbsp;&nbsp;";
          }
          if (data.projectStatus == 1 || data.projectStatus == 4) {
            el += "<a  href='javascript:void(0)' type='button' onclick='verify(\"" + data.id
                + "\",\"2\")' >提交审核</a>&nbsp;&nbsp;";
          } else if (data.projectStatus == 2) {
            el += "<a  href='javascript:void(0)' type='button' onclick='verify(\"" + data.id
                + "\",\"6\")' >通过</a>&nbsp;&nbsp;";
            el += "<a  href='javascript:void(0)' type='button' onclick='verify(\"" + data.id
                + "\",\"4\")' >拒绝</a>&nbsp;&nbsp;";
          } else if (data.projectStatus == 6) {
            el += "<a  href='javascript:void(0)' type='button' onclick='verify(\"" + data.id
                + "\",\"10\")' >上架</a>&nbsp;&nbsp;";
          } else if (data.projectStatus == 10) {
            el += "<a  href='javascript:void(0)' type='button' onclick='verify(\"" + data.id
                + "\",\"20\")' >开放</a>&nbsp;&nbsp;";
          } else if (data.projectStatus == 20) {
            el += "<a  href='javascript:void(0)' type='button' onclick='verify(\"" + data.id
                + "\",\"30\")' >成功</a>&nbsp;&nbsp;";
            el += "<a  href='javascript:void(0)' type='button' onclick='verify(\"" + data.id
                + "\",\"40\")' >失败</a>&nbsp;&nbsp;";
          }
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
        url: '/crowd/product/' + id,
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