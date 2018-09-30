package com.xq.gk.console.controller;

import com.alibaba.fastjson.JSON;
import com.xq.gk.console.entity.ResultBase;
import com.xq.gk.console.entity.gy.resp.GyBaseResp;
import com.xq.gk.console.entity.gy.resp.GyDeliverysPo;
import com.xq.gk.console.entity.gy.resp.GyDeliverysResp;
import com.xq.gk.console.entity.kl.resp.KlBaseResp;
import com.xq.gk.console.entity.kl.resp.KlOrderConfirmResp;
import com.xq.gk.console.entity.kl.resp.KlOrderStatusQueryResp;
import com.xq.gk.console.service.GyOrderUtilService;
import com.xq.gk.console.service.KlApiService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.CollectionUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import java.util.ArrayList;
import java.util.List;

@RestController
@Slf4j
@RequestMapping(value = "/gk")
public class KlOrderController {

    @Autowired
    private KlApiService klApiService;
    @Autowired
    private GyOrderUtilService gyOrderUtilService;

    /**
     * 考拉订单-查询页面
     */
    @RequestMapping(value = "/kl/order/page", method = RequestMethod.GET)
    public ModelAndView klOrderPage() {
        ModelAndView modelAndView = new ModelAndView("/kl/order_query_page");
        //modelAndView.addObject("typeMap", SupplierType.getAllSupplierType());
        return modelAndView;
    }

    /**
     * 考拉订单-查询--管易不同步
     * @param thirdId
     * @return
     */
    @RequestMapping(value = "/kl/order/{thirdId}", method = RequestMethod.GET)
    @ResponseBody
    public ResultBase<List<KlOrderStatusQueryResp>> klOrderQuery(@PathVariable String thirdId) {
        try {
            GyDeliverysResp gGyDeliverysResp = gyOrderUtilService.getGyDeliverByThirdId(thirdId);
            if(!GyBaseResp.isSuccecd(gGyDeliverysResp) || CollectionUtils.isEmpty(gGyDeliverysResp.getDeliverys())){
                return ResultBase.Fail(-2, "订单未在erp系统中", new ArrayList<KlOrderStatusQueryResp>());
            }
            List<KlOrderStatusQueryResp> rsList = new ArrayList<KlOrderStatusQueryResp>();
            for (GyDeliverysPo po: gGyDeliverysResp.getDeliverys()) {
                KlOrderStatusQueryResp rs = klApiService.queryOrderStatus(po.getCode());
                rs.setGyOrderId(po.getCode());
                rsList.add(rs);
            }
            return  ResultBase.Success(rsList);
        }catch (Exception e){
            return ResultBase.Fail(-1, "系统错误", new ArrayList<KlOrderStatusQueryResp>());
        }
    }

    /**
     * 考拉订单-查询--管易不同步
     * @param sdoId 发货单号
     * @return
     */
    @RequestMapping(value = "/kl/order/sdo/{sdoId}", method = RequestMethod.GET)
    @ResponseBody
    public ResultBase<KlOrderStatusQueryResp> klOrderQueryBySdo(@PathVariable String sdoId) {
        try {
            /*GyDeliverysResp gGyDeliverysResp = gyOrderUtilService.getGyDeliverByCode(sdoId);
            if(!GyBaseResp.isSuccecd(gGyDeliverysResp) || CollectionUtils.isEmpty(gGyDeliverysResp.getDeliverys())){
                return ResultBase.Fail(-2, "订单未在erp系统中", new ArrayList<KlOrderStatusQueryResp>());
            }*/
            KlOrderStatusQueryResp rs = klApiService.queryOrderStatus(sdoId);
            return  ResultBase.Success(rs);
        }catch (Exception e){
            return ResultBase.Fail(-1, "系统错误", null);
        }
    }

