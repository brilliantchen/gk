package com.xq.gk.console.service;

import com.alibaba.fastjson.JSONArray;
import com.xq.gk.console.entity.gy.resp.GyDeliverysPo;
import com.xq.gk.console.entity.kl.resp.*;

import java.util.List;

public interface KlApiService {

    public String queryAllGoodsId();

    /**
     * 订单确认（分销2.0）
     * @param gyDeliverysPo
     */
    public KlOrderConfirmResp orderConfirm(GyDeliverysPo gyDeliverysPo);

    /**
     * 渠道订单代下代支付
     * @param gyDeliverysPo
     */
    public KlOrderPayResp bookpayorder(GyDeliverysPo gyDeliverysPo, KlOrderConfirmPkg pkg);

    /**
     * 渠道订单状态查询
     * @param thirdPartOrderId 分销商订单ID
     * @return
     */
    public KlOrderStatusQueryResp queryOrderStatus(String thirdPartOrderId);

    /**
     * 订单支付过后取消订单
     * @param thirdPartOrderId
     * @return
     */
    public KlBaseResp cancelOrder(String thirdPartOrderId);


    /**
     * 渠道下单个商品信息详情查询
     * @param skuId
     * @return
     */
    public KlGoodsResp queryGoodsInfoById(String skuId);
    public List<KlGoodsResp> queryGoodsInfoByIds(JSONArray skuIds);

}
