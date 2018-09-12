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
      url:"/event/prize/list",
      type:"post",
      dataSrc:""
    },
    columns:[
      { render : function(data, type, full, meta){
      	return meta.row + 1 + meta.settings._iDisplayStart;
      }},
      { data : "name" },
      { data : "type",render : function(data, type, full){
        return {"1":"最福利积分","2":"鸡腿","3":"iphone X","4":"其它"}[data]
      } },
      { data : "percent",render : function(data, type, full){
        return parseFloat(data)+"%";
      } },
      { data : "stock",defaultContent:"" },
      { render : function(data, type, full){
        return "<button type='button' class='btn btn-xs btn-primary editBtn' data-toggle='modal' data-target='#saveModal'>编辑</button>"
      }}
	]
  });
  table.on("processing",function(){
    computePercent();
  })
  
  function computePercent(){
    var s = table.rows().data()
//     log(s.length)
    var total = 0;
    $.each(s,function(i,e){
      total += parseFloat(e.percent)
    })
    $("#percentSpan").html((total).toFixed(2)+"%")
  }
  
  $("#addBtn").on("click",function(e){
    var form = $("#saveForm");
    form.resetForm();
    form.find("input[name='id']").val("");
  })
  $("#dataTable").on("click",".editBtn",function(e){
    var tr = $(e.target).closest("tr");
    var data = table.row(tr).data();
    var form = $("#saveForm");
    form.resetForm();
    form.find("input[name='id']").val(data.id);
    form.find("input[name='name']").val(data.name);
    form.find("[name='type']").val(data.type);
    form.find("input[name='percent']").val(data.percent);
    form.find("input[name='stock']").val(data.stock);
  })
  
  $("#saveBtn").on("click",function(){
    var form = $("#saveForm");
    var a =$("#saveForm").formSerialize();
    var id = form.find("input[name='id']").val();
    var url = id?"/event/prize/edit":"/event/prize/add";
    form.ajaxSubmit({
      url:url,
      dataType:'json',
      method:"post",
      cache:false,
      beforeSubmit:function(arr,form){
        var name = form.find("input[name='name']").val();
        if(!name){
          alertify.error("名称必填");
          return false;
        }
        var type = form.find("[name='type']").val();
        var percent = form.find("input[name='percent']").val();
        var p = parseFloat(percent)
        log(p)
        if(p!==0 && !p){
          alertify.error("概率填写错误");
          return false;
        }
        var stock = form.find("input[name='stock']").val();
        var s = parseInt(stock);
        if(s!==0&&!s){
          alertify.error("库存填写错误");
          return false;
        }
      },
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
                  <strong>抽奖奖品</strong>
                </h3>
              </div>
              <div class="box-body">
                <div class="row"><div class="col-md-12">
                  <h5 class="col-md-offset-6 col-md-2">总概率为 <span id="percentSpan" style="color: red;">%</h5>
<!--                   <div class="pull-right"><button id="addBtn" class="btn btn-primary" data-toggle='modal' data-target='#saveModal'>新增</button></div> -->
                </div></div>
                <table id="dataTable" class="table table-bordered table-hover">
                  <thead>
                    <tr>
                      <th>序号</th>
                      <th>名称</th>
                      <th>类型</th>
<!--                       <th>数量</th> -->
                      <th>概率</th>
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
                <input type="text" name="name" class="form-control" required="required">
              </div>
            </div>
            <div class="form-group">
              <label for="" class="control-label col-md-2">类型</label>
              <div class="col-md-9">
                <select name="type" class="form-control" required="required">
                  <option value="1">最福利积分</option>
                  <option value="2">鸡腿</option>
                  <option value="3">iphone X</option>
                  <option value="4">其它</option>
                </select>
              </div>
            </div>
            <div class="form-group">
              <label for="" class="control-label col-md-2">中奖概率</label>
              <div class="col-md-9">
                <div class="input-group">
                <input type="text" name="percent" class="form-control"><span class="input-group-addon">%</span>
                </div>
              </div>
            </div>
            <div class="form-group">
              <label for="" class="control-label col-md-2">库存</label>
              <div class="col-md-9">
                <input type="text" name="stock" class="form-control">
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