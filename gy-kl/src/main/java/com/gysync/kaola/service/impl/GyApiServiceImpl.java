package com.gysync.kaola.service.impl;

import com.alibaba.fastjson.JSON;
import com.gysync.kaola.comm.ConfigInfo;
import com.gysync.kaola.comm.util.GuanYiUtil;
import com.gysync.kaola.comm.util.RestHttpUtil;
import com.gysync.kaola.entity.gy.resp.*;
import com.gysync.kaola.entity.kl.resp.GyupdateStockResp;
import com.gysync.kaola.service.GyApiService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.Map;
import java.util.UUID;

@Service
@Slf4j
public class GyApiServiceImpl implements GyApiService {


    @Autowired
    private RestHttpUtil restHttpUtil;

    @Override
    public GyDeliverysResp getDeliverys(Map<String, Object> map) {
        String t = UUID.randomUUID().toString();
        map.put("appkey", ConfigInfo.APPKEY);
        map.put("sessionkey", ConfigInfo.SESSIONKEY);
        map.put("method", "gy.erp.trade.deliverys.get");
        if(StringUtils.isEmpty(map.get("page_no"))){
            map.put("page_no", "1");
        }
        if(StringUtils.isEmpty(map.get("page_size"))){
            map.put("page_size", "10");
        }
        // map.put("outer_code", "1");
        // map.put("warehouse_code", "002");  //仓库代码
        // map.put("shop_code", "006");
        //map.put("code", "SDO99140182407"); // SDO1054847573
        // map.put("mail_no","1115001002705");
        // map.put("start_create", "2016-02-15 18:00:00");
        // map.put("end_create", "2016-09-28 15:18:11");
        // map.put("start_delivery_date", "2016-07-29 21:21:00");
        // map.put("end_delivery_date", "2016-07-29 21:22:00");
        // map.put("delivery", "0"); //0:未发货、发货中、发货失败 1:发货成功
        // map.put("wms", "1");  // //是否外仓单据 0 不是 1 是
        // map.put("del", 1);
        if(!StringUtils.isEmpty(map.get("sign"))){
            map.remove("sign");
        }
        String sign = GuanYiUtil.sign(JSON.toJSONString(map), ConfigInfo.SECRET);
        map.put("sign", sign);
        String rs = restHttpUtil.gyPost(JSON.toJSONString(map));
        return JSON.parseObject(rs, GyDeliverysResp.class);
    }

    @Override
    public GyDeliveryUpdateResp updateDelivery(Map<String, Object> map) {
        map.put("appkey", ConfigInfo.APPKEY);
        map.put("sessionkey", ConfigInfo.SESSIONKEY);
        map.put("method", "gy.erp.trade.deliverys.update");
        // map.put("express_code", "STO");
        // map.put("mail_no", "213141");
        // map.put("weight_qty", "109.09");
        /*map.put("code", "SDO63532968652"); //单据编号
        List<Map<String, Object>> deliverys_state_paramlist = new ArrayList<Map<String, Object>>();
        Map<String, Object> action = new LinkedHashMap<String, Object>();
        action.put("area_id", "3");
        action.put("operator", "systemkaola");
        action.put("operator_date", DateUtil.dateToString(new Date()));
        deliverys_state_paramlist.add(action);
        map.put("deliverys_state_paramlist", deliverys_state_paramlist);*/
        if(!StringUtils.isEmpty(map.get("sign"))){
            map.remove("sign");
        }
        String sign = GuanYiUtil.sign(JSON.toJSONString(map), ConfigInfo.SECRET);
        map.put("sign", sign);
        String rs = restHttpUtil.gyPost(JSON.toJSONString(map));
        return JSON.parseObject(rs, GyDeliveryUpdateResp.class);
    }

    @Override
    public GyBaseResp updateDeliveryStatus(Map<String, Object> map) {
        map.put("appkey", ConfigInfo.APPKEY);
        map.put("sessionkey", ConfigInfo.SESSIONKEY);
        map.put("method", "gy.erp.trade.deliverys.syncstatus.update");

        // map.put("status", "1");  // 数据同步状态 -1:同步失败 0：未同步 1：已同步
        // map.put("deliveryCodeList", "string[]");  // 发货单号列表
        // map.put("sync_memo", "");
        // map.put("operator", "mgw");
        // map.put("operate_date", "2016-05-09 11:11:11");
        if(!StringUtils.isEmpty(map.get("sign"))){
            map.remove("sign");
        }
        String sign = GuanYiUtil.sign(JSON.toJSONString(map), ConfigInfo.SECRET);
        map.put("sign", sign);
        String rs = restHttpUtil.gyPost(JSON.toJSONString(map));
        return JSON.parseObject(rs, GyBaseResp.class);
    }

