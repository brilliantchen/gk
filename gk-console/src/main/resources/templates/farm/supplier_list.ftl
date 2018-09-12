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

    var array =new Array();
    <#list typeMap as k,v>
        array[${k_index}] = {"code":'${k}',"desc":'${v}'};
    </#list>;

    $("#queryForm").resetForm();

    $("#queryBtn").on("click",function(){
        $("#dataTable").DataTable().ajax.reload();
    })

    $("#resetBtn").on("click",function(){
        $("#queryForm").resetForm();
        $("#typeQ").val("");
        $("#typeQ").trigger("change");
        $("#dataTable").DataTable().ajax.reload();
    })

    $(".typeSel").select2();

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
            var type = $("#typeQ option:selected").val();
            if (type){
                param.type = type;
            }
            var name = $("#nameQ").val();
            if(name){
                param.name = name;
            }
            var contract = $("#contractQ").val();
            if (contract){
                param.contract = contract;
            }
            var telephone = $("#telephoneQ").val();
            if (telephone){
                param.telephone = telephone;
            }

            $.ajax({
                type: "GET",
                url: "/supplier/list",
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
            {data: "name"},
            {data: "type",
                render: function (data, type, full, meta) {
                    for(var i=0;i<array.length;i++){
                        if (array[i].code == data){
                            return array[i].desc;
                        }
                    }
                    return null;
                }
            },
            {data: "contract"},
            {data: "telephone"},
            {data: null,
                render: function (data, type, full, meta) {
                    var el = data.province+","+data.city+","+data.area+","+data.address;
                    return el;
                }
            },
            {data: "licenseHash"},
            {data: "desc"},
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
        var name = $('#name').val();
        if (isNull(name)) {
            alert("请输入公司名称");
            return;
        }

        var type = $('#type').val()[0];
        if (isNull(type)) {
            alert("请选择类型");
            return;
        }

        var contract = $('#contract').val();
        if (isNull(contract)) {
            alert("请输入联系人");
            return;
        }

        var telephone = $('#telephone').val();
        if (isNull(telephone)){
            alert("请输入联系方式");
            return;
        }

        var province = $('#province').val();
        if (isNull(province)) {
            alert("请选择省份");
            return;
        }

        var city = $('#city').val();
        if (isNull(city)) {
            alert("请选择市");
            return;
        }

        var county = $('#county').val();
        if (isNull(county)) {
            alert("请选择区");
        }

        var address = $('#address').val();

        var comment = $('#comment').val();

        var pictureUrl = $("#pictureUrl").val();

        $.ajax({
            url: '/supplier/add',
            method: 'POST',
            dataType: 'json',
            data: {
                name: name,
                type: type,
                contract: contract,
                telephone: telephone,
                province: province,
                city: city,
                area: county,
                address: address,
                desc: comment,
                licenseHash: pictureUrl
            },
            success: function (rs) {
                if (rs.success) {
                    if (rs.value) {
                        window.location.href = "/supplier/page";
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
            url: '/supplier/query/' + id,
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
        $('#typeUpd').val(obj.type).trigger('change');
        modal.find('#nameUpd').val(obj.name);
        modal.find('#contractUpd').val(obj.contract);
        modal.find('#telephoneUpd').val(obj.telephone);
        modal.find('#provinceUpd').val(obj.province).trigger("change");
        modal.find('#cityUpd').val(obj.city).trigger("change");
        modal.find('#countyUpd').val(obj.area);
        modal.find('#addressUpd').val(obj.address);
        modal.find('#pictureUrlUpd').val(obj.licenseHash);
        modal.find('#commentUpd').val(obj.desc);
    });

    $('#edit').on('hidden.bs.modal', function (event) {
        var button = $(event.relatedTarget); // Button that triggered the modal
        var modal = $(this);
        modal.find('#id').val("");
        modal.find('#nameUpd').val("");
        modal.find('#contractUpd').val("");
        modal.find('#telephoneUpd').val("");
        modal.find('#provinceUpd').val("");
        modal.find('#cityUpd').val("");
        modal.find('#countyUpd').val("");
        modal.find('#addressUpd').val("");
        modal.find('#pictureUrlUpd').val("");
        modal.find('#commentUpd').val("");
    });

    $(document).on('click', '#submitUpd', function () {
        var id = $("#id").val();

        var name = $('#nameUpd').val();
        if (isNull(name)) {
            alert("请输入公司名称");
            return;
        }

        var type = $("#typeUpd").val();
        if (isNull(type)) {
            alert("请选择类型");
            return;
        }

        var contract = $('#contractUpd').val();
        if (isNull(contract)) {
            alert("请输入联系人");
            return;
        }

        var telephone = $('#telephoneUpd').val();
        if (isNull(telephone)){
            alert("请输入联系方式");
            return;
        }

        var province = $('#provinceUpd').val();
        if (isNull(province)) {
            alert("请选择省份");
            return;
        }

        var city = $('#cityUpd').val();
        if (isNull(city)) {
            alert("请选择市");
            return;
        }

        var county = $('#countyUpd').val();
        if (isNull(county)) {
            alert("请选择区");
        }

        var address = $('#addressUpd').val();

        var comment = $('#commentUpd').val();

        var pictureUrl = $("#pictureUrlUpd").val();

        $.ajax({
            url: '/supplier/update',
            method: 'POST',
            dataType: 'json',
            data: {
                id: id,
                name: name,
                type: type,
                contract: contract,
                telephone: telephone,
                province: province,
                city: city,
                area: county,
                address: address,
                desc: comment,
                licenseHash: pictureUrl
            },
            success: function (rs) {
                if (rs.success) {
                    if (rs.value) {
                        window.location.href = "/supplier/page";
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
                url: '/supplier/del/'+id,
                type: 'DELETE',
                dataType: 'json',
                success: function (rs) {
                    if (rs.success) {
                        alert("删除成功");
                        window.location.href = "/supplier/page";
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
                  <strong>供应商信息</strong>
                </h3>
                <button type="button" class="btn btn-primary pull-right" data-toggle="modal"
                        data-target="#create_modal">
                    新增供应商
                </button>
              </div>
              <div class="box-body">
                <form id="queryForm" class="form-horizontal">
                  <div class="form-group">
                    <label for="" class="control-label col-md-1">企业名称</label>
                    <div class="col-md-3">
                      <input type="text" id="nameQ" class="form-control col-md-2" />
                    </div>
                    <label for="" class="control-label col-md-1">类型</label>
                    <div class="col-md-3">
                        <select class="typeSel" id="typeQ" style="width: 100%">
                            <option></option>
                            <#list typeMap as k,v>
                                <option value="${k}">${v}</option>
                            </#list>
                        </select>
                    </div>
                    <label for="" class="control-label col-md-1">联系人</label>
                    <div class="col-md-3">
                      <input type="text" id="contractQ" class="form-control col-md-2" />
                    </div>
                  </div>
                  <div class="form-group">
                      <label for="" class="control-label col-md-1">联系方式</label>
                      <div class="col-md-3">
                          <input type="text" id="telephoneQ" class="form-control col-md-2" />
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
                      <th>企业名称</th>
                      <th>类型</th>
                      <th>联系人</th>
                      <th>联系方式</th>
                      <th>企业地址</th>
                      <th>营业执照</th>
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
                          <label class="col-sm-2 control-label">企业名称<span style="color:red">*</span></label>
                          <div class="col-sm-9">
                              <input type="text" class="form-control" id="name">
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">类型<span style="color:red">*</span></label>
                          <div class="col-sm-9">
                              <select class="typeSel" id="type" style="width: 100%">
                              <#list typeMap as k,v>
                                  <option value="${k}">${v}</option>
                              </#list>
                              </select>
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">联系人<span style="color:red">*</span></label>
                          <div class="col-sm-9">
                              <input type="text" class="form-control" id="contract">
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">联系方式<span style="color:red">*</span></label>
                          <div class="col-sm-9">
                              <input type="text" class="form-control" id="telephone">
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">区域<span style="color:red">*</span></label>
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
                          <label class="col-sm-2 control-label">备注</label>
                          <div class="col-sm-9">
                              <input type="text" class="form-control" id="comment">
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">营业执照</label>
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
                          <label class="col-sm-2 control-label">企业名称<span style="color:red">*</span></label>
                          <div class="col-sm-9">
                              <input type="text" class="form-control" id="nameUpd">
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">类型<span style="color:red">*</span></label>
                          <div class="col-sm-9">
                              <select class="typeSel" id="typeUpd" style="width: 100%">
                                  <#list typeMap as k,v>
                                      <option value="${k}">${v}</option>
                                  </#list>
                              </select>
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">联系人<span style="color:red">*</span></label>
                          <div class="col-sm-9">
                              <input type="text" class="form-control" id="contractUpd">
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">联系方式<span style="color:red">*</span></label>
                          <div class="col-sm-9">
                              <input type="text" class="form-control" id="telephoneUpd">
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">区域<span style="color:red">*</span></label>
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
                          <label class="col-sm-2 control-label">备注</label>
                          <div class="col-sm-9">
                              <input type="text" class="form-control" id="commentUpd">
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-sm-2 control-label">营业执照</label>

                          <div class="col-sm-9">
                              <input type="file" class="form-control" id="pictureUpd">
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