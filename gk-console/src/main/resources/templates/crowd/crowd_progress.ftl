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
              <h1 class="box-title"><strong>众筹进度</strong></h1>
              <div class="pull-right">
                <a type="button" class="btn btn-default" href="/crowd/list/page">
                  返回
                </a>
                <a type="button" class="btn btn-primary" data-toggle="modal"
                   data-target="#VMRegisterModal">
                  +新增-进度
                </a>
              </div>
            </div>

            <div class="box-body">
              <table id="paging_tbl" class="table table-bordered">
                <thead>
                <tr>
                  <th>序号</th>
                  <th>标题</th>
                  <th>日期</th>
                  <th>内容</th>
                  <th>当前环节</th>
                  <th>操作</th>
                </tr>
                </thead>

              </table>
            </div>


          </div>
        </div>
      </div>

      <div class="modal fade" id="VMRegisterModal" tabindex="-1" role="dialog"
           aria-labelledby="myModalLabel">
        <div class="modal-dialog" role="document">
          <div class="modal-content ">
            <form id="addForm">
              <div class="modal-body">
                <div class="form-horizontal">
                  <input type="hidden" name="projectId" id="projectId" value="${projectId}">
                  <input type="hidden" name="id" id="add_id" value="">
                  <div class="form-group">
                    <label for="i_used_date" class="col-sm-3 control-label">标题：</label>
                    <div class="col-sm-5">
                      <input type="text" class="form-control" id="add_progressTitle"
                             name="progressTitle"
                             placeholder="请输入标题">
                    </div>
                  </div>


                  <div class="form-group">
                    <label for="i_medicine_name" class="col-sm-3 control-label">内容：</label>
                    <div class="col-sm-8">
                      <textarea cols="" rows="3"  id="add_progressIntro" style="width:100%"
                             name="progressIntro"></textarea>
                    </div>
                  </div>


                  <div class="form-group">
                    <label for="i_used_date" class="col-sm-3 control-label">日期：</label>
                    <div class="col-sm-5">
                      <input type="text" class="form-control" id=add_progressDate
                             name="progressDate"
                             placeholder="日期">
                    </div>
                  </div>

                  <div class="form-group">
                    <label for="i_used_date" class="col-sm-3 control-label">当前环节：</label>
                    <div class="col-sm-5">
                      <label class="radio-inline"><input type="radio" name="currentProgress"
                                                         value="Y">是</label>
                      <label class="radio-inline"><input type="radio" name="currentProgress" checked
                                                         value="N" checked>否</label>
                    </div>
                  </div>


                  <div class="modal-footer">
                    <div class="col-sm-offset-2 col-sm-10">
                      <button type="button" class="btn btn-default" data-dismiss="modal"
                              id="cancel">取消
                      </button>
                      <button type="button" class="btn btn-primary" onclick="save()">确定</button>
                    </div>
                  </div>
                </div>
              </div>
            </form>
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
    $('#VMRegisterModal').on('hide.bs.modal', function () {
      clearModal();
    });
    $("#add_progressDate").val(timeConvert(new Date()));
    $("#add_progressDate").datetimepicker({
      minView: "month",
      format: 'yyyy-mm-dd',
      autoclose: true,
      todayBtn: true
    });
    $("#add_progressDate").datetimepicker().on('hide', function (event) {
      event.preventDefault();
      event.stopPropagation();
    });
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
        "url": "/crowd/product/progress/list",
        'dataType': 'json',
        "type": "POST",
        "data": function (d) {
          d.projectId = $("#projectId").val();
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

        {"data": "progressTitle"},
        {"data": "progressDate"},
        {"data": "progressIntro"},
        {"data": "currentProgress"},
        {
          "data": null, "render": function (data, type, full, meta) {
          var el = "<a  href='javascript:void(0)' onclick='edit(\"" + data.id
              + "\")' type='button'  >编辑</a>&nbsp;&nbsp;";
          el += "<a  href='javascript:void(0)' type='button' onclick='del(\"" + data.id
              + "\")' >删除</a>&nbsp;&nbsp;";
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
        url: '/crowd/product/progress/' + id,
        method: 'DELETE',
        dataType: 'json',
        success: function (rs) {
          if (rs.success) {
            alertify.success("删除成功！");
            $('#paging_tbl').DataTable().ajax.reload();
          } else {
            alertify.alert(rs.msg);
          }
        }
      });
    });
  }

  var save = function () {
    if (!mandatoryValidate()) {
      return;
    }
    $.ajax({
      url: '/crowd/product/progress/add',
      method: 'POST',
      dataType: 'json',
      data: $("#addForm").serialize(),
      success: function (rs) {
        $("#VMRegisterModal").modal('hide');
        if (rs.success) {
          alertify.success("操作成功！");
          $('#paging_tbl').DataTable().ajax.reload();
        } else {
          alertify.error(rs.msg);
        }
      }
    });
  }

  var edit = function (id) {
    $("#VMRegisterModal").modal('show');

    $.ajax({
      url: '/crowd/product/progress/' + id,
      method: 'GET',
      dataType: 'json',
      success: function (rs) {
        if (rs.success) {
          fillStation(rs.value)
        } else {
          alert(rs.msg);
        }
      }
    });
  }

  var fillStation = function (obj) {
    $("#add_id").val(obj.id);
    $("#add_progressTitle").val(obj.progressTitle);
    $("#add_progressIntro").val(obj.progressIntro);
    $("#add_progressDate").val(obj.progressDate);
    $(":radio[name='currentProgress'][value='" + obj.currentProgress + "']").prop("checked",
        "checked");
  }

  var mandatoryValidate = function () {
    if ($("#add_progressTitle").val() == "") {
      alertify.error("请输入标题！");
      return false;
    } else if ($("#add_progressIntro").val() == "") {
      alertify.error("请输入内容！");
      return false;
    } else if ($("#add_progressDate").val() == "") {
      alertify.error("请选择日期！");
      return false;
    }
    return true;
  }

  var clearModal = function (obj) {
    $("#add_id").val("");
    $("#add_progressTitle").val("");
    $("#add_progressIntro").val("");
    $("#add_progressDate").val(timeConvert(new Date()));
    $(":radio[name='currentProgress'][value='N']").prop("checked", "checked");
  }

  function add0(m) {
    return m < 10 ? '0' + m : m
  }

  function timeConvert(time) {
    var y = time.getFullYear();
    var m = time.getMonth() + 1;
    var d = time.getDate();
    return y + '-' + add0(m) + '-' + add0(d);
  }

</script>
</body>
</html>