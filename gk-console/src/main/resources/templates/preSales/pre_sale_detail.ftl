<!DOCTYPE html>
<!--suppress ALL -->
<html>
<head>
<#include "/layout/header.ftl">

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
              <h1 class="box-title"><strong>预售项目</strong></h1>
              <div class="pull-right">
                <a type="button" class="btn btn-default" id="cancel"
                   href="/pre/list/page">
                  关闭
                </a>
              </div>
            </div>

            <div class="box-body">
              <form id="addForm">
              <#if vo??>
                <div class="form-horizontal">
                  <div class="form-group">
                    <label for="" class="col-sm-3 control-label">预售项目名称：</label>
                    <div class="col-sm-5">
                      <h5 class="" >
                      <#if vo.projectStatus== 10>
                        <span class="label label-warning">待发布</span>
                      <#elseif vo.projectStatus== 20>
                        <span class="label label-success">已发布</span>
                      <#elseif vo.projectStatus== 100>
                        <span class="label label-default">已售罄</span>
                      <#else>
                      </#if>
                        &nbsp;&nbsp;&nbsp;
                        <#if vo.channel== 10>
                          <span class="label label-info">连陌自营</span>
                        <#elseif vo.channel== 20>
                          <span class="label label-info">提货券</span>
                        <#elseif vo.channel== 21>
                          <span class="label label-info">提货券-最福利专供</span>
                        <#else>
                        </#if>
                        &nbsp;&nbsp;&nbsp;
                       ${vo.name!''}</h5>
                    </div>
                  </div>
                  <div class="form-group">
                    <label for="" class="col-sm-3 control-label">预售开始时间：</label>
                    <div class="col-sm-5">
                      <h5 class="" id="startTime_h5" >${vo.startTime?datetime}</h5>
                    </div>
                  </div>
                  <div class="form-group">
                    <label for="" class="col-sm-3 control-label">预售产品名称：</label>
                    <div class="col-sm-5">
                      <h5 class="" >${vo.title!''}</h5>
                    </div>
                  </div>
                  <div class="form-group">
                    <label for="" class="col-sm-3 control-label">预售标签：</label>
                    <#if vo.labels??>
                      <#list vo.labels as e>
                      <div class="col-sm-1">
                        <h4> <span class="label label-info">${e}&nbsp;</span></h4>
                      </div>
                      </#list>
                    </#if>
                  </div>
                  <div class="form-group">
                    <label for="" class="col-sm-3 control-label">现价：</label>
                    <div class="col-sm-3">
                      <h5 class="" >${vo.sellPrice!''}</h5>
                    </div>
                    <label for="" class="col-sm-2 control-label">原价：</label>
                    <div class="col-sm-3">
                      <h5 class="" >${vo.originalPrice!''}</h5>
                    </div>
                  </div>
                  <div class="form-group">
                    <label for="" class="col-sm-3 control-label">预售产品说明：</label>
                    <div class="col-sm-5">
                                            <h5 > ${vo.desc!''}</h5>
                    </div>
                  </div>
                  <div class="form-group">
                    <label for="" class="col-sm-3 control-label">预售产品总量：</label>
                    <div class="col-sm-3">
                      <h5 class="" >${vo.totalNum?c}</h5>
                    </div>
                    <label for="" class="col-sm-2 control-label">预售警告总量：</label>
                    <div class="col-sm-3">
                      <h5 class="" >${vo.alertStock?c}</h5>
                    </div>
                  </div>
                  <div class="form-group">
                    <label for="" class="col-sm-3 control-label">分享URL：</label>
                    <div class="col-sm-5">
                      <h5 class="" >${vo.shareUrl !''}</h5>
                    </div>
                  </div>
                  <!-- 点击 弹框添加 -->
                  <div class="form-group">
                    <label for="" class="col-sm-3 control-label">预售产品规格：</label>
                    <div class="col-sm-8">
                      <table class="table with-border" id="pre_skus">
                        <thead>
                        <tr><th style="width: 200px;">图片</th><th>规格名称</th><th>售价</th><th>库存</th><th>已售</th><th>详情</th></tr>
                        </thead>
                      <#list vo.skus as e>
                        <tr><td ><img style="width: 180px;" src="${e.img}"></td><td>${e.name}</td><td>${e.price}</td><td>${e.stock}</td><td>${e.sold}</td><td>${e.desc}</td><td style="display: none">${e.img}</td></tr>
                      </#list>
                      </table>
                    </div>
                  </div>

                  <div class="form-group">
                    <label for="" class="col-sm-3 control-label">预售促销活动：</label>
                    <div class="col-sm-5">
                    <#if vo.promotions??>
                      <table class="table with-border" id="pre_proms">
                        <thead>
                        <tr><th>活动标签</th><th>活动说明</th></tr>
                        </thead>
                        <#list vo.promotions as e>
                          <tr><td>${e.title}</td><td>${e.desc}</td></tr>
                        </#list>
                      </table>
                    </#if>
                    </div>
                  </div>
                  <div class="form-group">
                    <label for="" class="col-sm-3 control-label">封面图：</label>
                      <div class="col-sm-3">
                        <img class="img-responsive"
                             src="${vo.coverImg!''}">
                      </div>
                  </div>
                  <div class="form-group">
                    <label for="" class="col-sm-3 control-label">Banner轮播图片上传：</label>
                    <#if vo.bannerImgs??>
                    <#list vo.bannerImgs as e>
                      <div class="col-sm-2">
                        <img class="img-responsive"
                             src="${e}">
                      </div>
                    </#list>
                    </#if>
                  </div>
                  <div class="form-group">
                    <label for="" class="col-sm-3 control-label">商品详情页上传：</label>
                  <#if vo.bannerImgs??>
                  <#list vo.imgs as e>
                    <div class="col-sm-1">
                      <img class="img-responsive"
                           src="${e}">
                    </div>
                  </#list>
                  </#if>
                  </div>

                </div>
              </#if>
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


</script>
</body>
</html>