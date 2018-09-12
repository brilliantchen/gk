package com.gysync.kaola.service.impl;

import com.gysync.kaola.comm.Constant;
import com.gysync.kaola.comm.util.DateUtil;
import com.gysync.kaola.comm.util.GuanYiUtil;
import com.gysync.kaola.dao.OrderErrorDao;
import com.gysync.kaola.dao.OrderPoDao;
import com.gysync.kaola.entity.gy.resp.GyBaseResp;
import com.gysync.kaola.entity.gy.resp.GyDeliveryUpdateResp;
import com.gysync.kaola.entity.gy.resp.GyDeliverysPo;
import com.gysync.kaola.entity.gy.resp.GyDeliverysResp;
import com.gysync.kaola.entity.kl.resp.*;
import com.gysync.kaola.entity.po.OrderErrorPo;
import com.gysync.kaola.entity.po.OrderPo;
import com.gysync.kaola.service.GyApiService;
import com.gysync.kaola.service.GyOrderUtilService;
import com.gysync.kaola.service.KlApiService;
import com.gysync.kaola.service.SyncOrderService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.CollectionUtils;
import org.springframework.util.StringUtils;

import java.util.Date;
import java.util.List;
import java.util.Map;

@Service
@Slf4j
public class SyncOrderServiceImpl implements SyncOrderService {

    @Autowired
    private GyApiService gyApiService;
    @Autowired
    private KlApiService klApiService;
    @Autowired
    private OrderPoDao orderPoDao;
    @Autowired
    private OrderErrorDao orderErroDao;
    /*@Autowired
    private OrderKlConfirmPoDao orderKlConfirmPoDao;
    @Autowired
    private OrderKlPayPoDao orderKlPayPoDao;
    @Autowired
    private OrderKlCancelPoDao orderKlCancelPoDao;*/
    @Autowired
    private GyOrderUtilService gyOrderUtilService;

    @Override
    public long gyklOrderSync(Map<String, Object> map) {
        long cost = 0l;
        long time = System.currentTimeMillis();
        log.info("gykl order sync start...");
        this.gyklOrderSyncByRound(map,  1,  0);
        cost = (System.currentTimeMillis()-time)/1000;
        log.info("gykl order sync end... time cost:{}s", cost);
        return cost;
    }

    @Override
    public long gyklOrderFix(Map<String, Object> map){
        long cost = 0l;
        long time = System.currentTimeMillis();
        log.info("gykl order fix start...");
        cost = (System.currentTimeMillis()-time)/1000;
        log.info("gykl order fix end... time cost:{}s", cost);
        return cost;
    }

    public long gyklOrderExpressSync(Map<String, Object> map){
        long cost = 0l;
        long time = System.currentTimeMillis();
        log.info("gykl order express start...");
        this.gyklOrderExpressSyncByRound(map,  1,  0);
        cost = (System.currentTimeMillis()-time)/1000;
        log.info("gykl order express end... time cost:{}s", cost);
        return cost;
    }
    @Override
    public long gyklOrderCancel(Map<String, Object> map){
        long cost = 0l;
        long time = System.currentTimeMillis();
        log.info("gykl order cancel start...");
        this.gyklOrderCancelByRound(map,  1,  0);
        cost = (System.currentTimeMillis()-time)/1000;
        log.info("gykl order cancel end... time cost:{}s", cost);
        cost = (System.currentTimeMillis()-time)/1000;
        return cost;
    }


