package com.gysync.kaola.service;

import com.gysync.kaola.entity.gy.resp.GyBaseResp;
import com.gysync.kaola.entity.gy.resp.GyDeliveryUpdateResp;
import com.gysync.kaola.entity.gy.resp.GyDeliverysPo;
import com.gysync.kaola.entity.gy.resp.GyDeliverysResp;

import java.util.Map;

public interface GyOrderUtilService {

    public GyDeliverysResp getGyDeliverByCode(String deliveryCode);
    public GyDeliverysResp getDeliverys(Map<String, Object> map);

    /**
     * 管易发货单状态修改为转入外仓
     * @param deliveryCode
     * @return
     */
    GyDeliveryUpdateResp updateDeliverysToOtherWareHouse(String deliveryCode);

    /**
     * 管易发货单状态修改为已打印（考拉返回物流信息）
     * @param deliveryCode
     * @return
     */
    GyDeliveryUpdateResp updateDeliverysToExpress(String deliveryCode, String deliverName, String deliverNo);

    /**
     * 管易发货单同步状态修改
     * @param deliveryCode
     * @param status
     * @return
     */
    GyBaseResp updateDeliveryStatus(String deliveryCode, int status);


    /**
     * 将管易sku的价格映射成考拉价格, 确保订单confirm成功
     * @param po
     */
    boolean changeChannelPriceToKl(GyDeliverysPo po);

}
