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
            param.id = $("#idQ").val();
            param.farmName = $("#nameQ").val(),
            param.phone = $("#phoneQ").val()

            $.ajax({
                type: "GET",
                url: "/farm/list",
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
            {data: "farmName"},
            {data: "farmTrueName"},
            {data: "corpration"},
            {data: "phone"},
            { "data": null,
                render: function (data, type, full, meta) {
                    var el = data.province+","+data.city+","+data.county+","+data.address;
                    return el;
                }
             },
            {data: "topic"},
            {data: "show"},
            {data: "sort"},
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
        var name = $('#name').val();
        if (isNull(name)) {
            alert("请输入养殖场显示名称");
            return;
        }

        var trueName = $('#trueName').val();
        if (isNull(trueName)) {
            alert("请输入养殖场真实名称");
            return;
        }

        var corpration = $('#farmer').val();
        if (isNull(corpration)) {
            alert("请输入农场主的姓名");
            return;
        }

        var phone = $('#phone').val();
        if (isNull(phone)) {
            alert("请输入养殖场联系方式");
            return;
        }

        var topic = $('#topic').val();
        if (isNull(topic)){
            alert("请输入topic");
            return;
        }

        var show = $("[name='show']").filter(":checked").val();

        var mapZoom = $('#mapZoom').val();

        var mapZoomPhone = $('#mapZoomPhone').val();

        var farmTrueLngLat = $('#farmTrueLngLat').val();
        if (isNull(farmTrueLngLat)){
            alert("请输入农场真实坐标");
            return;
        }

        var farmLngLat = $('#farmLngLat').val();

        var houseTrueLngLat = $('#houseTrueLngLat').val();
        if (isNull(houseTrueLngLat)){
            alert("请输入鸡舍的真实坐标");
            return;
        }

        var houseLngLat = $('#houtLngLat').val();

        var province = $('#province').val();

        var city = $('#city').val();

        var county = $('#county').val();

        var address = $('#address').val();

        var pictureUrl = $("#pictureUrl").val();

        var sort = $("#sort").val();

        $.ajax({
            url: '/farm/add',
            method: 'POST',
            dataType: 'json',
            data: {
                farmName: name,
                farmTrueName: trueName,
                corpration: corpration,
                phone: phone,
                topic: topic,
                show: show,
                trueLocation: farmTrueLngLat,
                location: farmLngLat,
                chickenHouseTrueLocation: houseTrueLngLat,
                chickenHouseLocation: houseLngLat,
                address: address,
                province: province,
                city: city,
                county: county,
                farmPictureUrl: pictureUrl,
                sort: sort,
                mapZoom: mapZoom,
                mapZoomPhone: mapZoomPhone
            },
            success: function (rs) {
                if (rs.success) {
                    if (rs.value) {
                        window.location.href = "/farm/page";
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
            url: '/farm/query/' + id,
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
        modal.find('#nameUpd').val(obj.farmName);
        modal.find('#trueNameUpd').val(obj.farmTrueName);
        modal.find('#farmerUpd').val(obj.corpration);
        modal.find('#phoneUpd').val(obj.phone);
        modal.find('#topicUpd').val(obj.topic);
        $("input[name='showUpd'][value="+obj.show+"]").attr("checked",true);
        modal.find('#farmTrueLngLatUpd').val(obj.trueLocation);
        modal.find('#farmLngLatUpd').val(obj.location);
        modal.find('#houseTrueLngLatUpd').val(obj.chickenHouseTrueLocation);
        modal.find('#houseLngLatUpd').val(obj.chickenHouseLocation);
        modal.find('#provinceUpd').val(obj.province);
        modal.find('#provinceUpd').trigger("change");
        modal.find('#cityUpd').val(obj.city);
        modal.find('#cityUpd').trigger("change");
        modal.find('#countyUpd').val(obj.county);
        modal.find('#addressUpd').val(obj.address);
        modal.find('#pictureUrlUpd').val(obj.farmPictureUrl);
        modal.find('#sortUpd').val(obj.sort);
        modal.find('#mapZoomUpd').val(obj.mapZoom);
        modal.find('#mapZoomPhoneUpd').val(obj.mapZoomPhone);
    });

    $('#edit').on('hidden.bs.modal', function (event) {
        var button = $(event.relatedTarget); // Button that triggered the modal
        var modal = $(this);
        modal.find('#id').val("");
        modal.find('#nameUpd').val("");
        modal.find('#trueNameUpd').val("")
        modal.find('#farmerUpd').val("");
        modal.find('#phoneUpd').val("");
        modal.find('#topicUpd').val("");
        modal.find('#farmTrueLngLatUpd').val("");
        modal.find('#farmLngLatUpd').val("");
        modal.find('#houseTrueLngLatUpd').val("");
        modal.find('#houseLngLatUpd').val("");
        modal.find('#provinceUpd').val("");
        modal.find('#cityUpd').val("");
        modal.find('#countyUpd').val("");
        modal.find('#addressUpd').val("");
        modal.find('#pictureUrlUpd').val("");
        modal.find('#sortUpd').val("");
        modal.find('#mapZoomUpd').val("");
        modal.find('#mapZoomPhoneUpd').val("");
    });

    $(document).on('click', '#submitUpd', function () {
        var id = $("#id").val();

        var name = $('#nameUpd').val();
        if (isNull(name)) {
            alert("请输入养殖场显示名称");
            return;
        }

        var trueName = $('#trueNameUpd').val();
        if (isNull(trueName)) {
            alert("请输入养殖场真实名称");
            return;
        }

        var corpration = $('#farmerUpd').val();
        if (isNull(corpration)) {
            alert("请输入农场主的姓名");
            return;
        }

        var phone = $('#phoneUpd').val();
        if (isNull(phone)) {
            alert("请输入养殖场联系方式");
            return;
        }

        var topic = $('#topicUpd').val();
        if (isNull(topic)){
            alert("请输入topic");
            return;
        }

        var show = $("[name='showUpd']").filter(":checked").val();

        var mapZoom = $('#mapZoomUpd').val();
        var mapZoomPhone = $('#mapZoomPhoneUpd').val();

        var farmTrueLngLat = $('#farmTrueLngLatUpd').val();
        if (isNull(farmTrueLngLat)){
            alert("请输入农场真实坐标");
            return;
        }

        var farmLngLat = $('#farmLngLatUpd').val();

        var houseTrueLngLat = $('#houseTrueLngLatUpd').val();
        if (isNull(houseTrueLngLat)){
            alert("请输入鸡舍的真实坐标");
            return;
        }

        var houseLngLat = $('#houseLngLatUpd').val();

        var province = $('#provinceUpd').val();

        var city = $('#cityUpd').val();

        var county = $('#countyUpd').val();

        var address = $('#addressUpd').val();

        var pictureUrl = $("#pictureUrlUpd").val();

        var sort = $("#sortUpd").val();

        $.ajax({
            url: '/farm/update',
            method: 'POST',
            dataType: 'json',
            data: {
                id: id,
                farmName: name,
                farmTrueName: trueName,
                corpration: corpration,
                phone: phone,
                topic: topic,
                show: show,
                trueLocation: farmTrueLngLat,
                location: farmLngLat,
                chickenHouseTrueLocation: houseTrueLngLat,
                chickenHouseLocation: houseLngLat,
                address: address,
                province: province,
                city: city,
                county: county,
                farmPictureUrl: pictureUrl,
                mapZoom: mapZoom,
                mapZoomPhone: mapZoomPhone,
                sort: sort
            },
            success: function (rs) {
                if (rs.success) {
                    if (rs.value) {
                        window.location.href = "/farm/page";
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
                url: '/farm/del/'+id,
                type: 'DELETE',
                dataType: 'json',
                success: function (rs) {
                    if (rs.success) {
                        alert("删除成功");
                        window.location.href = "/farm/page";
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
                  <strong>养殖场</strong>
                </h3>
                <button type="button" class="btn btn-primary pull-right" data-toggle="modal"
                        data-target="#create_farm_modal">
                    新增养殖场
                </button>
              </div>
              <div class="box-body">
                <form id="queryForm" class="form-horizontal">
                  <div class="form-group">
                    <label for="" class="control-label col-md-1">农场Id</label>
                    <div class="col-md-3">
                      <input type="text" id="idQ" class="form-control col-md-2" />
                    </div>
                    <label for="" class="control-label col-md-1">农场显示名</label>
                    <div class="col-md-3">
                      <input type="text" id="nameQ" class="form-control col-md-2" />
                    </div>
                    <label for="" class="control-label col-md-1">手机号</label>
                    <div class="col-md-3">
                      <input type="text" id="phoneQ" class="form-control col-md-2" />
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
                      <th>农场id</th>
                      <th>农场显示名称</th>
                      <th>农场真实名称</th>
                      <th>场主名</th>
                      <th>场主联系方式</th>
                      <th>农场地址</th>
                      <th>topic</th>
                      <th>对外展示</th>
                      <th>展示顺序(升序)</th>
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

  <div class="modal fade" id="create_farm_modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
      <div class="modal-dialog" role="document">
          <div class="modal-content">
              <div class="modal-body">
                  <form id="farm_form" class="form-horizontal">
                      <div class="form-group">
                          <label class="col-sm-2 control-label">显示名称<span style="color:red">*</span></label>
                          <div class="col-sm-9">
                              <input type="text" class="form-control" id="name" placeholder="养殖场名称">
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">真实名称<span style="color:red">*</span></label>
                          <div class="col-sm-9">
                              <input type="text" class="form-control" id="trueName" placeholder="养殖场名称">
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">场主<span style="color:red">*</span></label>
                          <div class="col-sm-9">
                              <input type="text" class="form-control" id="farmer" placeholder="养殖场拥有者">
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">联系方式<span style="color:red">*</span></label>
                          <div class="col-sm-9">
                              <input type="text" class="form-control" id="phone" placeholder="联系方式">
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">topic<span style="color:red">*</span></label>
                          <div class="col-sm-9">
                              <input type="text" class="form-control" id="topic">
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">展示排序(升序)<span style="color:red">*</span></label>
                          <div class="col-sm-9">
                              <input type="text" class="form-control" id="sort" placeholder="0,1,2.....">
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">对外展示<span style="color:red">*</span></label>
                          <div class="col-sm-9">
                              <input name="show" type="radio" value=true checked>是
                              <input name="show" type="radio" value=false >否
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">大屏地图缩放比</label>
                          <div class="col-sm-9">
                              <input type="text" class="form-control" id="mapZoom" placeholder="0,1,2.....">
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">手机地图缩放比</label>
                          <div class="col-sm-9">
                              <input type="text" class="form-control" id="mapZoomPhone" placeholder="0,1,2.....">
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">农场真实坐标<span style="color:red">*</span></label>
                          <div class="col-sm-9">
                              <textarea class="form-control" id="farmTrueLngLat"
                                        placeholder="经纬度,例如：x1,y1;x2,y2;"></textarea>
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">农场绘图坐标</label>
                          <div class="col-sm-9">
                              <textarea class="form-control" id="farmLngLat"
                                        placeholder="经纬度,例如：x1,y1;x2,y2;"></textarea>
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">鸡舍真实坐标<span style="color:red">*</span></label>
                          <div class="col-sm-9">
                              <textarea class="form-control" id="houseTrueLngLat"
                                        placeholder="经纬度,例如：x1,y1;x2,y2;"></textarea>
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">鸡舍绘图坐标</label>
                          <div class="col-sm-9">
                              <textarea class="form-control" id="houtLngLat"
                                        placeholder="经纬度,例如：x1,y1;x2,y2;"></textarea>
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">区域</label>
                          <div data-toggle="distpicker" id="distpicker">
                              <div class="col-sm-3">
                                  <select class="form-control" id="province" data-province="---- 选择省 ----">
                                  </select>
                              </div>
                              <div class="col-sm-3">
                                  <select class="form-control" id="city" data-city="---- 选择市 ----">
                                  </select>
                              </div>
                              <div class="col-sm-3">
                                  <select class="form-control" id="county" data-district="---- 选择区 ----">
                                  </select>
                              </div>
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">详细地址</label>
                          <div class="col-sm-9">
                              <input type="text" class="form-control" id="address" placeholder="详细地址">
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">农场图片</label>
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
                          <label class="col-sm-2 control-label">显示名称<span style="color:red">*</span></label>
                          <div class="col-sm-9">
                              <input type="text" class="form-control" id="nameUpd">
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">真实名称<span style="color:red">*</span></label>
                          <div class="col-sm-9">
                              <input type="text" class="form-control" id="trueNameUpd">
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">场主<span style="color:red">*</span></label>
                          <div class="col-sm-9">
                              <input type="text" class="form-control" id="farmerUpd">
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">联系方式<span style="color:red">*</span></label>
                          <div class="col-sm-9">
                              <input type="text" class="form-control" id="phoneUpd">
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">topic<span style="color:red">*</span></label>
                          <div class="col-sm-9">
                              <input type="text" class="form-control" id="topicUpd">
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">展示排序<span style="color:red">*</span></label>
                          <div class="col-sm-9">
                              <input type="text" class="form-control" id="sortUpd" placeholder="0,1,2.....">
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">对外展示<span style="color:red">*</span></label>
                          <div class="col-sm-9">
                              <input name="showUpd" type="radio" value=true >是
                              <input name="showUpd" type="radio" value=false >否
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">大屏地图缩放比</label>
                          <div class="col-sm-9">
                              <input type="text" class="form-control" id="mapZoomUpd" placeholder="0,1,2.....">
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">手机地图缩放比</label>
                          <div class="col-sm-9">
                              <input type="text" class="form-control" id="mapZoomPhoneUpd" placeholder="0,1,2.....">
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">农场真实坐标<span style="color:red">*</span></label>
                          <div class="col-sm-9">
                              <textarea class="form-control" id="farmTrueLngLatUpd"
                                     placeholder="经纬度,例如：x1,y1;x2,y2;"></textarea>
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">农场绘图坐标</label>
                          <div class="col-sm-9">
                              <textarea class="form-control" id="farmLngLatUpd"
                                     placeholder="经纬度,例如：x1,y1;x2,y2;"></textarea>
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">鸡舍真实坐标<span style="color:red">*</span></label>
                          <div class="col-sm-9">
                              <textarea class="form-control" id="houseTrueLngLatUpd"
                                        placeholder="经纬度,例如：x1,y1;x2,y2;"></textarea>
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">鸡舍绘图坐标</label>
                          <div class="col-sm-9">
                              <textarea class="form-control" id="houseLngLatUpd"
                                        placeholder="经纬度,例如：x1,y1;x2,y2;"></textarea>
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">区域</label>
                          <div data-toggle="distpicker" id="distpicker">
                              <div class="col-sm-3">
                                  <select class="form-control" id="provinceUpd" data-province="---- 选择省 ----">
                                  </select>
                              </div>
                              <div class="col-sm-3">
                                  <select class="form-control" id="cityUpd" data-city="---- 选择市 ----">
                                  </select>
                              </div>
                              <div class="col-sm-3">
                                  <select class="form-control" id="countyUpd" data-district="---- 选择区 ----">
                                  </select>
                              </div>
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">详细地址</label>
                          <div class="col-sm-9">
                              <input type="text" class="form-control" id="addressUpd" placeholder="详细地址">
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">农场图片</label>
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