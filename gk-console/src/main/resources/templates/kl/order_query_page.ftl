<!DOCTYPE html>
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
                            <h1 class="box-title"><strong>考拉订单管理</strong></h1>
                            <div class="pull-right">
                               <#-- <a type="button" class="btn btn-primary" href="/crowd/add/page">
                                    +发起众筹
                                </a>-->
                            </div>
                        </div>


                    <div class="box-body">


                      <form class="form-horizontal" role="form">

                        <div class="form-group">
                            <label for="" class="control-label col-md-2">招行单号</label>
                            <div class="col-md-3">
                                <input type="text" name="thirdPartyId" id="thirdPartyId" class="form-control col-md-2" />
                            </div>
                            <#--<label for="" class="control-label col-md-2">发货单号</label>
                            <div class="col-md-3">
                                <input type="text" name="gyCode" id="gyCode" class="form-control col-md-2" />
                            </div>-->

                          <div class=" col-sm-2">
                            <button type="button" class="btn btn-primary" id="queryBtn">查询</button>
                          </div>
                        </div>
                      </form>
                    </div>

                        <div class="box-body">

                            <div class="panel panel-default">
                                <div class="panel-heading" >
                                    <h3 class="panel-title" id="panelSummary"></h3>
                                </div>
                                <div class="panel-body"  id="panelTable">
                                    <table class="table">
                                        <tbody>
                                        <tr>
                                            <td><div class="panel-body" >订单：</div></td>
                                            <td><div class="panel-body" id = "gorderId"></div></td>
                                        </tr>
                                        <tr>
                                            <td><div class="panel-body" >总金额：</div></td>
                                            <td><div class="panel-body" id = "gpayAmount"></div></td>
                                        </tr>
                                        <tr>
                                            <td><div class="panel-body" >海关拦截：</div></td>
                                            <td><div class="panel-body" id = "limitReason"></div></td>
                                        </tr>
                                        <tr>
                                            <td><div class="panel-body" >子订单：</div></td>
                                            <td><div class="panel-body" id = "subOrder"></div></td>
                                        </tr>
                                        <tr>
                                            <td><div class="panel-body" >---当前状态：</div></td>
                                            <td><div class="panel-body" id = "status"></div></td>
                                        </tr>
                                        <tr>
                                            <td><div class="panel-body" >---商品：</div></td>
                                            <td><div class="panel-body" id = "skuList"></div></td>
                                        </tr>
                                        <tr>
                                            <td><div class="panel-body" >---物流：</div></td>
                                            <td><div class="panel-body" id = "deliverName"></div></td>
                                        </tr>

                                        </tbody>
                                    </table>
                                </div>
                            </div>

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
        //showPage();

    });

    var initPage = function () {
        $("#queryBtn").on("click", function () {
            klQuery($('#thirdPartyId').val());
        });

    }


    var klQuery = function (id) {
        //alertify.confirm("确认？", function () {
            clear();
            if(id == ''){
                return;
            }
            $.ajax({
                url: '/gk/kl/order/' + id,
                method: 'GET',
                dataType: 'json',
                success: function (rs) {
                    $("#panelTable").html("");
                    if(rs.respCode == 200){
                        for (var j = 0; j < rs.content.length; j++) {
                            $("#panelSummary").text("订单个数：【"+rs.content.length+"】");
                            if(rs.respCode == 200 && rs.content[j].recCode == 200 && rs.content[j].result != null){
                                var skus = rs.content[j].result[0].skuList;
                                var skustr = "";
                                for (var i = 0; i < skus.length; i++) {
                                    skustr += "规格ID："+skus[i].skuid+" 购买数量："+skus[i].buyCnt+" ";
                                }
                                var limit = rs.content[j].result[0].isLimit ? '是-'+rs.content[j].result[0].limitReason : '否';
                                $("#panelTable").append("<table class=\"table\">\n" +
                                        "                            <tbody>\n" +
                                        "                            <tr>\n" +
                                        "                            <td><div class=\"panel-body\" >发货单号：</div></td>\n" +
                                        "                    <td><div class=\"panel-body\" >"+rs.content[j].recMeg+"-"+rs.content[j].gyOrderId+"</div></td>\n" +
                                        "                    </tr>\n" +
                                        "                    <tr>\n" +
                                        "                    <td><div class=\"panel-body\" >总金额：</div></td>\n" +
                                        "                    <td><div class=\"panel-body\" >"+"￥："+rs.content[j].gpayAmount+"</div></td>\n" +
                                        "                    </tr>\n" +
                                        "                    <tr>\n" +
                                        "                    <td><div class=\"panel-body\" >海关拦截：</div></td>\n" +
                                        "                    <td><div class=\"panel-body\" >"+limit+"</div></td>\n" +
                                        "                    </tr>\n" +
                                        "                    <tr>\n" +
                                        "                    <td><div class=\"panel-body\" >子订单：</div></td>\n" +
                                        "                    <td><div class=\"panel-body\" >"+rs.content[j].gorderId+"-"+rs.content[j].result[0].orderId+"</div></td>\n" +
                                        "                    </tr>\n" +
                                        "                    <tr>\n" +
                                        "                    <td><div class=\"panel-body\" >---当前状态：</div></td>\n" +
                                        "                    <td><div class=\"panel-body\" >"+rs.content[j].result[0].desc+":"+rs.content[j].result[0].status+"-"+getOrderStatusName(rs.content[j].result[0].status)+"</td></div>\n" +
                                        "                    </tr>\n" +
                                        "                    <tr>\n" +
                                        "                    <td><div class=\"panel-body\" >---商品：</div></td>\n" +
                                        "                    <td><div class=\"panel-body\" >"+skustr+"</div></td>\n" +
                                        "                    </tr>\n" +
                                        "                    <tr>\n" +
                                        "                    <td><div class=\"panel-body\" >---物流：</div></td>\n" +
                                        "                    <td><div class=\"panel-body\" >"+rs.content[j].result[0].deliverName+"-"+rs.content[j].result[0].deliverNo+"</div></td>\n" +
                                        "                    </tr>\n" +
                                        "\n" +
                                        "                    </tbody>\n" +
                                        "                    </table>");
                            }else {
                                $("#panelTable").append(rs.respMsg + " " + rs.content[j].recMeg);
                            }
                        }
                    }else {
                        $("#panelSummary").html(rs.respMsg);
                    }


                    /*$("#gorderId").text(rs.content.recMeg);
                    if(rs.respCode == 200 && rs.content.recCode == 200 && rs.content.result != null){
                        $("#gorderId").text(rs.content.recMeg+"-"+rs.content.gorderId);
                        $("#gpayAmount").text("￥："+rs.content.gpayAmount);
                        $("#subOrder").text(rs.content.result[0].orderId+"-"+rs.content.result[0].desc);
                        $("#status").text(rs.content.result[0].status+"-"+getOrderStatusName(rs.content.result[0].status));
                        $("#limitReason").text(rs.content.result[0].isLimit ? "是-"+rs.content.result[0].limitReason : "否");
                        $("#deliverName").text(rs.content.result[0].deliverName+"-"+rs.content.result[0].deliverNo);
                        var skus = rs.content.result[0].skuList;
                        var skustr = "";
                        for (var i = 0; i < skus.length; i++) {
                            skustr += "规格ID："+skus[i].skuid+" 购买数量："+skus[i].buyCnt+" ";
                        }
                        $("#skuList").text(skustr);
                        // trackLogistics
                    }else {
                        alertify.alert(rs.respMsg + " " + rs.content.recMeg);
                    }*/

                }
            });
        //});
    }

    function getOrderStatusName(status){
        if(status == 0) return "订单同步失败";
        if(status == 1) return "订单同步成功（等待支付）";
        if(status == 2) return "订单支付成功（等待发货）";
        if(status == 3) return "订单支付失败";
        if(status == 4) return "订单已发货";
        if(status == 5) return "交易成功";
        if(status == 6) return "订单交易失败（用户支付后不能发货）【最终状态】";
        if(status == 7) return "订单关闭";
        if(status == 8) return "退款成功\"(分销走线下不做更新)";
        if(status == 9) return "退款失败\"(分销走线下不做更新)";
        return "NA";
    }

    function clear() {
        $("#panelSummary").html("");
        $("#panelTable").html("");
        /*$("#gorderId").text("");
        $("#gorderId").text("");
        $("#status").text("");
        $("#gpayAmount").text("");
        $("#subOrder").text("");
        $("#limitReason").text("");
        $("#deliverName").text("");
        $("#skuList").text("");*/
    }


    function add0(m) {
        return m < 10 ? '0' + m : m
    }

    function timestampConvert(shijianchuo) {
        var time = new Date(shijianchuo);
        var y = time.getFullYear();
        var m = time.getMonth() + 1;
        var d = time.getDate();
        var h = time.getHours();
        var mm = time.getMinutes();
        var s = time.getSeconds();
        return y + '-' + add0(m) + '-' + add0(d) + ' ' + add0(h) + ':' + add0(mm) + ':' + add0(s);
    }

</script>
</body>
</html>