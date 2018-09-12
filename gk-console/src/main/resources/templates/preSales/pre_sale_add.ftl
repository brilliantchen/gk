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
                            <h1 class="box-title"><strong>预售项目定制</strong></h1>
                            <div class="pull-right">
                            </div>
                        </div>

                        <div class="box-body">
                            <form id="addForm">
                                <div class="form-horizontal">
                                    <div class="form-group">
                                        <label for="" class="col-sm-3 control-label">预售项目名称：</label>
                                        <div class="col-sm-5">
                                            <input type="text" class="form-control" id="pre_projectName" name="name"
                                                   placeholder="请输入预售项目名称">
                                        </div>
                                    </div>
                                    <div class="form-group ">
                                      <label  class="col-sm-3 control-label">渠道：</label>
                                      <div class="col-sm-8">
                                        <label class="radio-inline"><input type="radio" name="channel" value="10" checked>连陌自营</label>
                                        <label class="radio-inline"><input type="radio" name="channel" value="20">提货券</label>
                                        <label class="radio-inline"><input type="radio" name="channel" value="21" >提货券-最福利专供</label>
                                        <label class="radio-inline"><input type="radio" name="channel" value="30" >活动-微信卡券</label>
                                      </div>
                                    </div>
                                    <input type="hidden" id="H_startTime" name="startTime">
                                    <div class="form-group">
                                        <label for="" class="col-sm-3 control-label">预售开始时间：</label>
                                        <div class="col-sm-5">
                                            <input type="text" class="form-control" id="pre_startTime"
                                                   placeholder="预售开始时间">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="" class="col-sm-3 control-label">预售产品名称：</label>
                                        <div class="col-sm-5">
                                            <input type="text" class="form-control" id="pre_productName" name="title"
                                                   placeholder="请输入预售产品名称">
                                        </div>
                                    </div>
                                    <input type="hidden" id="H_tags" name="labels">
                                    <div class="form-group">
                                        <label for="" class="col-sm-3 control-label">预售标签：</label>
                                        <div class="col-sm-3">
                                            <input type="text" class="form-control" id="label" name=""
                                                   placeholder="请输入预售标签">
                                        </div>
                                        <div class="col-sm-3">
                                            <a class="btn btn-info" id="add_label">添加标签</a>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="" class="col-sm-3 control-label"></label>
                                        <div class="col-sm-5" id="pre_labels">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="" class="col-sm-3 control-label">现价：</label>
                                        <div class="col-sm-3">
                                            <input type="text" class="form-control" id="pre_sellPrice" name="sellPrice"
                                                   placeholder="请输入现价（元）">
                                        </div>
                                        <label for="" class="col-sm-2 control-label">原价：</label>
                                        <div class="col-sm-3">
                                            <input type="text" class="form-control" id="pre_originalPrice" name="originalPrice"
                                                   placeholder="请输入原价（元）">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="" class="col-sm-3 control-label">预售产品说明：</label>
                                        <div class="col-sm-5">
                                            <textarea name="desc" id="pre_desc" cols="" rows="3"
                                                      style="width:100%"></textarea>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="" class="col-sm-3 control-label">预售产品总量：</label>
                                        <div class="col-sm-3">
                                            <input type="text" class="form-control" id="pre_stock" name="totalNum"
                                                   placeholder="请输入预售产品总量">
                                        </div>
                                        <label for="" class="col-sm-2 control-label">预售警告总量：</label>
                                        <div class="col-sm-3">
                                            <input type="text" class="form-control" id="pre_alertStock" name="alertStock"
                                                   placeholder="请输入预售警告总量">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                      <label for="" class="col-sm-3 control-label">分享URL：</label>
                                      <div class="col-sm-5">
                                        <input type="text" class="form-control" id="pre_shareUrl" name="shareUrl" value="http://m.opentrust.io/#/presale/"
                                               placeholder="请输入分享URL">
                                      </div>
                                    </div>
                                    <!-- 点击 弹框添加 -->
                                    <input type="hidden" id="H_skus" name="skusStrs">
                                    <div class="form-group">
                                        <label for="" class="col-sm-3 control-label">预售产品规格：</label>
                                        <div class="col-sm-3">
                                            <a class="btn btn-info" id="add_sku">添加规格</a>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="" class="col-sm-3 control-label"></label>
                                          <div class="col-sm-4">
                                            <input type="hidden" id="sku_coverImg" >
                                            <input type="file" id="file1"/>
                                          </div>
                                        <div class="col-sm-5" id="tb_sku">
                                            <table>
                                                <tr><td>规格名称：</td><td><input type="text" id="sku_name" class="form-control"></td></tr>
                                                <tr><td>售价：</td><td><input type="text" id="sku_amount" class="form-control" ></td></tr>
                                                <tr><td>库存：</td><td><input type="text" id="sku_num" class="form-control" ></td></tr>
                                                <tr><td>详情：</td><td><input type="text" id="sku_desc" class="form-control" ></td></tr>
                                            </table>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="" class="col-sm-3 control-label"></label>
                                        <div class="col-sm-5">
                                            <table class="table with-border" id="pre_skus">
                                                <thead>
                                                <tr><th style="width: 200px;">图片</th><th>规格名称</th><th>售价</th><th>库存</th><th>详情</th><th>操作</th></tr>
                                                </thead>
                                            </table>
                                        </div>
                                    </div>
                                    <input type="hidden" id="H_proms" name="promsStrs">
                                    <div class="form-group">
                                        <label for="" class="col-sm-3 control-label">预售促销活动：</label>
                                        <div class="col-sm-3">
                                            <a class="btn btn-info" id="add_prom">添加活动</a>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="" class="col-sm-3 control-label"></label>
                                        <div class="col-sm-5" id="tb_prom">
                                            <table>
                                                <tr><td>活动标签：</td><td><input type="text" id="prom_tag" class="form-control"></td></tr>
                                                <tr><td>活动说明：</td><td><input type="text" id="prom_desc" class="form-control" ></td></tr>
                                            </table>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="" class="col-sm-3 control-label"></label>
                                        <div class="col-sm-5">
                                            <table class="table with-border" id="pre_proms">
                                                <thead>
                                                <tr><th>活动标签</th><th>活动说明</th><th>操作</th></tr>
                                                </thead>
                                            </table>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                      <label for="" class="col-sm-3 control-label">封面图片上传：</label>
                                        <div class="col-sm-5">
                                          <input id="fileCoverImg" name="" type="file" >
                                        </div>
                                        <input type="hidden" name="coverImg" id="pre_coverImg" >
                                    </div>

                                    <input type="hidden" id="H_bannerImgs" name="bannerImgs">
                                    <div class="form-group">
                                        <label for="" class="col-sm-3 control-label">Banner轮播图片上传：</label>
                                        <div class="col-sm-5">
                                          <input id="file2" name="file2[]" type="file"  multiple >
                                        </div>
                                        <div id="H_div_banner" >
                                      </div>
                                    </div>
                                    <input type="hidden" id="H_imgs" name="imgs" >
                                    <div class="form-group">
                                        <label for="" class="col-sm-3 control-label">商品详情页上传：</label>
                                        <div class="col-sm-5">
                                            <input id="file3" name="file3[]" type="file"  multiple >
                                          </div>
                                          <div id="H_div_img" ></div>
                                    </div>
                                    <div class="modal-footer">
                                        <div class="col-sm-offset-2 col-sm-10">
                                            <a type="button" class="btn btn-default" data-dismiss="modal" id="cancel"
                                               href="/pre/list/page">
                                              返回
                                            </a>
                                            <a type="button" class="btn btn-primary" id="saveBtn" onclick="savePreSaleProject()">保存
                                            </a>
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
        initpage();
        initFileUpload();
        initBannerFileUpload();
        initImgsFileUpload();
        //添加标签
        $(document).on('click','#add_label',function () {
            if($("#label").val() == '') {
                alert("请输入标签!");
                return;
            }
            if($('.pre_tag').length>=3){
                alert("标签数达到上限!");
                return;
            }
            $("#pre_labels").append('<label>'+$("#label").val()+'&nbsp;<a id="#" class="pre_tag">X</a> </label>&nbsp;&nbsp;&nbsp;');
            $("#label").val("");
        });
        //删除标签
        $(document).on("click", ".pre_tag", function () {
            $(this).parent().remove();
        });
        // 添加规格
        $(document).on('click','#add_sku',function () {
            if($("#sku_coverImg").val() == ''){
              alertify.error("上传规格图片!");
              return;
            }
            if($("#sku_name").val() == '' || $("#sku_amount").val() == '' || $("#sku_num").val() == '') {
                alertify.error("请输入完整规格内容!");
                return;
            }
            $("#pre_skus").append('<tr><td><img style="width: 180px;" src='+$("#sku_coverImg").val()+'></td><td>'+$("#sku_name").val()+'</td><td>'+$("#sku_amount").val()+'</td><td>'+$("#sku_num").val()+'</td><td>'+$("#sku_desc").val()+'</td><td style="display: none">'+$("#sku_coverImg").val()+'</td><td><button class="btn btn-default btn-xs del_sku" type="button">删除</button></td></tr>');
            $("#sku_name").val("");
            $("#sku_amount").val("");
            $("#sku_num").val("");
            $("#sku_desc").val("");
            $("#sku_coverImg").val("");
            $('#file1').fileinput('clear');
        });
        //删除规格 del_sku
        $(document).on("click", ".del_sku", function () {
          var ele = $(this);
          alertify.confirm("确认删除？", function () {
            ele.parent().parent().remove();
          });
        });

        // 添加活动
        $(document).on('click','#add_prom',function () {
            if($("#prom_tag").val() == '' || $("#prom_desc").val() == '') {
                alertify.error("请输入完整标签内容!");
                return;
            }
            $("#pre_proms").append('<tr><td>'+$("#prom_tag").val()+'</td><td>'+$("#prom_desc").val()+'</td><td><button class="btn btn-default btn-xs del_prom" >删除</button></td></tr>');
            $("#prom_tag").val("");
            $("#prom_desc").val("");
        });
        //删除规格 del_tag
        $(document).on("click", ".del_prom", function () {
            $(this).parent().parent().remove();
        });
    });
    var initpage = function() {
        $("#pre_startTime").datetimepicker({
            minView: "hour",
            format: 'yyyy-mm-dd hh:ii:00',
            autoclose: true,
            todayBtn: true
        });
    }

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
          key = "pre/product/sku/" +  filename.substring(0,pos)+"_"+Date.parse(new Date())+filename.substring(pos)
          form.append("key", key);
          form.append("policy", signature.policy);
          form.append("OSSAccessKeyId", signature.accessid);
          form.append("signature", signature.signature);
          form.append("file", file);
        }).on('fileuploaded', function () {
          var url = signature.host + key;
          $("#sku_coverImg").val(url);
        }).on('fileuploaderror', function () {
          console.log('File upload error');
          alert("文件上传异常！");
          inp.fileinput("clear");
        }).on('fileclear', function(event) {
          $("#sku_coverImg").val("");
        });

        var inp2 = $('#fileCoverImg');
        inp2.fileinput({
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
          key = "pre/product/coverImg/" +  filename.substring(0,pos)+"_"+Date.parse(new Date())+filename.substring(pos)
          form.append("key", key);
          form.append("policy", signature.policy);
          form.append("OSSAccessKeyId", signature.accessid);
          form.append("signature", signature.signature);
          form.append("file", file);
        }).on('fileuploaded', function () {
          var url = signature.host + key;
          $("#pre_coverImg").val(url);
        }).on('fileuploaderror', function () {
          console.log('File upload error');
          alert("文件上传异常！");
          inp.fileinput("clear");
        }).on('fileclear', function(event) {
          $("#pre_coverImg").val("");
        });;

      })
    }
    
    var initBannerFileUpload = function () {
      $("#file2").fileinput({
        language: 'zh',
        maxFileCount: 6,
        allowedFileExtensions: ['jpg', 'png', 'JPG', 'PNG'],
        uploadUrl: "/pre/product/banner/upload",
        maxFileSize:2000,
      }).on('fileuploaded', function(e, params) {
        if(params.response.success){
            $("#H_div_banner").append("<input type=\"hidden\" value=\""+params.response.value+"\">");
        }
      }).on('fileclear', function(event) {
        $("#H_div_banner").html("");
      });
    }

    var initImgsFileUpload = function () {
      $("#file3").fileinput({
        language: 'zh',
        maxFileCount: 6,
        allowedFileExtensions: ['jpg', 'png', 'JPG', 'PNG'],
        uploadUrl: "/pre/product/img/upload",
        maxFileSize:2000,
      }).on('fileuploaded', function(e, params) {
        if(params.response.success){
          $("#H_div_img").append("<input type=\"hidden\" value=\""+params.response.value+"\">");
        }else{
          alert("error:"+params.response.errorMessage);
        }
      }).on('fileclear', function(event) {
        $("#H_div_img").html("");
      });
    }

    var savePreSaleProject = function () {
        if (!validate()) {
          return;
        }
        $("#H_startTime").val(new Date($("#pre_startTime").val().replace(/-/ig, "/")));
        //tag
        var tagArr = [];
        $(".pre_tag").each(function () {
            tagArr.push($.trim($(this).parent().text().replace("X", "")));
        });
        $("#H_tags").val(tagArr);
        //banner img
          var bannerImgs = [];
          $("#H_div_banner > input").each(function () {
            var banner = $(this).val();
            bannerImgs.push(banner)
          });
          $("#H_bannerImgs").val(bannerImgs);
        //detail img
          var imgs = [];
          $("#H_div_img > input").each(function () {
            var banner = $(this).val();
            imgs.push(banner)
          });
          $("#H_imgs").val(imgs);
        //sku
        var skuArr = [];
        $("#pre_skus > tbody > tr").each(function () {
            var arr = $(this).find("td");
            var record = arr[1].innerText+'|'+arr[2].innerText+'|'+arr[3].innerText+'|'+arr[4].innerText+'|'+arr[5].innerText+'|'+arr[6].innerText;

            skuArr.push(record)
        });
        $("#H_skus").val(skuArr);
        //活动
        var promArr = [];
        $("#pre_proms > tbody > tr").each(function () {
            var arr = $(this).find("td");
            var record = arr[0].innerText+'|'+arr[1].innerText;

            promArr.push(record)
        });
        $("#H_proms").val(promArr);

        $.ajax({
            url: '/pre/project/add',
            method: 'POST',
            dataType: 'json',
            data: $("#addForm").serialize(),
            success: function (rs) {
                if (rs.success) {
                    alertify.success("操作成功！");
                    window.location.href = "/pre/list/page";
                } else {
                    alertify.error(rs.msg);
                }
            }
        });
    };

    var validate = function () {
        //预售项目名称 pre_projectName
        if ($("#pre_projectName").val() == "") {
            alertify.error("请输入预售项目名称！");
            return false;
        }
        //预售开始时间 pre_startTime
        if ($("#pre_startTime").val() == "") {
            alertify.error("请选择开始日期！");
            return false;
        }
        //预售产品名称 pre_productName
        if ($("#pre_productName").val() == "") {
            alertify.error("请输入预售产品名称！");
            return false;
        }
        //现价 pre_sellPrice
        if ($("#pre_sellPrice").val() == "" || isNaN($("#pre_sellPrice").val())) {
            alertify.error("现价不合法！");
            return false;
        }
        //原价 pre_originalPrice
        if ($("#pre_originalPrice").val() == "" || isNaN($("#pre_originalPrice").val())) {
            alertify.error("原价不合法！");
            return false;
        }
        //预售产品说明 pre_desc
        if ($("#pre_desc").val() == "") {
            alertify.error("请输入预售产品说明！");
            return false;
        }
        //分享URL
        if ($("#pre_shareUrl").val() == "") {
          alertify.error("请输入分享URL！");
          return false;
        }
        //封面图
        if ($("#pre_coverImg").val() == "") {
          alertify.error("请上传封面图！");
          return false;
        }
        //Banner img
        if ($("#H_div_banner").html().trim() == "") {
          alertify.error("请上传Banner轮播图！");
            return false;
        }
        //desc img
        if ($("#H_div_img").html().trim() == "") {
          alertify.error("请上传商品详情图！");
          return false;
        }
        //预售产品总量 pre_stock
        if ($("#pre_stock").val() == "" || isNaN($("#pre_stock").val())) {
            alertify.error("预售产品总量不合法！");
            return false;
        }
        //预售警告总量 pre_alertStock
        if ($("#pre_alertStock").val() == "" || isNaN($("#pre_alertStock").val())) {
            alertify.error("预售警告总量不合法！");
            return false;
        }
        // 预售产品规格

        if($("#pre_skus > tbody > tr").length<1){
            alertify.error("至少添加一种产品规格！");
            return false;
        }
        var error = true;
        $("#pre_skus > tbody > tr").each(function () {
            var arr = $(this).find("td");
//            if(arr[0].innerText.indexOf('\\|')){
//                alertify.error("产品规格名称不能包含特殊字符！");
//                error = false;
//            } else
            if(isNaN(arr[2].innerText)) {
                alertify.error("产品规格售价不合法！");
                error = false;
            } else if(isNaN(arr[3].innerText)) {
                alertify.error("产品规格库存不合法！");
                error = false;
            }
        });
        return true && error;
    }
</script>
</body>
</html>