    private void gyklOrderSyncByRound(Map<String, Object> map, int round, int count){
        // map.put("warehouse_code", warehouseCode); //须制定仓库
        // map.put("sync_status", "0"); // -1 失败 0 未同步 1 成功
        // map.put("del", "0");
        map.put("page_no", String.valueOf(round)); //因为管易发货单已经被update，一直获取第一页（但是有失败的订单每次都会返回，confirm失败一直未转入外仓）
        map.put("page_size", String.valueOf(Constant.page_size));
        try {
            // step 1.抽取管易发货单（未同步）
            GyDeliverysResp rs = gyApiService.getDeliverys(map);
            if(round == 1) count = rs.getTotal();
            log.info("gyOrderSync success:{} count:{} round:{} ...",GyBaseResp.isSuccecd(rs), count, round);
            if(count > 0){

                if(GyBaseResp.isSuccecd(rs) && !CollectionUtils.isEmpty(rs.getDeliverys())){
                    try {
                        this.gyOrderSyncRoundHandler(rs.getDeliverys(), round);
                    }catch (Exception e){
                        log.info("gyOrderSync error round::{}. ",count, e);
                    }
                }
            }
            count -= Constant.page_size;
            if(count > 0){
                gyklOrderSyncByRound(map,round+1, count); //返回上轮剩余个数
            }
        }catch (Exception e){
            log.error("gyOrderSync error round::{}. ",count, e);
        }
        // 此写法超过10单失败，后面的无法下单
        /*map.put("page_no", "1"); //因为管易发货单已经被update，一直获取第一页（但是有失败的订单每次都会返回，confirm失败一直未转入外仓）
        map.put("page_size", String.valueOf(Constant.page_size));
        try {
            // step 1.抽取管易发货单（未同步）
            GyDeliverysResp rs = gyApiService.getDeliverys(map);
            int currentRoundCount = rs.getTotal(); // 本轮还未同步总数
            log.info("gyOrderSync success:{} count:{} round:{} ...",GyBaseResp.isSuccecd(rs), currentRoundCount, round);

            if(currentRoundCount > 0){
                if(round > 1 && currentRoundCount == count) {
                    // 失败的订单造成死循环
                    log.error("gyOrderSync success:{} count:{} round:{} endlesssss",GyBaseResp.isSuccecd(rs), currentRoundCount, round);
                    return;
                }
                if(GyBaseResp.isSuccecd(rs) && !CollectionUtils.isEmpty(rs.getDeliverys())){
                    try {
                        this.gyOrderSyncRoundHandler(rs.getDeliverys(), round);
                    }catch (Exception e){
                        log.info("gyOrderSync error round::{}. ",currentRoundCount, e);
                    }
                }
            }
            // currentRoundCount -= Constant.page_size;
            if(currentRoundCount > Constant.page_size){
                gyklOrderSyncByRound(map,round+1, currentRoundCount); //返回上轮剩余个数
            }
        }catch (Exception e){
            log.error("gyOrderSync error round::{}. ",count, e);
        }*/
    }
    @Override
    public void gyOrderSyncRoundHandler(List<GyDeliverysPo> deliverys, int round){
        log.info("gyOrderSync round:{}. starting....",round);
        int i = 1;
        for (GyDeliverysPo po : deliverys) {
            boolean orderInit = true;
            int klOrderSize = 0;
            int klOrderConfirm = 0;
            int klVerifyLevel = 0;
            int klorderPay = 0;
            double klAmount = 0;
            String klOrderId = "";
            int klOrderStatus = 0;
            int gySyncStatus = 0;
            log.info("gyOrderSync round-item:{}-{} starting...",round, i);

            OrderPo orderPo = this.findOrderPoTryCatch(po.getCode());
            OrderErrorPo orderErroPo = this.findOrderErroTryCatch(po.getCode());

            if (null == orderPo){
                orderPo = new OrderPo();
                orderPo.setOrderId(po.getCode());
                orderPo.setThirdPartOrderId(po.getPlatform_code());
                orderPo.setReceiverName(po.getReceiver_name());
                orderPo.setMobile(po.getReceiver_mobile());
                orderPo.setRealName(po.getReceiver_name());
                orderPo.setRealCard(po.getVip_id_card());
                orderPo.setOrderItemSize(po.getDetails().size());
                orderPo.setAreaMame(po.getArea_name());
                orderPo.setAddress(po.getReceiver_address());
                orderPo.setGyAmount(po.getAmount());
                orderPo.setCreateTime(DateUtil.stringToDate(po.getCreate_date(), DateUtil.dateTimeFormat));
            }else {
                orderInit = false;
            }
            // this.saveOrderPoTryCatch(orderPo); // loacal 1.保存订单-管易结果
            // step 2.考拉订单确认接口，确定仓库
            boolean priceChange = gyOrderUtilService.changeChannelPriceToKl(po); // 修改管易商品价格为考拉价格
            KlOrderConfirmResp localValidate =  GyDeliverysPo.isValidated(po);
            if (!KlBaseResp.isSuccecd(localValidate)) {
                if (null == orderErroPo){
                    orderErroPo = new OrderErrorPo();
                    orderErroPo.setOrderId(po.getCode());
                    orderErroPo.setThirdPartyId(po.getPlatform_code());
                    orderErroPo.setCreateTime(DateUtil.stringToDate(po.getCreate_date(), DateUtil.dateTimeFormat));
                }
                orderErroPo.setKlConfirmError(localValidate.getRecMeg());
            }
            KlOrderConfirmResp orderConformResp = klApiService.orderConfirm(po);
            if(!KlBaseResp.isSuccecd(orderConformResp)){
                if (null == orderErroPo){
                    orderErroPo = new OrderErrorPo();
                    orderErroPo.setOrderId(po.getCode());
                    orderErroPo.setThirdPartyId(po.getPlatform_code());
                    orderErroPo.setCreateTime(DateUtil.stringToDate(po.getCreate_date(), DateUtil.dateTimeFormat));
                }
                orderErroPo.setKlConfirmError("考拉校验失败-"+orderConformResp.getRecMeg()+" klRecCode:"+orderConformResp.getRecCode()+"--"+orderConformResp.getSubCode());
            }
            klOrderConfirm = KlBaseResp.isSuccecd(orderConformResp) ? 1 : -1;
            log.info("gyOrderSync round-item:{}-{} stage1 kl confirm:{} ...priceChange:{}",round, i, KlBaseResp.isSuccecd(orderConformResp), priceChange);

            if(KlBaseResp.isSuccecd(orderConformResp) && null != orderConformResp.getOrderForm()
                    && null != orderConformResp.getOrderForm().getPackageList()){
                //orderPo.setKlOrderSize(orderConformResp.getOrderForm().getPackageList().size());
                //orderPo.setKlOrderConform(true);
                List<KlOrderConfirmPkg> packageList = orderConformResp.getOrderForm().getPackageList();
                klOrderSize = packageList.size();
                klVerifyLevel = orderConformResp.getOrderForm().getNeedVerifyLevel();

                // step 2.修改管易发货单状态为转入外仓
                GyDeliveryUpdateResp gyDeliveryUpdateResp = gyOrderUtilService.updateDeliverysToOtherWareHouse(po.getCode());
                if(!GyBaseResp.isSuccecd(gyDeliveryUpdateResp)){
                    if (null == orderErroPo){
                        orderErroPo = new OrderErrorPo();
                        orderErroPo.setOrderId(po.getCode());
                        orderErroPo.setThirdPartyId(po.getPlatform_code());
                        orderErroPo.setCreateTime(DateUtil.stringToDate(po.getCreate_date(), DateUtil.dateTimeFormat));
                    }
                    orderErroPo.setGyWhousError("管易转入外仓失败-"+gyDeliveryUpdateResp.getErrorDesc() + ". subError::" +gyDeliveryUpdateResp.getSubErrorDesc());
                }
                log.info("gyOrderSync round-item:{}-{} stage2 gy U warehouse :{}...",round, i, GyBaseResp.isSuccecd(gyDeliveryUpdateResp));
                // 可能会拆包，一般不会拆包，招行一物一单
                for (KlOrderConfirmPkg pkg:packageList) {
                    // step 3 考拉下单支付
                    KlOrderPayResp klOrderPayResp = klApiService.bookpayorder(po, pkg);
                    log.info("gyOrderSync round-item:{}-{} stage3 kl pay:{}...",round, i, KlBaseResp.isSuccecd(klOrderPayResp));

                    if(KlBaseResp.isSuccecd(klOrderPayResp)){
                        //orderPo.setKlOrderPay(true);
                        //orderPo.setKlOrderId(klOrderPayResp.getGorder().getId());
                        //orderPo.setKlOrderStatus(klOrderPayResp.getGorder().getGorderStatus());
                        klorderPay = 1;
                        gySyncStatus = 1;
                        if(null != klOrderPayResp.getGorder()){
                            klOrderId = klOrderPayResp.getGorder().getId();
                            klOrderStatus = klOrderPayResp.getGorder().getGorderStatus();
                            klAmount = klOrderPayResp.getGorder().getGorderAmount();
                        }
                    } else{
                        klorderPay = -1;
                        gySyncStatus = -1;
                        if (null == orderErroPo){
                            orderErroPo = new OrderErrorPo();
                            orderErroPo.setOrderId(po.getCode());
                            orderErroPo.setThirdPartyId(po.getPlatform_code());
                            orderErroPo.setCreateTime(DateUtil.stringToDate(po.getCreate_date(), DateUtil.dateTimeFormat));
                        }
                        orderErroPo.setKlPayError("考拉支付失败-"+klOrderPayResp.getRecMeg()+" klRecCode:"+orderConformResp.getRecCode()+"--"+orderConformResp.getSubCode());
                    }
                    // step 4 发货单同步状态批量修改接口
                    GyBaseResp gyBaseResp = gyOrderUtilService.updateDeliveryStatus(po.getCode(), gySyncStatus);
                    if(!GyBaseResp.isSuccecd(gyBaseResp)){
                        if (null == orderErroPo){
                            orderErroPo = new OrderErrorPo();
                            orderErroPo.setOrderId(po.getCode());
                            orderErroPo.setThirdPartyId(po.getPlatform_code());
                            orderErroPo.setCreateTime(DateUtil.stringToDate(po.getCreate_date(), DateUtil.dateTimeFormat));
                        }
                        orderErroPo.setGyPrintExpressError("管易同步打单失败-"+gyDeliveryUpdateResp.getErrorDesc() + ". subError::" +gyDeliveryUpdateResp.getSubErrorDesc());
                    }
                    log.info("gyOrderSync round-item:{}-{} stage4 gy U syncStatus:{}...",round, i, GyBaseResp.isSuccecd(gyBaseResp));
                    //orderPo.setUpdateTime(new Date());
                    //orderPo.setGySyncStatus(GyBaseResp.isSuccecd(gyBaseResp) ? 1 : -1);
                    gySyncStatus = GyBaseResp.isSuccecd(gyBaseResp) ? 1 : -1;
                    // this.saveOrderPoTryCatch(orderPo); // loacal 3.保存订单-下单支付结果
                }
            }
            if(!orderInit){
                //非初始化订单只更新原始未初始化或失败的
                if(orderPo.getKlOrderConform() != 1){
                    orderPo.setKlOrderConform(klOrderConfirm);
                }
                if(orderPo.getKlVerifylevel() == 0){
                    orderPo.setKlOrderConform(klVerifyLevel);
                }
                if(orderPo.getKlOrderPay() != 1){
                    orderPo.setKlOrderPay(klorderPay);
                }
                if(orderPo.getGySyncStatus() != 1){
                    orderPo.setGySyncStatus(gySyncStatus);
                }
                if(orderPo.getKlOrderSize() == 0){
                    orderPo.setKlOrderSize(klOrderSize);
                }
                if(StringUtils.isEmpty(orderPo.getKlOrderId())){
                    orderPo.setKlOrderId(klOrderId);
                }
                if(orderPo.getKlAmount() == 0){
                    orderPo.setKlAmount(klAmount);
                }
                if(orderPo.getKlOrderStatus() < klOrderStatus){
                    orderPo.setKlOrderStatus(klOrderStatus);
                }
            }else {
                orderPo.setKlOrderConform(klOrderConfirm);
                orderPo.setKlOrderConform(klVerifyLevel);
                orderPo.setKlOrderPay(klorderPay);
                orderPo.setGySyncStatus(gySyncStatus);
                orderPo.setKlOrderSize(klOrderSize);
                orderPo.setKlOrderId(klOrderId);
                orderPo.setKlAmount(klAmount);
                orderPo.setKlOrderStatus(klOrderStatus);
            }
            orderPo.setUpdateTime(new Date());
            this.saveOrderPoTryCatch(orderPo); //最后统一保存，现在做法如果已成功的阶段就不更新；
            if (null != orderErroPo){
                orderErroPo.setUpdateTime(new Date());
                this.saveOrderErrorTryCatch(orderErroPo); //最后统一保存，现在做法如果已成功的阶段就不更新；
            }
            log.info("gyOrderSync round-item:{}-{} end...",round, i);
            i++;
        }
        log.info("gyOrderSync round:{}. end....",round);
    }

