<!DOCTYPE html>
<!--suppress ALL -->
<html>
<head>
<#include "/layout/header.ftl">
  <link rel="stylesheet" href="/bootstrap-fileinput/css/fileinput.css">
  <script src="/bootstrap-fileinput/js/fileinput.js"></script>
  <script src="/bootstrap-fileinput/js/locales/LANG.js"></script>
  <script src="/bootstrap-fileinput/js/locales/zh.js"></script>
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
            <h1 class="box-title"><strong>发起众筹</strong></h1>
            <div class="pull-right">
            <#-- <button type="button" class="btn btn-primary " data-toggle="modal"
                      data-target="#VMRegisterModal" href="/crowd/add">
                +新增
              </button>-->
            </div>
          </div>


          <div class="box-body">
            <form id="addForm">
              <input type="hidden" name="projectStatus" value="1">
              <input type="hidden" name="userId" value="super">
              <input type="hidden" name="fundraisingAmount" value="0">
              <input type="hidden" name="fundraisingUserNum" value="0">
              <input type="hidden" id="h_projectCreatedTime" name="projectCreatedTime">
              <input type="hidden" id="h_projectFundraisingEndTime"
                     name="projectFundraisingEndTime">
              <div class="form-horizontal">

                <div class="form-group">
                  <label for="" class="col-sm-3 control-label">项目名称：</label>
                  <div class="col-sm-5">
                    <input type="text" class="form-control" id="crd_projectName" name="projectName"
                           placeholder="请输入项目名称">
                  </div>
                </div>
                <div class="form-group">
                  <label for="" class="col-sm-3 control-label">封面图片：</label>
                  <div class="col-sm-5">
                    <input type="hidden" id="crd_coverImg" name="coverImg">
                    <input type="file" class="" id="file1"/>
                  </div>
                </div>

                <div class="form-group">
                  <label for="" class="col-sm-3 control-label">项目图片：</label>
                  <div class="col-sm-5">
                    <input type="text" class="form-control" id="crd_projectImgs" name="projectImgs"
                           placeholder="">
                  </div>
                </div>

                <div class="form-group">
                  <label for="i_influent_name" class="col-sm-3 control-label">金额/份：</label>
                  <div class="col-sm-3">
                    <input type="text" class="form-control" id="crd_minFundraising"
                           name="minFundraising"
                           placeholder="请输入金额/份">
                  </div>
                  <label for="i_influent_name" class="col-sm-2 control-label">限购份数：</label>
                  <div class="col-sm-3">
                    <input type="text" class="form-control" id="crd_maxBuyNumber"
                           name="maxBuyNumber" value="5"
                           placeholder="请输入限购份数">
                  </div>
                </div>

                <div class="form-group">
                  <label for="" class="col-sm-3 control-label">目标金额：</label>
                  <div class="col-sm-3">
                    <input type="text" class="form-control" id="crd_fundraisingGoal"
                           name="fundraisingGoal" placeholder="请输入目标金额">
                  </div>
                  <label for="" class="col-sm-2 control-label">允许超卖：</label>
                  <div class="col-sm-3">
                    <label class="radio-inline"><input type="radio" name="stockLimit" checked
                                                       value="N">是</label>
                    <label class="radio-inline"><input type="radio" name="stockLimit"
                                                       value="Y">否</label>
                  </div>
                </div>

                <div class="form-group">
                  <label for="" class="col-sm-3 control-label">开始~结束：</label>
                  <div class="col-sm-4">
                    <input type="text" class="form-control" id="crd_projectCreatedTime"
                           placeholder="开始日期">
                  </div>
                  <div class="col-sm-4">
                    <input type="text" class="form-control" id="crd_projectFundraisingEndTime"
                           placeholder="结束日期">
                  </div>
                </div>
                <div class="form-group">
                  <label for="" class="col-sm-3 control-label">资金用途：</label>
                  <div class="col-sm-9">
                    <textarea name="fundUse" id="crd_fundUse" cols="" rows="3"
                              style="width:100%"></textarea>
                  </div>
                </div>
                <div class="form-group">
                  <label for="" class="col-sm-3 control-label">购买流程：</label>
                  <div class="col-sm-9">
                    <textarea name="purchaseProcess" id="crd_purchaseProcess" cols="" rows="3"
                              style="width:100%"></textarea>
                  </div>
                </div>
                <div class="form-group">
                  <label for="" class="col-sm-3 control-label">回报方式：</label>
                  <div class="col-sm-9">
                    <textarea name="projectReturnMode" id="crd_projectReturnMode" cols="" rows="3"
                              style="width:100%"></textarea>
                  </div>
                </div>
                <div class="form-group">
                  <label for="" class="col-sm-3 control-label">项目详情：</label>
                  <div class="col-sm-9">
                    <textarea name="projectProfile" id="crd_projectProfile" cols="" rows="5"
                              style="width:100%"></textarea>
                  </div>
                </div>

                <div class="modal-footer">
                  <div class="col-sm-offset-2 col-sm-10">
                    <a type="button" class="btn btn-default" data-dismiss="modal" id="cancel"
                       href="/crowd/list/page">
                      取消
                    </a>
                    <button type="button" class="btn btn-primary" id="saveBtn"
                            onclick="saveCrowd()">确定
                    </button>
                  </div>
                </div>
              </div>
            </form>


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
    //alert(new Date('2011-06-07'.replace(/-/ig,'/')));
    initFileUpload();
  });

  var initPage = function () {
    $("#crd_projectCreatedTime").val(timeConvert(new Date()));
    $("#crd_projectCreatedTime").datetimepicker({
      minView: "month",
      format: 'yyyy-mm-dd',
      autoclose: true,
      todayBtn: true
    });
    //$("#crd_endDate").val(currentDate());
    $("#crd_projectFundraisingEndTime").datetimepicker({
      minView: "month",
      format: 'yyyy-mm-dd',
      autoclose: true,
      todayBtn: true
    });

  };

  var initFileUpload = function () {
    $.ajax("/get_signature", {
      dataType: "json",
      cache: false,
      method: "post"
    }).done(function (signature) {
      var inp = $('#file1');
      inp.fileinput({
        language: 'zh',
        allowedFileTypes: ['jpg', 'png', 'JPG', 'PNG'],
        uploadUrl: signature.host,
      }).on('change', function () {
        //inp.fileinput('upload');
      }).on('filepreupload', function (event, data) {
        var form = data.form, files = data.files;
        form.delete("file_id");
        var fileInputName = this.name || "file_data";
        var file = form.get(fileInputName);
        form.delete(fileInputName)
        var filename = files[0].name;
        var pos = filename.lastIndexOf('.');
        //key = key || filename.substring(0,pos)+"_"+Date.parse(new Date())/1000+filename.substring(pos)
        key = "crowdfunding/product/coverImg/" + filename;
        form.append("key", key);
        form.append("policy", signature.policy);
        form.append("OSSAccessKeyId", signature.accessid);
        form.append("signature", signature.signature);
        form.append("file", file);
      }).on('fileuploaded', function () {
        var url = signature.host + key;
        $("#crd_coverImg").val(url);
      }).on('fileuploaderror', function () {
        console.log('File upload error');
        alert("文件上传异常！");
        inp.fileinput("clear");
      });

    })
  }

  var saveCrowd = function () {

    if (!mandatoryValidate()) {
      return;
    }
    $("#h_projectCreatedTime").val(
        new Date($("#crd_projectCreatedTime").val().replace(/-/ig, "/")));
    $("#h_projectFundraisingEndTime").val(
        new Date($("#crd_projectFundraisingEndTime").val().replace(/-/ig, "/")));

    $.ajax({
      url: '/crowd/product/add',
      method: 'POST',
      dataType: 'json',
      data: $("#addForm").serialize(),
      success: function (rs) {
        if (rs.success) {
          alert("操作成功！");
          window.location.href = "/crowd/list/page";
        } else {
          alertify.error(rs.msg);
        }
      }
    });
  };

  var mandatoryValidate = function () {
    if ($("#crd_projectName").val() == "") {
      alertify.error("请输入项目名称！");
      return false;
    }
    if ($("#crd_coverImg").val() == "") {
      alertify.error("请上传封面图片！");
      return false;
    }
    if ($("#crd_fundraisingGoal").val() == "") {
      alertify.error("请输入目标金额！");
      return false;
    }
    if ($("#crd_minFundraising").val() == "") {
      alertify.error("请输入金额/份！");
      return false;
    }
    if ($("#crd_maxBuyNumber").val() == "") {
      alertify.error("请输入限购份数！");
      return false;
    }
    if ($("#crd_projectCreatedTime").val() == "") {
      alertify.error("请选择开始日期！");
      return false;
    }
    if ($("#crd_projectFundraisingEndTime").val() == "") {
      alertify.error("请选择结束日期！");
      return false;
    }
    if ($("#crd_fundUse").val() == "") {
      alertify.error("请输入资金用途！");
      return false;
    }
    if ($("#crd_purchaseProcess").val() == "") {
      alertify.error("请输入购买流程！");
      return false;
    }
    if ($("#crd_projectReturnMode").val() == "") {
      alertify.error("请输入回报方式！");
      return false;
    }
    if ($("#crd_projectProfile").val() == "") {
      alertify.error("请输入 项目详情！");
      return false;
    }
    if (isNaN($("#crd_fundraisingGoal").val())) {
      alertify.error("目标金额不合法！");
      return false;
    }
    if (isNaN($("#crd_minFundraising").val())) {
      alertify.error("金额/份不合法！");
      return false;
    }
    if (isNaN($("#crd_maxBuyNumber").val())) {
      alertify.error("金额/份不合法！");
      return false;
    }

    return true;

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