    @Override
    public GyGoodsResp getGoods(Map<String, Object> map) {
        map.put("appkey", ConfigInfo.APPKEY);
        map.put("sessionkey", ConfigInfo.SESSIONKEY);
        map.put("method", "gy.erp.items.get");
        if(StringUtils.isEmpty(map.get("page_no"))){
            map.put("page_no", "1");
        }
        if(StringUtils.isEmpty(map.get("page_size"))){
            map.put("page_size", "10");
        }
        // map.put("start_date", "2016-07-18 09:00:00");
        // map.put("end_date", "2016-07-18 23:59:59");
        // map.put("code", "test31589211089");
        if(!StringUtils.isEmpty(map.get("sign"))){
            map.remove("sign");
        }
        String sign = GuanYiUtil.sign(JSON.toJSONString(map), ConfigInfo.SECRET);
        map.put("sign", sign);
        String rs = restHttpUtil.gyPost(JSON.toJSONString(map));
        return JSON.parseObject(rs, GyGoodsResp.class);
    }

    @Override
    public GyStockGetResp getStock(Map<String, Object> map) {
        map.put("appkey", ConfigInfo.APPKEY);
        map.put("sessionkey", ConfigInfo.SESSIONKEY);
        map.put("method", "gy.erp.new.stock.get");
        //map.put("warehouse_code", "1"); //须指定仓库
        if(StringUtils.isEmpty(map.get("page_no"))){
            map.put("page_no", "1");
        }
        if(StringUtils.isEmpty(map.get("page_size"))){
            map.put("page_size", "10");
        }
        // map.put("start_date", "2016-07-21 19:55:00");
        // map.put("end_date","2016-07-21 23:59:59");
        // map.put("barcode", "20171129005");
        // map.put("item_code", "L0012-100");
        // map.put("item_sku_code", "01030300123-500");
        map.put("cancel", 1); //0:不返回停用库存记录 1：返回停用的库存记录
        if(!StringUtils.isEmpty(map.get("sign"))){
            map.remove("sign");
        }
        String sign = GuanYiUtil.sign(JSON.toJSONString(map), ConfigInfo.SECRET);
        map.put("sign", sign);
        String rs = restHttpUtil.gyPost(JSON.toJSONString(map));
        return JSON.parseObject(rs, GyStockGetResp.class);
    }

    @Override
    public GyupdateStockResp updateStock(Map<String, Object> map) {
        map.put("appkey", ConfigInfo.APPKEY);
        map.put("sessionkey", ConfigInfo.SESSIONKEY);
        map.put("method", "gy.erp.stock.count.add");
        /*// map.put("type_code", "01"); // demo:111
        map.put("warehouse_code", "00006"); // v1:00007,demo:CK003;
        // map.put("note", "test inventory..");
        List<Map<String, Object>> details = new ArrayList<Map<String, Object>>();

        Map<String, Object> item = new LinkedHashMap<String, Object>();
        item.put("item_code", "2017080218001"); // demo:20170528002;
        item.put("qty", "24");
        // item.put("uniqueCode", "3512413141");
        item.put("batchNumber", "20170802191701");
        item.put("manufacturingDate", "2017-03-15 00:00:00");
        item.put("shelfLife", 0);
        item.put("stockDate", "2017-03-15 00:00:00");
        item.put("note", "test item...");
        details.add(item);

        item = new LinkedHashMap<String, Object>();
        item.put("item_code", "lxd20170052"); // demo:20170528002;
        item.put("qty", "50");
        // item.put("uniqueCode", "3512413141");
        // item.put("batchNumber", "liubing1234561");
        // item.put("manufacturingDate", "2016-06-20 10:15:00");
        // item.put("shelfLife", 11);
        // item.put("stockDate", "2016-08-12 10:15:00");
        // item.put("note", "test item...");
        details.add(item);

        item = new LinkedHashMap<String, Object>();
        item.put("item_code", "lxd20170052"); // demo:20170528002;
        item.put("qty", "35");
        // item.put("uniqueCode", "3512413141");
        // item.put("batchNumber", "liubing1234561");
        // item.put("manufacturingDate", "2016-06-20 10:15:00");
        // item.put("shelfLife", 11);
        // item.put("stockDate", "2016-08-12 10:15:00");
        // item.put("note", "test item...");
        details.add(item);

        // item = new LinkedHashMap<String, Object>();
        // item.put("item_code", "PC2222222222");
        // item.put("sku_code", "PC222222222202");
        // item.put("qty", "11");
        // item.put("batchNumber", "20160913151101");
        // item.put("manufacturingDate", "2015-12-11:00:00");
        // item.put("stockDate", "2015-12-11:00:00");
        // item.put("note", "test item...");
        // details.add(item);

        map.put("details", details);*/
        if(!StringUtils.isEmpty(map.get("sign"))){
            map.remove("sign");
        }
        String sign = GuanYiUtil.sign(JSON.toJSONString(map), ConfigInfo.SECRET);
        map.put("sign", sign);
        String rs = restHttpUtil.gyPost(JSON.toJSONString(map));
        return JSON.parseObject(rs, GyupdateStockResp.class);
    }


}
