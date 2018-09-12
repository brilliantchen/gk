package com.gysync.kaola.service.impl;


import com.gysync.kaola.comm.ConfigInfo;
import com.gysync.kaola.comm.Constant;
import com.gysync.kaola.comm.util.DateUtil;
import com.gysync.kaola.entity.gy.resp.*;
import com.gysync.kaola.entity.kl.resp.KlBaseResp;
import com.gysync.kaola.entity.kl.resp.KlGoodsResp;
import com.gysync.kaola.service.GyApiService;
import com.gysync.kaola.service.GyOrderUtilService;
import com.gysync.kaola.service.KlApiService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.math.BigDecimal;
import java.util.*;

@Service
public class GyOrderUtilServiceImpl implements GyOrderUtilService {

    @Autowired
    private GyApiService gyApiService;
    @Autowired
    private KlApiService klApiService;

    /**
     * 通过发货单号查询发货单详情
     * @return
     */
    @Override
    public GyDeliverysResp getGyDeliverByCode(String deliveryCode){
        try {
            if(StringUtils.isEmpty(deliveryCode)){
                return  null;
            }
            Map<String, Object> map = new HashMap<String, Object>();
            map.put("code", deliveryCode);
            return gyApiService.getDeliverys(map);
        }catch (Exception e){
            return new GyDeliverysResp();
        }
    }

    /**
     * 发货单查询（gy.erp.trade.deliverys.get）
     * @return
     */
    @Override
    public GyDeliverysResp getDeliverys(Map<String, Object> map){
        try {
            return gyApiService.getDeliverys(map);
        }catch (Exception e){
            return new GyDeliverysResp();
        }
    }

    /**
     * 管易发货单状态修改为转入外仓
     * @param deliveryCode
     * @return
     */
    @Override
    public GyDeliveryUpdateResp updateDeliverysToOtherWareHouse(String deliveryCode){
        try {
            Map<String, Object> map = new HashMap<String, Object>();
            map.put("code", deliveryCode); //单据编号
            List<Map<String, Object>> deliverys_state_paramlist = new ArrayList<Map<String, Object>>();
            Map<String, Object> action = new LinkedHashMap<String, Object>();
            action.put("area_id", "3");
            action.put("operator", ConfigInfo.operater);
            action.put("operator_date", DateUtil.dateToString(new Date()));
            action.put("note", Constant.NOTE_GY_HOUSE_CHANGED_S);
            deliverys_state_paramlist.add(action);
            map.put("deliverys_state_paramlist", deliverys_state_paramlist);
            return gyApiService.updateDelivery(map);
        }catch (Exception e){
            return new GyDeliveryUpdateResp();
        }
    }

    /**
     * 管易发货单状态修改为已打印（考拉返回物流信息）
     * @param deliveryCode
     * @return
     */
    @Override
    public GyDeliveryUpdateResp updateDeliverysToExpress(String deliveryCode, String companyCode, String no){
        try {
            Map<String, Object> map = new HashMap<String, Object>();
            map.put("code", deliveryCode); //发货单号
            map.put("express_code", companyCode); //物流公司代码
            map.put("mail_no", no); //运单号
            List<Map<String, Object>> deliverys_state_paramlist = new ArrayList<Map<String, Object>>();
            Map<String, Object> action = new LinkedHashMap<String, Object>();
            action.put("area_id", "0");
            action.put("operator", ConfigInfo.operater);
            action.put("operator_date", DateUtil.dateToString(new Date()));
            action.put("note", Constant.NOTE_GY_HOUSE_CHANGED);
            deliverys_state_paramlist.add(action);
            map.put("deliverys_state_paramlist", deliverys_state_paramlist);
            return gyApiService.updateDelivery(map);
        }catch (Exception e){
            return new GyDeliveryUpdateResp();
        }
    }

    /**
     * 管易发货单同步状态修改
     * @param deliveryCode
     * @param status
     * @return
     */
    @Override
    public GyBaseResp updateDeliveryStatus(String deliveryCode, int status){
        try {
            Map<String, Object> map = new HashMap<String, Object>();
            List<String> deliveryCodeList = new ArrayList<String>();
            deliveryCodeList.add(deliveryCode);  //单据编号
            map.put("status", String.valueOf(status));
            map.put("deliveryCodeList", deliveryCodeList);  // 发货单号列表
            map.put("operator", ConfigInfo.operater);
            if(status == 1){
                map.put("sync_memo", Constant.NOTE_GY_SYNC_S);
            }
            if(status == -1){
                map.put("sync_memo", Constant.NOTE_GY_SYNC_F);
            }
            return gyApiService.updateDeliveryStatus(map);
        }catch (Exception e){
            return new GyBaseResp();
        }
    }

    @Override
    public boolean changeChannelPriceToKl(GyDeliverysPo gyDeliverysPo){
        try {
            for (GyDeliverysDetail po : gyDeliverysPo.getDetails()) {
                KlGoodsResp rs = klApiService.queryGoodsInfoById(po.getSku_code());
                if(KlBaseResp.isSuccecd(rs)){
                    po.setAmount(rs.getGoodsInfo().getPrice());
                }
            }
            return true;
        }catch (Exception e){
            return false;
        }
    }


}