    /**
     * 考拉订单-确认--管易不同步
     */
    @RequestMapping(value = "/kl/order/confirm", method = RequestMethod.GET)
    public ResultBase<KlOrderConfirmResp> klOrderConfirm(@RequestParam String code) {
        try {
            GyDeliverysResp gGyDeliverysResp = gyOrderUtilService.getGyDeliverByCode(code);
            if(!GyBaseResp.isSuccecd(gGyDeliverysResp) && !CollectionUtils.isEmpty(gGyDeliverysResp.getDeliverys())){
                return ResultBase.Fail(1001, "管易发货单不存在", null);
            }
            GyDeliverysPo po = gGyDeliverysResp.getDeliverys().get(0);

            KlOrderConfirmResp orderConformResp = klApiService.orderConfirm(po);
            return ResultBase.Success(orderConformResp);
        }catch (Exception e){
            return ResultBase.Fail(-1, "系统错误", null);
        }
    }

    /**
     * 考拉订单-取消页面
     * @return
     */
    @RequestMapping(value = "/kl/order/cancel/page", method = RequestMethod.GET)
    public ModelAndView klOrderCancelPage() {
        ModelAndView modelAndView = new ModelAndView("/kl/order_cancel_page");
        //modelAndView.addObject("typeMap", SupplierType.getAllSupplierType());
        return modelAndView;
    }

    /**
     * 考拉订单-取消--管易不同步
     * @param code
     * @return
     */
    @RequestMapping(value = "/kl/order/{thirdId}/cancel", method = RequestMethod.GET)
    public ResultBase<KlBaseResp> klOrderCancel(@PathVariable String thirdId) {
        try {
            /*GyDeliverysResp gGyDeliverysResp = gyOrderUtilService.getGyDeliverByCode(code);
            if(!GyBaseResp.isSuccecd(gGyDeliverysResp) && !CollectionUtils.isEmpty(gGyDeliverysResp.getDeliverys())){
                return ResultBase.Fail(-2, "管易发货单不存在", JSON.toJSONString(gGyDeliverysResp));
            }*/
            KlBaseResp rs = klApiService.cancelOrder(thirdId);
            return ResultBase.Success(rs);
        }catch (Exception e){
            return ResultBase.Fail(-1, "系统错误", new KlBaseResp());
        }
    }



    /**
     * "考拉订单-确认支付，支付--管易同步：更新转入外仓，同步成功
     * @param code
     * @return
     */
    @RequestMapping(value = "/kl/order/pay", method = RequestMethod.GET)
    public ResultBase<String> klOrderPay( @RequestParam String code) {
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

            //syncOrderService.gyOrderSyncRoundHandler(gGyDeliverysResp.getDeliverys(), -1);
            return ResultBase.Success(JSON.toJSONString(po));
        } catch (Exception e) {
            return ResultBase.Fail(-1, "系统错误", e.getMessage());
        }
    }

    /**
     * 考拉订单-查询并同步物流信息--管易发货单：更新物流信息，已打印
     * @param code
     * @return
     */
    @RequestMapping(value = "/kl/order/express", method = RequestMethod.GET)
    public ResultBase<String> klOrderExpress(@RequestParam String code) {
        try {
            GyDeliverysResp gGyDeliverysResp = gyOrderUtilService.getGyDeliverByCode(code);
            if(!GyBaseResp.isSuccecd(gGyDeliverysResp) && !CollectionUtils.isEmpty(gGyDeliverysResp.getDeliverys())){
                return ResultBase.Fail(-2, "管易发货单不存在", JSON.toJSONString(gGyDeliverysResp));
            }
           // syncOrderService.gyklOrderExpressSyncHandler(gGyDeliverysResp.getDeliverys(), -1);
            return ResultBase.Fail(-1, "查询考拉订单失败", JSON.toJSONString(gGyDeliverysResp.getDeliverys().get(0)));
        }catch (Exception e){
            return ResultBase.Fail(-1, "系统错误", e.getMessage());
        }
    }


}
