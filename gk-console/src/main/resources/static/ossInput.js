//第一个参数为签名，包含四个属性，host,policy,accessid,signature
//第二个参数为存放上传成功后文件url的<input>的jqeury选择字符串
//第三个参数为自定义文件key，为空则自动生成
(function($) {
	$.fn.extend({
		ossInput : function(signature,urlInputSel,key) {
			var inp= $(this[0]);
			inp.fileinput({
    		language:'zh',
    		showPreview: false,
    		showUpload: false,
    		showRemove: false,
    		uploadUrl: signature.host,
    	}).on('change', function() {
    		inp.fileinput('upload');
    	}).on('filepreupload', function(event, data) {
        var form = data.form, files = data.files;
        form.delete("file_id");
        var fileInputName = this.name||"file_data";
        var file=form.get(fileInputName);
        form.delete(fileInputName)
        var filename=files[0].name;
        var pos = filename.lastIndexOf('.');
        key = key || filename.substring(0,pos)+"_"+Date.parse(new Date())/1000+filename.substring(pos)
    		form.append("key",key);
    		form.append("policy",signature.policy);
    		form.append("OSSAccessKeyId",signature.accessid);
    		form.append("signature", signature.signature);
        form.append("file",file);
      }).on('fileuploaded', function() {
        var url = signature.host+key;
        $(urlInputSel).val(url);
      }).on('fileuploaderror', function() {
        console.log('File upload error');
        alert("文件上传异常！");
      	inp.fileinput("clear");
      });
		}
	});
})(jQuery)