package com.gysync.kaola.controller;

import com.alibaba.fastjson.JSON;
import com.gysync.kaola.entity.ResultBase;
import com.gysync.kaola.entity.gy.resp.GyBaseResp;
import com.gysync.kaola.entity.gy.resp.GyDeliveryUpdateResp;
import com.gysync.kaola.entity.gy.resp.GyDeliverysResp;
import com.gysync.kaola.service.GyOrderUtilService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@Slf4j
@Api(description = "管易发货单管理")
public class GyManualController {

    @Autowired
    private GyOrderUtilService gyOrderUtilService;

    @ApiOperation(value = "管易发货单-查询", tags = "管易,发货单")
    @RequestMapping(value = "/gy/order/query", method = RequestMethod.GET)
    public String GyOrderQuery(@ApiParam("管易发货单号") @RequestParam String code) {
        try {
            ResultBase<GyDeliverysResp> rs = ResultBase.Success(gyOrderUtilService.getGyDeliverByCode(code));
            return JSON.toJSONString(rs);
        }catch (Exception e){
            return JSON.toJSONString(ResultBase.Fail(-2, "", e.getMessage()));
        }
    }

    @ApiOperation(value = "管易发货单-考拉订单确认，转入外仓", tags = "管易,发货单")
    @RequestMapping(value = "/gy/order/confirm", method = RequestMethod.GET)
    public String GyOrderConfirm(@ApiParam("管易发货单号") @RequestParam String code) {
        try {
            GyDeliverysResp rs = gyOrderUtilService.getGyDeliverByCode(code);
            if(!GyBaseResp.isSuccecd(rs)){
                return JSON.toJSONString(ResultBase.Fail(-1, "", rs));
            }
            GyDeliveryUpdateResp gyDeliveryUpdateResp = gyOrderUtilService.updateDeliverysToOtherWareHouse(code);
            return JSON.toJSONString(gyDeliveryUpdateResp);
        }catch (Exception e){
            return JSON.toJSONString(ResultBase.Fail(-2, "", e.getMessage()));
        }
    }

    @ApiOperation(value = "管易发货单-考拉订单支付成功（失败），同步成功（失败），", tags = "管易,发货单")
    @RequestMapping(value = "/gy/order/pay", method = RequestMethod.GET)
    public String GyOrderPay(@ApiParam("管易发货单号") @RequestParam String code,
                             @ApiParam("同步状态1 同步成功，-1失败") @RequestParam int status) {
        try {
            if(status == 0){
                return JSON.toJSONString(ResultBase.Fail(-101, "请输入发货单同步状态", ""));
            }
            GyDeliverysResp rs = gyOrderUtilService.getGyDeliverByCode(code);
            if(!GyBaseResp.isSuccecd(rs)){
                return JSON.toJSONString(ResultBase.Fail(-1, "", rs));
            }
            GyBaseResp gyBaseResp = gyOrderUtilService.updateDeliveryStatus(code, status);
            return JSON.toJSONString(gyBaseResp);
        }catch (Exception e){
            return JSON.toJSONString(ResultBase.Fail(-2, "", e.getMessage()));
        }
    }



}
