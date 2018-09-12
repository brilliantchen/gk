<!DOCTYPE html>
<html>
<head>
<#include "/layout/header.ftl" />
<script>
$(function(){
  $("#queryForm").resetForm();
  $("#queryBtn").on("click",function(){
    $("#dataTable").DataTable().ajax.reload();
  })
  $("#resetBtn").on("click",function(){
    $("#queryForm").resetForm();
    $("#dataTable").DataTable().ajax.reload();
  })
  
  var table = $('#dataTable').DataTable({
    filter: false,
    lengthChange: false,
    processing: true,
    ordering: false,
    serverSide: true,
    stateSave:false,
    paging:false,
    info:false,
    ajax : {
      url:"/event/product/list",
      type:"post",
      dataSrc:""
    },
    columns:[
      { render : function(data, type, full, meta){
      	return meta.row + 1 + meta.settings._iDisplayStart;
      }},
      { data : "name" },
      { data : "productUrl" },
      { data : "chickLegs" },
      { data : "type",defaultContent:"", render : function(data){
        return {"1":"实物","2":"虚拟"}[data]
      } },
      { data : "stock" },
      { render : function(data, type, full){
        return "<button type='button' class='btn btn-xs btn-primary editBtn' data-toggle='modal' data-target='#saveModal'>编辑</button>"
      }}
	]
  });
  
  $("#addBtn").on("click",function(e){
    var form = $("#saveForm");
    form.clearForm();
    form.find("input[name='id']").val("");
  })
  $("#dataTable").on("click",".editBtn",function(e){
    var tr = $(e.target).closest("tr");
    var data = table.row(tr).data();
    var form = $("#saveForm");
    form.clearForm();
    log(data);
    form.find("input[name='id']").val(data.id);
    form.find("input[name='name']").val(data.name);
    form.find("[name='type']").val(data.type);
    form.find("input[name='productUrl']").val(data.productUrl);
    form.find("input[name='chickLegs']").val(data.chickLegs);
    form.find("input[name='stock']").val(data.stock);
    
  })
  $("#saveBtn").on("click",function(){
    var form = $("#saveForm");
    var a =$("#saveForm").formSerialize();
    var id = form.find("input[name='id']").val();
    var url = id?"/event/product/edit":"/event/product/save";
    form.ajaxSubmit({
      url:url,
      dataType:'json',
      method:"post",
      cache:false,
      success:function(data){
        if(data.success){
       	  $("#saveModal").modal("hide");
       	  $("#dataTable").DataTable().ajax.reload();
        }else{
          alertify.alert(data.errorDescription);
        }
      },error:function(jq,status,e){
        alertify.alert(status);
      }
    })
  })
  
  
})

</script>
<style type="text/css">
</style>
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
                  <strong>兑换品</strong>
                </h3>
              </div>
              <div class="box-body">
                <div class="pull-right"><button id="addBtn" class="btn btn-primary" data-toggle='modal' data-target='#saveModal'>新增</button></div>
                <table id="dataTable" class="table table-bordered table-hover">
                  <thead>
                    <tr>
                      <th>序号</th>
                      <th>名称</th>
                      <th>产品链接</th>
                      <th>鸡腿数</th>
                      <th>类型</th>
                      <th>库存</th>
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
  
  <div id="saveModal" class="modal fade">
    <div class="modal-dialog" role="document">
      <div class="modal-content">
        <div class="modal-header">
        </div>
        <div class="modal-body">
          <form id="saveForm" class="form-horizontal">
            <input type="hidden" name="id" class="id">
            <div class="form-group">
              <label for="" class="control-label col-md-2">名称</label>
              <div class="col-md-9">
                <input type="text" name="name" class="form-control">
              </div>
            </div>
            <div class="form-group">
              <label for="" class="control-label col-md-2">类型</label>
              <div class="col-md-9">
                <select name="type" class="form-control">
                  <option value="1">实物</option>
                  <option value="2">虚拟</option>
                </select>
              </div>
            </div>
            <div class="form-group">
              <label for="" class="control-label col-md-2">产品链接</label>
              <div class="col-md-9">
                <input type="text" name=productUrl class="form-control">
              </div>
            </div>
            <div class="form-group">
              <label for="" class="control-label col-md-2">鸡腿数</label>
              <div class="col-md-9">
                <input type="number" name="chickLegs" class="form-control">
              </div>
            </div>
            <div class="form-group">
              <label for="" class="control-label col-md-2">库存</label>
              <div class="col-md-9">
                <input type="number" name="stock" class="form-control">
              </div>
            </div>
          </form>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
          <button id="saveBtn" type="button" class="btn btn-primary" data-loading-text="提交中...">确定</button>
        </div>
      </div>
    </div>
  </div>
</body>
</html>