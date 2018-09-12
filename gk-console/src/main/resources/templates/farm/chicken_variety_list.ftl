<!DOCTYPE html>
<html>
<head>
<#include "/layout/header.ftl">
<script src="/bootstrap-fileinput/js/fileinput.js"></script>
<script src="/ossInput.js"></script>

<script>
$(function() {
    //上传图片
    $.ajax("/get_signature", {
        dataType: "json",
        cache: false,
        method: "post"
    }).done(function (signature) {
        $("#picture").ossInput(signature, "#pictureUrl");
    });

    $.ajax("/get_signature", {
        dataType: "json",
        cache: false,
        method: "post"
    }).done(function (signature) {
        $("#pictureUpd").ossInput(signature, "#pictureUrlUpd");
    });

    $("#queryForm").resetForm();

    $("#queryBtn").on("click",function(){
        $("#dataTable").DataTable().ajax.reload();
    })

    $("#resetBtn").on("click",function(){
        $("#queryForm").resetForm();
        $("#dataTable").DataTable().ajax.reload();
    })

    var oTable = $('#dataTable').DataTable({
        "processing": true,
        "serverSide": true,
        "retrieve": true,
        "bSort": false, //排序功能
        "bFilter": false, //过滤功能
        "bLengthChange": false,
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
        ajax: function (data, callback, settings) {
            //封装请求参数
            var param = {};
            param.length = data.length;//每页显示记录条数
            param.start = (data.start / data.length);//当前页码
            param.type = $("#typeQ").val();
            param.location = $("#locationQ").val(),

            $.ajax({
                type: "GET",
                url: "/chickenVariety/list",
                cache: false,
                data: param,
                dataType: "json",
                success: function (res) {
                    setTimeout(function () {
                        var returnData = {};
                        returnData.recordsTotal = res.value.totalElements;//返回数据全部记录
                        returnData.recordsFiltered = res.value.totalElements;//后台不实现过滤功能，每次查询均视作全部结果
                        returnData.data = res.value.content;//返回的数据列表
                        callback(returnData);
                    }, 200);
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    console.log("查询失败");
                }
            });
        },
        columns: [
            {data: "id"},
            {data: "type"},
            {data: "location"},
            {data: "character"},
            {data: "pictureUrl"},
            {data: "comment"},
            {data: "id",
                render: function (data, type, full) {
                    return '<button type="button" class="btn btn-default" data-toggle="modal" data-target="#edit" data-id="'+data+'">编辑</button>' +
                            "&nbsp;"+'<button type="button" class="btn btn-danger delete" value="' + data + '">删除</button>';
                }
            }
        ]
    });

    //新增农场
    $('#submitBtn').on('click', function () {
        var type = $('#type').val();
        if (isNull(type)) {
            alert("请输入鸡只品种");
            return;
        }

        var location = $('#location').val();
        if (isNull(location)) {
            alert("请输入产地");
            return;
        }

        var character = $('#character').val();
        if (isNull(character)) {
            alert("请输入特性");
            return;
        }

        var comment = $('#comment').val();

        var pictureUrl = $("#pictureUrl").val();
        if (isNull(pictureUrl)) {
            alert("请添加照片");
            return;
        }

        $.ajax({
            url: '/chickenVariety/add',
            method: 'POST',
            dataType: 'json',
            data: {
                type: type,
                location: location,
                character: character,
                comment: comment,
                pictureUrl: pictureUrl
            },
            success: function (rs) {
                if (rs.success) {
                    if (rs.value) {
                        window.location.href = "/chickenVariety/page";
                    } else {
                        alert(rs.errorMessage);
                        return;
                    }
                } else {
                    alert(rs.errorMessage);
                    return;
                }
            }
        })
    });

    $('#edit').on('shown.bs.modal', function (event) {
        var button = $(event.relatedTarget); // Button that triggered the modal
        var id = button.data('id');
        var obj;
        $.ajax({
            url: '/chickenVariety/query/' + id,
            type: 'GET',
            dataType: 'json',
            async : false,
            success: function (rs) {
                if (rs) {
                    obj = rs.value;
                }
            }
        });
        var modal = $(this);
        modal.find('#id').val(obj.id);
        modal.find('#typeUpd').val(obj.type);
        modal.find('#locationUpd').val(obj.location);
        modal.find('#characterUpd').val(obj.character);
        modal.find('#pictureUrlUpd').val(obj.pictureUrl);
        modal.find('#commentUpd').val(obj.comment);
    });

    $('#edit').on('hidden.bs.modal', function (event) {
        var button = $(event.relatedTarget); // Button that triggered the modal
        var modal = $(this);
        modal.find('#id').val("");
        modal.find('#typeUpd').val("");
        modal.find('#locationUpd').val("");
        modal.find('#characterUpd').val("");
        modal.find('#pictureUrlUpd').val("");
        modal.find('#commentUpd').val("");
    });

    $(document).on('click', '#submitUpd', function () {
        var id = $("#id").val();

        var type = $('#typeUpd').val();
        if (isNull(type)) {
            alert("请输入鸡只品种");
            return;
        }

        var location = $('#locationUpd').val();
        if (isNull(location)) {
            alert("请输入产地");
            return;
        }

        var character = $('#characterUpd').val();
        if (isNull(character)) {
            alert("请输入特性");
            return;
        }

        var comment = $('#commentUpd').val();

        var pictureUrl = $("#pictureUrlUpd").val();
        if (isNull(pictureUrl)) {
            alert("请添加照片");
            return;
        }

        $.ajax({
            url: '/chickenVariety/update',
            method: 'POST',
            dataType: 'json',
            data: {
                id: id,
                type: type,
                location: location,
                character: character,
                comment: comment,
                pictureUrl: pictureUrl
            },
            success: function (rs) {
                if (rs.success) {
                    if (rs.value) {
                        window.location.href = "/chickenVariety/page";
                    } else {
                        alert(rs.errorMessage);
                        return;
                    }
                } else {
                    alert(rs.errorMessage);
                    return;
                }
            }
        })
    });

    // 删除
    $(document).on('click', '.delete', function () {
        var id= $(this).val();
        if(confirm("确定删除？")) {
            $.ajax({
                url: '/chickenVariety/del/'+id,
                type: 'DELETE',
                dataType: 'json',
                success: function (rs) {
                    if (rs.success) {
                        alert("删除成功");
                        window.location.href = "/chickenVariety/page";
                    } else {
                        alert(rs.errorMessage);
                    }
                }
            });
        }
    });
 });
