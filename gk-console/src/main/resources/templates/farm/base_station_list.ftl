<!DOCTYPE html>
<html>
<head>
<#include "/layout/header.ftl">

<script>
$(function() {

    var farmArray =new Array();
    <#list farmMap as k>
        farmArray[${k_index}] = {"id":'${k.id}',"name":'${k.farmName}'};
    </#list>;

    var stationStatusArray =new Array();
    <#list stationStatusMap as k,v>
        stationStatusArray[${k_index}] = {"code":'${k}',"desc":'${v}'};
    </#list>;

    $("#queryForm").resetForm();

    $("#queryBtn").on("click",function(){
        $("#dataTable").DataTable().ajax.reload();
    })

    $("#resetBtn").on("click",function(){
        $("#queryForm").resetForm();
        $("#farmQ").val("");
        $("#farmQ").trigger("change");
        $("#dataTable").DataTable().ajax.reload();
    })

    $(".farmSel").select2();
    $(".stationStatusSel").select2();

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
            var farmId = $("#farmQ option:selected").val();
            if (farmId){
                param.farmId = farmId;
            }

            $.ajax({
                type: "GET",
                url: "/baseStation/list",
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
            {data: "farmId",
                render: function (data, type, full, meta) {
                    for(var i=0;i<farmArray.length;i++){
                        if (farmArray[i].id == data){
                            return farmArray[i].name;
                        }
                    }
                    return null;
                }
            },
            {data: "longitude"},
            {data: "latitude"},
            {data: "stationStatus",
                render: function (data, type, full, meta) {
                    for(var i=0;i<stationStatusArray.length;i++){
                        if (stationStatusArray[i].code == data){
                            return stationStatusArray[i].desc;
                        }
                    }
                    return null;
                }
            },
            {data: "id",
                render: function (data, type, full) {
                    return '<button type="button" class="btn btn-default" data-toggle="modal" data-target="#edit" data-id="'+data+'">编辑</button>' +
                            "&nbsp;"+'<button type="button" class="btn btn-danger delete" value="' + data + '">删除</button>';
                }
            }
        ]
    });

    //新增
    $('#submitBtn').on('click', function () {
        var farmId = $('#farm').val();
        if (isNull(farmId)) {
            alert("请选择农场");
            return;
        }

        var longitude = $('#longitude').val();
        if (isNaN(longitude)){
            alert("请输入经度");
            return;
        }

        var latitude = $('#latitude').val();
        if (isNull(latitude)) {
            alert("请输入维度");
            return;
        }

        $.ajax({
            url: '/baseStation/add',
            method: 'POST',
            dataType: 'json',
            data: {
                farmId: farmId,
                latitude: latitude,
                longitude: longitude,
            },
            success: function (rs) {
                if (rs.success) {
                    if (rs.value) {
                        window.location.href = "/baseStation/page";
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
            url: '/baseStation/query/' + id,
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
        $('#stationStatusUpd').val(obj.stationStatus).trigger('change');
        $('#farmUpd').val(obj.farmId).trigger('change');
        modal.find('#latitudeUpd').val(obj.latitude);
        modal.find('#longitudeUpd').val(obj.longitude);
    });

    $('#edit').on('hidden.bs.modal', function (event) {
        var button = $(event.relatedTarget); // Button that triggered the modal
        var modal = $(this);
        modal.find('#id').val("");
        modal.find('#latitudeUpd').val("");
        modal.find('#longitudeUpd').val("");
    });

    $(document).on('click', '#submitUpd', function () {
        var id = $("#id").val();

        var farmId = $('#farmUpd').val();
        if (isNull(farmId)) {
            alert("请选择农场");
            return;
        }

        var stationStatus = $('#stationStatusUpd').val();
        if (isNull(stationStatus)) {
            alert("请选择运行状态");
            return;
        }

        var latitude = $('#latitudeUpd').val();
        if (isNaN(latitude)){
            alert("请输入纬度");
            return;
        }

        var longitude = $('#longitudeUpd').val();
        if (isNull(longitude)) {
            alert("请输入经度");
            return;
        }

        $.ajax({
            url: '/baseStation/update',
            method: 'POST',
            dataType: 'json',
            data: {
                id: id,
                farmId: farmId,
                stationStatus: stationStatus,
                longitude: longitude,
                latitude: latitude,
            },
            success: function (rs) {
                if (rs.success) {
                    if (rs.value) {
                        window.location.href = "/baseStation/page";
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
                url: '/baseStation/del/'+id,
                type: 'DELETE',
                dataType: 'json',
                success: function (rs) {
                    if (rs.success) {
                        alert("删除成功");
                        window.location.href = "/baseStation/page";
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
                  <strong>基站设备管理</strong>
                </h3>
                <button type="button" class="btn btn-primary pull-right" data-toggle="modal"
                        data-target="#create_modal">
                    新增基站
                </button>
              </div>
              <div class="box-body">
                <form id="queryForm" class="form-horizontal">
                  <div class="form-group">
                      <label for="" class="control-label col-md-1">农场名</label>
                      <div class="col-md-3">
                          <select class="farmSel" id="farmQ" style="width: 100%">
                              <option></option>
                              <#list farmMap as k>
                                  <option value="${k.id}">${k.farmName}</option>
                              </#list>
                          </select>
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
                      <th>农场名</th>
                      <th>经度</th>
                      <th>纬度</th>
                      <th>运行状态</th>
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
                          <label class="col-sm-2 control-label">农场名<span style="color:red">*</span></label>
                          <div class="col-sm-9">
                              <select class="farmSel" id="farm" style="width: 100%">
                              <#list farmMap as k>
                                  <option value="${k.id}">${k.farmName}</option>
                              </#list>
                              </select>
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">经度<span style="color:red">*</span></label>
                          <div class="col-sm-9">
                              <input type="text" class="form-control" id="longitude">
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">纬度<span style="color:red">*</span></label>
                          <div class="col-sm-9">
                              <input type="text" class="form-control date" id="latitude" >
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
                          <label class="col-sm-2 control-label">农场名<span style="color:red">*</span></label>
                          <div class="col-sm-9">
                              <select class="farmSel" id="farmUpd" style="width: 100%">
                              <#list farmMap as k>
                                  <option value="${k.id}">${k.farmName}</option>
                              </#list>
                              </select>
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">经度<span style="color:red">*</span></label>
                          <div class="col-sm-9">
                              <input type="text" class="form-control" id="longitudeUpd">
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">纬度<span style="color:red">*</span></label>
                          <div class="col-sm-9">
                              <input type="text" class="form-control date" id="latitudeUpd" >
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">运行状态<span style="color:red">*</span></label>
                          <div class="col-sm-9">
                              <select class="stationStatusSel" id="stationStatusUpd" style="width: 100%">
                              <#list stationStatusMap as k,v>
                                  <option value="${k}">${v}</option>
                              </#list>
                              </select>
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