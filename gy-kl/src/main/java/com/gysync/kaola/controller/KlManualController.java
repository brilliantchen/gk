package com.gysync.kaola.controller;

import com.alibaba.fastjson.JSON;
import com.gysync.kaola.comm.util.GuanYiUtil;
import com.gysync.kaola.entity.ResultBase;
import com.gysync.kaola.entity.gy.resp.GyBaseResp;
import com.gysync.kaola.entity.gy.resp.GyDeliveryUpdateResp;
import com.gysync.kaola.entity.gy.resp.GyDeliverysPo;
import com.gysync.kaola.entity.gy.resp.GyDeliverysResp;
import com.gysync.kaola.entity.kl.resp.*;
import com.gysync.kaola.service.GyOrderUtilService;
import com.gysync.kaola.service.KlApiService;
import com.gysync.kaola.service.SyncOrderService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.CollectionUtils;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.List;

@RestController
@Slf4j
@Api(description = "考拉订单管理")
public class KlManualController {

    @Autowired
    private KlApiService klApiService;
    @Autowired
    private GyOrderUtilService gyOrderUtilService;

    @Autowired
    private SyncOrderService syncOrderService;

    @ApiOperation(value = "考拉订单-确认--管易不同步", tags = "考拉,订单")
    @RequestMapping(value = "/kl/order/confirm", method = RequestMethod.GET)
    public ResultBase<String> klOrderConfirm(@ApiParam("管易发货单号") @RequestParam String code) {
        try {
            GyDeliverysResp gGyDeliverysResp = gyOrderUtilService.getGyDeliverByCode(code);
            if(!GyBaseResp.isSuccecd(gGyDeliverysResp) && !CollectionUtils.isEmpty(gGyDeliverysResp.getDeliverys())){
                return ResultBase.Fail(1001, "管易发货单不存在", JSON.toJSONString(gGyDeliverysResp));
            }
            GyDeliverysPo po = gGyDeliverysResp.getDeliverys().get(0);

            /*po.setReceiver_name("曾千山");
            po.setVip_real_name("曾千山");
            po.setVip_id_card("510421198302065863"); //一般贸易商品可不传
            po.getDetails().get(0).setQty(1);
            po.getDetails().get(0).setItem_code("49255695");
            po.getDetails().get(0).setSku_code("49255695-ecc4090b639c47f89b453980923afb8e");
            po.getDetails().get(0).setAmount(200d);*/

            KlOrderConfirmResp orderConformResp = klApiService.orderConfirm(po);
            return ResultBase.Success(JSON.toJSONString(orderConformResp));
        }catch (Exception e){
            return ResultBase.Fail(-1, "系统错误", e.getMessage());
        }
    }

    @ApiOperation(value = "考拉订单-取消--管易不同步", tags = "考拉,订单")
    @RequestMapping(value = "/kl/order/cancel", method = RequestMethod.GET)
    public ResultBase<String> klOrderCancel(@ApiParam("管易发货单号") @RequestParam String code) {
        try {
            GyDeliverysResp gGyDeliverysResp = gyOrderUtilService.getGyDeliverByCode(code);
            if(!GyBaseResp.isSuccecd(gGyDeliverysResp) && !CollectionUtils.isEmpty(gGyDeliverysResp.getDeliverys())){
                return ResultBase.Fail(-2, "管易发货单不存在", JSON.toJSONString(gGyDeliverysResp));
            }
            syncOrderService.gyklOrderCancelSyncHandler(gGyDeliverysResp.getDeliverys(), -1);
            return ResultBase.Success(JSON.toJSONString(gGyDeliverysResp.getDeliverys().get(0)));
        }catch (Exception e){
            return ResultBase.Fail(-1, "系统错误", e.getMessage());
        }
    }

    @ApiOperation(value = "考拉订单-查询--管易不同步", tags = "考拉,订单")
    @RequestMapping(value = "/kl/order/query", method = RequestMethod.GET)
    public ResultBase<String> klOrderQuery(@ApiParam("管易发货单号") @RequestParam String code) {
        try {
            GyDeliverysResp gGyDeliverysResp = gyOrderUtilService.getGyDeliverByCode(code);
            if(!GyBaseResp.isSuccecd(gGyDeliverysResp) && !CollectionUtils.isEmpty(gGyDeliverysResp.getDeliverys())){
                return ResultBase.Fail(-2, "管易发货单不存在", JSON.toJSONString(gGyDeliverysResp));
            }
            KlOrderStatusQueryResp rs = klApiService.queryOrderStatus(code);
            return  ResultBase.Success(JSON.toJSONString(rs));
        }catch (Exception e){
            return ResultBase.Fail(-1, "系统错误", e.getMessage());
        }
    }

    @ApiOperation(value = "考拉订单-确认支付，支付--管易同步：更新转入外仓，同步成功", tags = "考拉,订单")
    @RequestMapping(value = "/kl/order/pay", method = RequestMethod.GET)
    public ResultBase<String> klOrderPay(@ApiParam("管易发货单号") @RequestParam String code) {
        try {
            GyDeliverysResp gGyDeliverysResp = gyOrderUtilService.getGyDeliverByCode(code);
            if (!GyBaseResp.isSuccecd(gGyDeliverysResp) && !CollectionUtils.isEmpty(gGyDeliverysResp.getDeliverys())) {
                return ResultBase.Fail(-2, "管易发货单不存在", JSON.toJSONString(gGyDeliverysResp));
            }
            GyDeliverysPo po = gGyDeliverysResp.getDeliverys().get(0);

            /*po.setReceiver_name("曾千山");
            po.setVip_real_name("曾千山");
            po.setVip_id_card("510421198302065863"); //一般贸易商品可不传
            po.getDetails().get(0).setQty(1);
            po.getDetails().get(0).setItem_code("49255695");
            po.getDetails().get(0).setSku_code("49255695-ecc4090b639c47f89b453980923afb8e");
            po.getDetails().get(0).setAmount(200d);*/

            syncOrderService.gyOrderSyncRoundHandler(gGyDeliverysResp.getDeliverys(), -1);
            return ResultBase.Success(JSON.toJSONString(po));
        } catch (Exception e) {
            return ResultBase.Fail(-1, "系统错误", e.getMessage());
        }
    }

    @ApiOperation(value = "考拉订单-查询并同步物流信息--管易发货单：更新物流信息，已打印", tags = "考拉,订单")
    @RequestMapping(value = "/kl/order/express", method = RequestMethod.GET)
    public ResultBase<String> klOrderExpress(@ApiParam("管易发货单号") @RequestParam String code) {
        try {
            GyDeliverysResp gGyDeliverysResp = gyOrderUtilService.getGyDeliverByCode(code);
            if(!GyBaseResp.isSuccecd(gGyDeliverysResp) && !CollectionUtils.isEmpty(gGyDeliverysResp.getDeliverys())){
                return ResultBase.Fail(-2, "管易发货单不存在", JSON.toJSONString(gGyDeliverysResp));
            }
            syncOrderService.gyklOrderExpressSyncHandler(gGyDeliverysResp.getDeliverys(), -1);
            return ResultBase.Fail(-1, "查询考拉订单失败", JSON.toJSONString(gGyDeliverysResp.getDeliverys().get(0)));
        }catch (Exception e){
            return ResultBase.Fail(-1, "系统错误", e.getMessage());
        }
    }


}