</script>

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
                  <strong>鸡苗信息</strong>
                </h3>
                <button type="button" class="btn btn-primary pull-right" data-toggle="modal"
                        data-target="#create_modal">
                    新增鸡苗
                </button>
              </div>
              <div class="box-body">
                <form id="queryForm" class="form-horizontal">
                  <div class="form-group">
                    <label for="" class="control-label col-md-1">品种</label>
                    <div class="col-md-3">
                      <input type="text" id="typeQ" class="form-control col-md-2" />
                    </div>
                    <label for="" class="control-label col-md-1">产地</label>
                    <div class="col-md-3">
                      <input type="text" id="locationQ" class="form-control col-md-2" />
                    </div>
                  </div>
                  <div class="form-group text-center">
                    <button id="queryBtn" class="btn btn-primary" type="button">查询</button>
                    <button id="resetBtn" class="btn btn-default" type="button">重置</button>
                  </div>
                </form>
                <table id="dataTable" class="table table-bordered table-hover" style="width: 100%">
                  <thead>
                    <tr>
                      <th>id</th>
                      <th>品种</th>
                      <th>产地</th>
                      <th>特性</th>
                      <th>照片</th>
                      <th>备注</th>
                      <th>操作</th>
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

  <div class="modal fade" id="create_modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
      <div class="modal-dialog" role="document">
          <div class="modal-content">
              <div class="modal-body">
                  <form id="farm_form" class="form-horizontal">
                      <div class="form-group">
                          <label class="col-sm-2 control-label">品种<span style="color:red">*</span></label>
                          <div class="col-sm-9">
                              <input type="text" class="form-control" id="type">
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">产地<span style="color:red">*</span></label>
                          <div class="col-sm-9">
                              <input type="text" class="form-control" id="location">
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">特性<span style="color:red">*</span></label>
                          <div class="col-sm-9">
                              <input type="text" class="form-control" id="character">
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">备注</label>
                          <div class="col-sm-9">
                              <input type="text" class="form-control" id="comment">
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">照片<span style="color:red">*</span></label>
                          <div class="col-sm-9">
                              <input type="file" class="form-control" id="picture" name="picture">
                          </div>
                          <div class="col-sm-9 help-block">
                              <input type="hidden" id="pictureUrl" value="">
                          </div>
                      </div>
                  </form>
              </div>
              <div class="modal-footer">
                  <button type="button" class="btn btn-default" data-dismiss="modal" id="cancel">取消</button>
                  <button type="button" class="btn btn-primary" id="submitBtn">确定</button>
              </div>
          </div>
      </div>
  </div>

  <div class="modal fade" id="edit" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
      <div class="modal-dialog" role="document">
          <div class="modal-content">
              <div class="modal-body">
                  <form id="farm_form" class="form-horizontal">
                      <div class="form-group">
                          <div class="col-sm-10">
                              <input type="hidden" class="form-control" id="id"/>
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">品种<span style="color:red">*</span></label>
                          <div class="col-sm-9">
                              <input type="text" class="form-control" id="typeUpd">
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">产地<span style="color:red">*</span></label>
                          <div class="col-sm-9">
                              <input type="text" class="form-control" id="locationUpd">
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">特性<span style="color:red">*</span></label>
                          <div class="col-sm-9">
                              <input type="text" class="form-control" id="characterUpd">
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">备注</label>
                          <div class="col-sm-9">
                              <input type="text" class="form-control" id="commentUpd">
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">照片</label>
                          <div class="col-sm-9">
                              <input type="file" class="form-control" id="pictureUpd" name="pictureUpd">
                          </div>
                          <div class="col-sm-9 help-block">
                              <input type="hidden" id="pictureUrlUpd" value="">
                          </div>
                      </div>
                  </form>
              </div>
              <div class="modal-footer">
                  <button type="button" class="btn btn-default" data-dismiss="modal" id="cancel">取消</button>
                  <button type="button" class="btn btn-primary" id="submitUpd">确定</button>
              </div>
          </div>
      </div>
  </div>

</body>
</html>