    private void gyklOrderExpressSyncByRound(Map<String, Object> map, int round, int count){
        // map.put("warehouse_code", warehouseCode); //须制定仓库
        // map.put("sync_status", "1"); // 1 同步成功
        // map.put("print", "0");
        map.put("page_no", String.valueOf(round));
        map.put("page_size", String.valueOf(Constant.page_size));
        try {
            // step 1.抽取管易发货单，已支付未发货（同步成功，未打印）
            GyDeliverysResp rs = gyApiService.getDeliverys(map);
            if(round == 1) count = rs.getTotal();
            log.info("gyklOrderExpressSync success:{} count:{} round:{} ...",GyBaseResp.isSuccecd(rs), count, round);
            if(count > 0){
                if(GyBaseResp.isSuccecd(rs) && !CollectionUtils.isEmpty(rs.getDeliverys())){
                    try {
                        this.gyklOrderExpressSyncHandler(rs.getDeliverys(), round);
                    }catch (Exception e){
                        log.info("gyklOrderExpressSync error round::{}. ",round, e);
                    }
                }
            }
            count -= Constant.page_size;
            if(count > 0){
                this.gyklOrderExpressSyncByRound(map,round+1, count);
            }
        }catch (Exception e){
            log.error("gyklOrderExpressSync error round::{}. ",round, e);
        }
    }
    @Override
    public void gyklOrderExpressSyncHandler(List<GyDeliverysPo> deliverys, int round){
        log.info("gyklOrderExpressSync round:{}. starting....",round);
        int i = 1;
        for (GyDeliverysPo po : deliverys) {
            log.info("gyklOrderExpressSync round-item:{}-{} starting...",round, i);

            // 正常订单，获取物流信息
            // step 2.考拉查询订单接口，通过查看是否已发货
            KlOrderStatusQueryResp klOrderStatusQueryResp = klApiService.queryOrderStatus(po.getCode());
            if(KlOrderStatusQueryResp.isSuccecd(klOrderStatusQueryResp) &&
                    !CollectionUtils.isEmpty(klOrderStatusQueryResp.getResult())){
                KlOrderStatusResult klOrderStatusResult = klOrderStatusQueryResp.getResult().get(0);
                if(!StringUtils.isEmpty(klOrderStatusResult.getDeliverName()) &&
                        !StringUtils.isEmpty(klOrderStatusResult.getDeliverNo())){
                    // 已发货
                    log.info("gyklOrderExpressSync round-item:{}-{} stage1 kl expressed:{}...",round, i, true);
                    OrderErrorPo orderErroPo = this.findOrderErroTryCatch(po.getCode());
                    OrderPo orderPo = this.findOrderPoTryCatch(po.getCode());

                    /*GyDeliverysResp gyDeliverysResp = gyOrderUtilService.getGyDeliverByCode(po.getCode());
                    if(!StringUtils.isEmpty(po.getExpress_no())){
                        // 避免重复调用管易接口，以管易返回为准
                    }*/
                    GyDeliveryUpdateResp gyDeliveryUpdateResp = gyOrderUtilService.updateDeliverysToExpress(po.getCode(), GuanYiUtil.deliveryCodeMapping(klOrderStatusResult.getDeliverName()), klOrderStatusResult.getDeliverNo());

                    if (null != orderPo){
                        orderPo.setKlDelivery(1);
                        orderPo.setUpdateTime(new Date());
                        orderPo.setKlOrderStatus(klOrderStatusResult.getStatus());

                    }
                    if(!GyBaseResp.isSuccecd(gyDeliveryUpdateResp)){
                        if (null != orderPo){
                            orderPo.setGyEpressStatus(1);
                            orderPo.setUpdateTime(new Date());
                        }
                        if(null == orderErroPo){
                            orderErroPo = new OrderErrorPo();
                            orderErroPo.setOrderId(po.getCode());
                            orderErroPo.setThirdPartyId(po.getPlatform_code());
                            orderErroPo.setCreateTime(DateUtil.stringToDate(po.getCreate_date(), DateUtil.dateTimeFormat));
                        }
                        orderErroPo.setGySyncExpressError("管易同步物流失败-"+gyDeliveryUpdateResp.getErrorDesc() + ". subError::" +gyDeliveryUpdateResp.getSubErrorDesc()
                                + ". code::" +po.getCode()+ ". companyName::" +klOrderStatusResult.getDeliverName()+ ". no::" +klOrderStatusResult.getDeliverNo());
                    } else {
                        if (null != orderPo && orderPo.getGyEpressStatus() != 1){
                            orderPo.setGyEpressStatus(-1);
                        }
                    }

                    if(null != orderPo){
                        this.saveOrderPoTryCatch(orderPo); // loacal 1.更新发货信息
                    }
                    if(null != orderErroPo){
                        orderErroPo.setUpdateTime(new Date());
                        this.saveOrderErrorTryCatch(orderErroPo); // loacal 1.更新发货信息
                    }
                    log.info("gyklOrderExpressSync round-item:{}-{} stage1 gy U print express:{}...",round, i, GyBaseResp.isSuccecd(gyDeliveryUpdateResp));
                }
                log.info("gyklOrderExpressSync round-item:{}-{} stage1 kl expressed:{}...",round, i, false);
            }
            log.info("gyklOrderExpressSync round-item:{}-{} end...",round, i);
            i++;
        }
        log.info("gyklOrderExpressSync round:{}. end....",round);
    }

