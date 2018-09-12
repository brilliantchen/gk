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
<!--   <form class="form-horizontal">
    <div class="form-group">
      <label for="" class="col-sm-1">文件名：</label>
      <div class="col-sm-2">
        <input type="radio" name="aa" id="op1" /><label for="op1">默认</label>
      </div>
      <div class="col-sm-4">
        <input type="radio" name="aa" id="op2" class=""/><label for="op2">自定义</label>
      </div>
        <input type="text" name="" id="" class="form-control" style=""/>
    </div>
  </form> -->
  <div class="row"><div class="col-sm-12">
    <label for="" class="">OSS key：</label>
    <input type="radio" name="aa" id="op1" checked/><label for="op1">默认(/file/文件名_毫秒值.后缀)</label>&emsp;
    <input type="radio" name="aa" id="op2" class=""/><label for="op2">自定义(全路径,含文件名)</label>
    <input type="text" name="" id="key-inp" class="" disabled style="width: 400px"/>
  </div></div>
  <input type="file" name="file" class="" id="f" />
  <div id="f2" class="help-block"></div>
  
<!--   <form action="http://zy46.oss-cn-shanghai.aliyuncs.com/" method="post" enctype="multipart/form-data">
    <input type="text" name="key" id="" value=""/>
    <input type="text" name="policy" id="" value=""/>
    <input type="text" name="OSSAccessKeyId" id="" value=""/>
    <input type="text" name="success_action_status" id="" value="200"/>
    <input type="text" name="signature" id="" value=""/>
    <input type="file" name="file" id="" />
    <input type="submit" name="" id="" value="ok"/>
  </form>
  
  <a href="csv">下载</a>
  <a href="csv2">下载2</a> -->
  
  
    </section>
  </div>
</div>
<script>
$(function(){
	$("input[name=aa]").on("change",function(){
		console.log($(this));
		var inp = $(this);
		if(inp.attr("id")=="op1"){
			$("#key-inp").prop("disabled",true);
			$("#key-inp").val("");
		}else{
			$("#key-inp").prop("disabled",false);
		}
	})
	
	var key = null;
	$.ajax("get_signature",{
		dataType:"json",
		cache:false,
		method:"post"
	}).done(function(signature){
	
    	$("#f").fileinput({
    		language:'zh',
    		showPreview: false,
    		showUpload: false,
    		showRemove: false,
    		uploadUrl: signature.host,
    	}).on('change', function(event) {
    		$('#f').fileinput('upload');
    	}).on('filepreupload', function(event, data, previewId, index) {
            var form = data.form, files = data.files, extra = data.extra,
                response = data.response, reader = data.reader;
            form.delete("file_id");
            var f=form.get("file");
            form.delete("file")
            var filename=files[0].name;
            var pos = filename.lastIndexOf('.');
            var keyVal = $("#key-inp").val();
            if(keyVal){
				key = keyVal.indexOf("/")==0?keyVal.substring(1):keyVal;
            }else{
	            key = "file/"+filename.substring(0,pos)+"_"+Date.parse(new Date())/1000+filename.substring(pos)
            }
    		form.append("key",key)        
    		form.append("policy",signature.policy)        
    		form.append("OSSAccessKeyId",signature.accessid)        
    		form.append("signature", signature.signature)        
            form.append("file",f)
    
        }).on('fileuploaded', function(event, data, previewId, index) {
            var form = data.form, files = data.files, extra = data.extra,
                response = data.response, reader = data.reader;
            var url = signature.host+key;
            $("#f2").html("文件预览/下载地址：  <a href='"+url+"'>"+url+"</a>")
        }).on('fileuploaderror', function(event, data, msg) {
            var form = data.form, files = data.files, extra = data.extra,
                response = data.response, reader = data.reader;
            console.log('File upload error');
            alert("文件上传异常！");
        	$("#f").fileinput("clear");
        });
	})
	
})
</script>

</body>
</html>