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
      <div class="row col-md-12">

        <div class="box">
          <div class="box-header with-border">
            <h1 class="box-title"><strong>众筹</strong></h1>
            <div class="pull-right">
              <a type="button" class="btn btn-default" id="cancel"
                 href="/crowd/list/page">
                关闭
              </a>
            </div>
          </div>
          <div class="box-body">
            <form id="addForm">
              <p type="hidden" name="id" value="${vo.id}">

              <div class="form-horizontal">

                <div class="form-group">
                  <label for="" class="col-sm-3 control-label">项目名称：</label>
                  <div class="col-sm-5">
                    <h5 id="crd_projectName"
                        name="projectName">${vo.projectName}</h5>
                  </div>
                </div>
                <div class="form-group">
                  <label for="" class="col-sm-3 control-label">封面图片：</label>
                  <div class="col-sm-3">
                    <img class="img-responsive"
                         src="${vo.coverImg}">
                  </div>
                </div>
                <div class="form-group">
                  <label for="" class="col-sm-3 control-label">项目图片：</label>

                <#list vo.projectImgs?split("|") as e>
                  <div class="col-sm-1">
                    <img class="img-responsive"
                         src="${e}">
                  </div>
                </#list>


                </div>
                <div class="form-group">
                  <label for="i_influent_name" class="col-sm-3 control-label">金额/份：</label>
                  <div class="col-sm-3">
                    <h5 id="crd_minFundraising"
                        name="minFundraising">${vo.minFundraising}</h5>
                  </div>
                  <label for="i_influent_name" class="col-sm-2 control-label">限购份数：</label>
                  <div class="col-sm-3">
                    <h5>${vo.maxBuyNumber}</h5>
                  </div>
                </div>
                <div class="form-group">
                  <label for="" class="col-sm-3 control-label">目标金额：</label>
                  <div class="col-sm-3">
                    <h5>${vo.fundraisingGoal}</h5>
                  </div>
                  <label for="" class="col-sm-2 control-label">允许超卖：</label>
                  <div class="col-sm-3">
                  <#if vo.stockLimit?? && vo.stockLimit == "Y">

                    <label class="radio-inline"><input type="radio" name="stockLimit" checked
                    >否</label>
                  <#else>
                    <label class="radio-inline"><input type="radio" name="stockLimit" checked
                    >是</label>
                  </#if>

                  </div>
                </div>

                <div class="form-group">
                  <label for="" class="col-sm-3 control-label">开始日期：</label>
                  <div class="col-sm-3">
                    <h5>${vo.projectCreatedTime?string("yyyy-MM-dd")}</h5>
                  </div>
                  <label for="" class="col-sm-2 control-label">结束日期：</label>
                  <div class="col-sm-3">
                    <h5>${vo.projectFundraisingEndTime?string("yyyy-MM-dd")}</h5>
                  </div>
                </div>

              <#if vo.fundraisingAmount?? && vo.fundraisingAmount!="">
                <div class="form-group">
                  <label for="i_influent_name" class="col-sm-3 control-label">支持人数：</label>
                  <div class="col-sm-2">
                    <h5 id="crd_minFundraising"
                        name="minFundraising">${vo.fundraisingUserNum}</h5>
                  </div>
                  <div class="col-sm-5">
                    <div class="progress-group">
                      <#assign amountPre =  vo.fundraisingAmount?eval/vo.fundraisingGoal?eval>
                      <span class="progress-text">筹集金额：${amountPre*100}%</span>
                      <span
                          class="progress-number"><b>${vo.fundraisingAmount}</b>/${vo.fundraisingGoal}</span>
                      <div class="progress sm">
                        <div class="progress-bar progress-bar-aqua"
                             style="width: ${amountPre*100}%"></div>
                      </div>
                    </div>
                  </div>
                </div>
              </#if>
                <div class="form-group">
                  <label for="" class="col-sm-3 control-label">状态</label>
                  <div class="col-sm-6">

                  <#if vo.projectStatus == 1>
                    <h5>待审核</h5>
                  <#elseif vo.projectStatus == 2>
                    <h5>审核中</h5>
                  <#elseif vo.projectStatus == 4>
                    <h5>审核失败</h5>
                  <#elseif vo.projectStatus == 6>
                    <h5>审核通过</h5>
                  <#elseif vo.projectStatus == 10>
                    <h5>待开始</h5>
                  <#elseif vo.projectStatus == 20>
                    <h5>众筹中</h5>
                  <#elseif vo.projectStatus == 30>
                    <h5>众筹成功</h5>
                  <#elseif vo.projectStatus == 40>
                    <h5>众筹失败</h5>
                  <#else>
                  </#if>

                  </div>

                </div>

                <div class="form-group">
                  <label for="" class="col-sm-3 control-label">资金用途：</label>
                  <div class="col-sm-9">
                    <div name="fundUse" id="crd_fundUse" cols="" rows="3"
                         style="width:100%">${vo.fundUse}</div>
                  </div>
                </div>

                <div class="form-group">
                  <label for="" class="col-sm-3 control-label">购买流程：</label>
                  <div class="col-sm-9">
                    <div name="purchaseProcess" id="crd_purchaseProcess" cols="" rows="3"
                         style="width:100%">${vo.purchaseProcess}</div>
                  </div>
                </div>
                <div class="form-group">
                  <label for="" class="col-sm-3 control-label">回报方式：</label>
                  <div class="col-sm-9">
                    <div name="projectReturnMode" id="crd_projectReturnMode" cols="" rows="3"
                         style="width:100%">${vo.projectReturnMode}</div>
                  </div>
                </div>
                <div class="form-group">
                  <label for="" class="col-sm-3 control-label">项目详情：</label>
                  <div class="col-sm-9">
                    <div name="projectProfile" id="crd_projectProfile" cols="" rows="5"
                         style="width:100%">${vo.projectProfile}</div>
                  </div>
                </div>

                <div class="modal-footer">
                  <div class="col-sm-offset-2 col-sm-10">
                  <#--<a type="button" class="btn btn-default" id="cancel"
                       href="/crowd/list/page">
                      关闭
                    </a>-->

                  </div>
                </div>
              </div>
            </form>
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
  });

  var initPage = function () {

  };


</script>
</body>
</html>