    private void gyklOrderCancelByRound(Map<String, Object> map, int round, int count){
        // map.put("warehouse_code", warehouseCode); //须制定仓库
        // map.put("sync_status", "1"); // 1 同步成功
        // map.put("del", "1"); //0:是否同时返回已作废的单据 1:返回
        // map.put("print", "1"); // 1:已打单，说明此订单已在考拉下单成功
        //  map.put("end_create", ""); //0创建时间开始 于当前时间1天前，用于过滤未同步物流的发货单，但是仍有重复已作废单据
        map.put("page_no", String.valueOf(round));
        map.put("page_size", String.valueOf(Constant.page_size));
        try {
            // step 1.抽取管易发货单，已打印，过滤废弃发货单
            GyDeliverysResp rs = gyApiService.getDeliverys(map);
            if(round == 1) count = rs.getTotal();
            log.info("gyklOrderCancelSync success:{} count:{} round:{} ...",GyBaseResp.isSuccecd(rs), count, round);
            if(count > 0){
                if(GyBaseResp.isSuccecd(rs) && !CollectionUtils.isEmpty(rs.getDeliverys())){
                    try {
                        this.gyklOrderCancelSyncHandler(rs.getDeliverys(), round);
                    }catch (Exception e){
                        log.info("gyklOrderCancelSync error round::{}. ",round, e);
                    }
                }
            }
            count -= Constant.page_size;
            if(count > 0){
                this.gyklOrderCancelByRound(map,round+1, count);
            }
        }catch (Exception e){
            log.error("gyklOrderCancelSync error round::{}. ",round, e);
        }
    }
    @Override
    public void gyklOrderCancelSyncHandler(List<GyDeliverysPo> deliverys, int round){
        log.info("gyklOrderCancelSync round:{}. starting....",round);
        int i = 1;
        for (GyDeliverysPo po : deliverys) {
            log.info("gyklOrderCancelSync round-item:{}-{} starting...",round, i);
            if(po.getCancel() == 1){
                // 废弃发货单
                // step 2.废弃发货单 取消订单
                OrderErrorPo orderErroPo = this.findOrderErroTryCatch(po.getCode());

                KlBaseResp rs = klApiService.cancelOrder(po.getCode());
                log.info("gyklOrderCancelSync round-item:{}-{} stage1 kl canceled:{}...",round, i, KlBaseResp.isSuccecd(rs));
                OrderPo orderPo = this.findOrderPoTryCatch(po.getCode());
                if (null != orderPo) {
                    if (KlBaseResp.isSuccecd(rs)) {
                        orderPo.setKlCancelStatus(1);
                        orderPo.setKlOrderStatus(8);
                    } else {
                        orderPo.setKlCancelStatus(-1);
                        if(null == orderErroPo){
                            orderErroPo = new OrderErrorPo();
                            orderErroPo.setOrderId(po.getCode());
                            orderErroPo.setThirdPartyId(po.getPlatform_code());
                            orderErroPo.setCreateTime(DateUtil.stringToDate(po.getCreate_date(), DateUtil.dateTimeFormat));
                        }
                        orderErroPo.setKlCancelError("考拉取消打单失败-"+rs.getRecMeg()+" klRecCode:"+rs.getRecCode()+"--"+rs.getSubCode());
                    }
                }
                orderPo.setCancelTimes(orderPo.getCancelTimes() +1);
                orderPo.setUpdateTime(new Date());
                this.saveOrderPoTryCatch(orderPo);
                if(null != orderErroPo){
                    orderErroPo.setUpdateTime(new Date());
                    this.saveOrderErrorTryCatch(orderErroPo);
                }
            }
            log.info("gyklOrderCancelSync round-item:{}-{} end...",round, i);
            i++;
        }
        log.info("gyklOrderCancelSync round:{}. end....",round);
    }



    private void saveOrderPoTryCatch(OrderPo orderPo){
        try {
            orderPoDao.save(orderPo);
        }catch (Exception e){
            log.info("gyOrderSync order localSave error", e);
        }
    }

    private OrderPo findOrderPoTryCatch(String orderId){
        try {
            return orderPoDao.findOne(orderId);
        }catch (Exception e){
            log.info("gyOrderSync order localSave error", e);
        }
        return null;
    }

    private void saveOrderErrorTryCatch(OrderErrorPo orderErrorPo){
        try {
            orderErroDao.save(orderErrorPo);
        }catch (Exception e){
            log.info("gyOrderSync order localSave error", e);
        }
    }

    private OrderErrorPo findOrderErroTryCatch(String orderId){
        try {
            return orderErroDao.findOne(orderId);
        }catch (Exception e){
            log.info("gyOrderSync order localSave error", e);
        }
        return null;
    }









}
