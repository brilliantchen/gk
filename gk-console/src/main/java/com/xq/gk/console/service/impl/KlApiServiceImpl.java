package com.xq.gk.console.service.impl;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.xq.gk.console.comm.ConfigInfo;
import com.xq.gk.console.comm.util.APIUtil;
import com.xq.gk.console.comm.util.RestHttpUtil;
import com.xq.gk.console.entity.gy.resp.GyDeliverysDetail;
import com.xq.gk.console.entity.gy.resp.GyDeliverysPo;
import com.xq.gk.console.entity.kl.resp.*;
import com.xq.gk.console.service.KlApiService;
import lombok.extern.slf4j.Slf4j;
import org.apache.http.NameValuePair;
import org.apache.http.message.BasicNameValuePair;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.*;

@Service
@Slf4j
public class KlApiServiceImpl implements KlApiService {

    @Autowired
    private RestHttpUtil restHttpUtil;

    String v1 = ConfigInfo.ka_v1;
    // 渠道商ID
    String source = ConfigInfo.ka_source;
    String sign_method = ConfigInfo.ka_sign_method;
    String appKey = ConfigInfo.ka_appKey;
    String appSecret = ConfigInfo.ka_appSecret;

    @Override
    public String queryAllGoodsId() {
        long time = System.currentTimeMillis();
        TreeMap<String, String> parameterMap = new TreeMap<String, String>();
        parameterMap.put("timestamp", new Timestamp(time).toString());
        parameterMap.put("v", v1);
        parameterMap.put("sign_method", sign_method);
        parameterMap.put("app_key", appKey);
        parameterMap.put("channelId", source);

        String sign = APIUtil.createSign(appSecret, parameterMap);
        List<NameValuePair> params = new ArrayList<NameValuePair>();
        params.add(new BasicNameValuePair("timestamp", new Timestamp(time).toString()));
        params.add(new BasicNameValuePair("v", v1));
        params.add(new BasicNameValuePair("sign_method", sign_method));
        params.add(new BasicNameValuePair("app_key", appKey));
        params.add(new BasicNameValuePair("sign", sign));
        params.add(new BasicNameValuePair("channelId", source));
        String result = restHttpUtil.klPost(ConfigInfo.ka_url+"/queryAllGoodsId", params);
        return result;
    }

    @Override
    public KlOrderConfirmResp orderConfirm(GyDeliverysPo gyDeliverysPo) {
        try {
            KlOrderConfirmResp localValidate =  GyDeliverysPo.isValidated(gyDeliverysPo);
            if (!KlBaseResp.isSuccecd(localValidate)) {
                log.error("order validate error. {}", gyDeliverysPo.getCode());
                return localValidate;
            }
            long time = System.currentTimeMillis();
            // 第三方账号（测试环境请使用@163.com结尾的账户，正式环境不受限）
            String accountId = gyDeliverysPo.getVip_code();
            String[] areas = gyDeliverysPo.getArea_name().split("-");

            TreeMap<String, String> parameterMap = new TreeMap<String, String>();
            parameterMap.put("timestamp", new Timestamp(time).toString());
            parameterMap.put("v", v1);
            parameterMap.put("sign_method", sign_method);
            parameterMap.put("app_key", appKey);
            parameterMap.put("source", source);

            List<Map<String, Object>> orderItemList = new ArrayList<Map<String, Object>>();
            // 构造商品信息
            Map<String, Object> orderItemMap = new HashMap<String, Object>();
            for (GyDeliverysDetail po : gyDeliverysPo.getDetails()) {
                orderItemMap.put("goodsId", po.getItem_code());
                orderItemMap.put("skuId", po.getSku_code());
                orderItemMap.put("buyAmount", po.getQty());
                orderItemMap.put("channelSalePrice", new BigDecimal(po.getAmount()));
                orderItemList.add(orderItemMap);
            }
            JSONObject orderItemJsonObject = new JSONObject();
            orderItemJsonObject.put("orderItemList", orderItemList);
            parameterMap.put("orderItemList", orderItemJsonObject.toString());
            // 构造用户信息
            Map<String, Object> userInfoMap = new HashMap<String, Object>();
            userInfoMap.put("accountId", accountId);
            userInfoMap.put("name", gyDeliverysPo.getReceiver_name());
            userInfoMap.put("mobile", gyDeliverysPo.getReceiver_mobile());
            userInfoMap.put("email", "");
            userInfoMap.put("provinceName", areas[0]);
            userInfoMap.put("cityName", areas[1]);
            userInfoMap.put("districtName", areas[2]);
            userInfoMap.put("address", gyDeliverysPo.getReceiver_address());
            userInfoMap.put("identityId", gyDeliverysPo.getVip_id_card()); //一般贸易商品可不传
            JSONObject userInfoJsonObject = new JSONObject();
            userInfoJsonObject.put("userInfo", userInfoMap);
            parameterMap.put("userInfo", userInfoJsonObject.toString());

            String sign = APIUtil.createSign(appSecret, parameterMap);
            List<NameValuePair> params = new ArrayList<NameValuePair>();
            params.add(new BasicNameValuePair("timestamp", new Timestamp(time).toString()));
            params.add(new BasicNameValuePair("v", v1));
            params.add(new BasicNameValuePair("sign_method", sign_method));
            params.add(new BasicNameValuePair("app_key", appKey));
            params.add(new BasicNameValuePair("sign", sign));
            params.add(new BasicNameValuePair("source", source));
            params.add(new BasicNameValuePair("orderItemList", orderItemJsonObject.toString()));
            params.add(new BasicNameValuePair("userInfo", userInfoJsonObject.toString()));
            String result = restHttpUtil.klPost(ConfigInfo.ka_url+"/orderConfirm", params);
            return JSON.parseObject(result, KlOrderConfirmResp.class);
        } catch (Exception e) {
            log.error("orderConfirm error {}.", JSON.toJSONString(gyDeliverysPo), e);
            return null;
        }
    }

    @Override
    public KlOrderPayResp bookpayorder(GyDeliverysPo gyDeliverysPo, KlOrderConfirmPkg pkg) {
        try {
            long time = System.currentTimeMillis();
            // 第三方账号（测试环境请使用@163.com结尾的账户，正式环境不受限）
            String accountId = gyDeliverysPo.getVip_code();
            String[] areas = gyDeliverysPo.getArea_name().split("-");

            TreeMap<String, String> parameterMap = new TreeMap<String, String>();
            parameterMap.put("timestamp", new Timestamp(time).toString());
            parameterMap.put("v", v1);
            parameterMap.put("sign_method", sign_method);
            parameterMap.put("app_key", appKey);
            parameterMap.put("source", source);

            List<Map<String, Object>> orderItemList = new ArrayList<Map<String, Object>>();
            // 构造商品信息
            Map<String, Object> orderItemMap = new HashMap<String, Object>();
            for (KlOrderGoods goods : pkg.getGoodsList()) {
                orderItemMap.put("goodsId", goods.getGoodsId());
                orderItemMap.put("skuId", goods.getSkuId());
                orderItemMap.put("buyAmount", goods.getGoodsBuyNumber());
                orderItemMap.put("channelSalePrice", new BigDecimal(goods.getGoodsPayAmount()));
                // 下单
                orderItemMap.put("warehouseId", goods.getWarehouseId());
                orderItemList.add(orderItemMap);
            }
            JSONObject orderItemJsonObject = new JSONObject();
            orderItemJsonObject.put("orderItemList", orderItemList);
            parameterMap.put("orderItemList", orderItemJsonObject.toString());
            // 构造用户信息
            Map<String, Object> userInfoMap = new HashMap<String, Object>();
            userInfoMap.put("accountId", accountId);
            userInfoMap.put("name", gyDeliverysPo.getReceiver_name());
            userInfoMap.put("mobile", gyDeliverysPo.getReceiver_mobile());
            userInfoMap.put("email", "");
            userInfoMap.put("provinceName", areas[0]);
            userInfoMap.put("cityName", areas[1]);
            userInfoMap.put("districtName", areas[2]);
            userInfoMap.put("address", gyDeliverysPo.getReceiver_address());
            userInfoMap.put("identityId", gyDeliverysPo.getVip_id_card()); //一般贸易商品可不传
            parameterMap.put("thirdPartOrderId", gyDeliverysPo.getCode()); //  使用管易发货单号code
            JSONObject userInfoJsonObject = new JSONObject();
            userInfoJsonObject.put("userInfo", userInfoMap);
            parameterMap.put("userInfo", userInfoJsonObject.toString());

            String sign = APIUtil.createSign(appSecret, parameterMap);
            List<NameValuePair> params = new ArrayList<NameValuePair>();
            params.add(new BasicNameValuePair("timestamp", new Timestamp(time).toString()));
            params.add(new BasicNameValuePair("v", v1));
            params.add(new BasicNameValuePair("sign_method", sign_method));
            params.add(new BasicNameValuePair("app_key", appKey));
            params.add(new BasicNameValuePair("sign", sign));
            params.add(new BasicNameValuePair("source", source));
            params.add(new BasicNameValuePair("orderItemList", orderItemJsonObject.toString()));
            params.add(new BasicNameValuePair("userInfo", userInfoJsonObject.toString()));
            // 下单
            params.add(new BasicNameValuePair("thirdPartOrderId", gyDeliverysPo.getCode()));
            String result = restHttpUtil.klPost(ConfigInfo.ka_url+"/bookpayorder", params);
            return JSON.parseObject(result, KlOrderPayResp.class);
        } catch (Exception e) {
            log.error("bookpayorder error {}, {}.", JSON.toJSONString(gyDeliverysPo), JSON.toJSONString(pkg), e);
        }
        return null;
    }

    @Override
    public KlOrderStatusQueryResp queryOrderStatus(String thirdPartOrderId) {
        try {
            long time = System.currentTimeMillis();
            TreeMap<String, String> parameterMap = new TreeMap<String, String>();
            parameterMap.put("thirdPartOrderId", thirdPartOrderId);
            parameterMap.put("channelId", source);
            parameterMap.put("timestamp", new Timestamp(time).toString());
            parameterMap.put("v", v1);
            parameterMap.put("sign_method", sign_method);
            parameterMap.put("app_key", appKey);

            String sign = APIUtil.createSign(appSecret, parameterMap);

            List<NameValuePair> params = new ArrayList<NameValuePair>();
            params.add(new BasicNameValuePair("thirdPartOrderId", thirdPartOrderId));
            params.add(new BasicNameValuePair("timestamp", new Timestamp(time).toString()));
            params.add(new BasicNameValuePair("v", v1));
            params.add(new BasicNameValuePair("sign_method", sign_method));
            params.add(new BasicNameValuePair("app_key", appKey));
            params.add(new BasicNameValuePair("sign", sign));
            params.add(new BasicNameValuePair("channelId", source));
            String result = restHttpUtil.klPost(ConfigInfo.ka_url+"/queryOrderStatus", params);
            return JSON.parseObject(result, KlOrderStatusQueryResp.class);
        } catch (Exception e) {
            log.error("queryOrderStatus error {}, {}.", thirdPartOrderId, e);
        }
        return null;
    }

    @Override
    public KlBaseResp cancelOrder(String thirdPartOrderId) {
        try {
            long time = System.currentTimeMillis();
            TreeMap<String, String> parameterMap = new TreeMap<String, String>();
            parameterMap.put("thirdpartOrderId", thirdPartOrderId);
            parameterMap.put("reasonId", "6");// 1 收货人信息有误 2 商品数量或款式需调整 3 有更优惠的购买方案 4 考拉一直未发货 5 商品缺货 6 我不想买了 7 其他原因
            parameterMap.put("remark", "");
            parameterMap.put("channelId", source);
            parameterMap.put("timestamp", new Timestamp(time).toString());
            parameterMap.put("v", v1);
            parameterMap.put("sign_method", sign_method);
            parameterMap.put("app_key", appKey);

            String sign = APIUtil.createSign(appSecret, parameterMap);

            List<NameValuePair> params = new ArrayList<NameValuePair>();
            params.add(new BasicNameValuePair("thirdpartOrderId", thirdPartOrderId));
            params.add(new BasicNameValuePair("timestamp", new Timestamp(time).toString()));
            params.add(new BasicNameValuePair("reasonId", "6"));
            params.add(new BasicNameValuePair("remark", ""));
            params.add(new BasicNameValuePair("v", v1));
            params.add(new BasicNameValuePair("sign_method", sign_method));
            params.add(new BasicNameValuePair("app_key", appKey));
            params.add(new BasicNameValuePair("sign", sign));
            params.add(new BasicNameValuePair("channelId", source));
            String result = restHttpUtil.klPost(ConfigInfo.ka_url+"/cancelOrder", params);
            return JSON.parseObject(result, KlBaseResp.class);
        } catch (Exception e) {
            log.error("queryOrderStatus error {}", thirdPartOrderId, e);
        }
        return null;
    }

    @Override
    public KlGoodsResp queryGoodsInfoById(String skuId) {
        try {
            long time = System.currentTimeMillis();
            String queryType = "1";//0表示返回全部信息、1表示只返回关键信息如：商品id、价格和库存

            TreeMap<String, String> parameterMap = new TreeMap<String, String>();
            parameterMap.put("timestamp", new Timestamp(time).toString());
            parameterMap.put("v", v1);
            parameterMap.put("sign_method", sign_method);
            parameterMap.put("app_key", appKey);
            parameterMap.put("channelId", source);
            parameterMap.put("queryType", queryType);
            parameterMap.put("skuId", skuId);

            String sign = APIUtil.createSign(appSecret, parameterMap);
            List<NameValuePair> params = new ArrayList<NameValuePair>();

            params.add(new BasicNameValuePair("timestamp", new Timestamp(time).toString()));
            params.add(new BasicNameValuePair("v", v1));
            params.add(new BasicNameValuePair("sign_method", sign_method));
            params.add(new BasicNameValuePair("app_key", appKey));
            params.add(new BasicNameValuePair("sign", sign));
            params.add(new BasicNameValuePair("channelId", source));
            params.add(new BasicNameValuePair("queryType", queryType));
            params.add(new BasicNameValuePair("skuId", skuId));
            String result = restHttpUtil.klPost(ConfigInfo.ka_url+"/queryGoodsInfoById", params);
            return JSON.parseObject(result, KlGoodsResp.class);
        } catch (Exception e) {
            log.error("queryGoodsInfoById error {}, {}.", skuId, e);
        }
        return null;
    }

    @Override
    public List<KlGoodsResp> queryGoodsInfoByIds(JSONArray skuIds) {
        try {
            long time = System.currentTimeMillis();
            String queryType = "1";//0表示返回全部信息、1表示只返回关键信息如：商品id、价格和库存

            TreeMap<String, String> parameterMap = new TreeMap<String, String>();
            parameterMap.put("timestamp", new Timestamp(time).toString());
            parameterMap.put("v", v1);
            parameterMap.put("sign_method", sign_method);
            parameterMap.put("app_key", appKey);
            parameterMap.put("channelId", source);
            parameterMap.put("queryType", queryType);
            //JSONArray skuIds= new JSONArray();
            //skuIds.add("xxxxxxx-xxxxxxxxxxx");
            parameterMap.put("skuIds", skuIds.toString());

            String sign = APIUtil.createSign(appSecret, parameterMap);
            List<NameValuePair> params = new ArrayList<NameValuePair>();

            params.add(new BasicNameValuePair("timestamp", new Timestamp(time).toString()));
            params.add(new BasicNameValuePair("v", v1));
            params.add(new BasicNameValuePair("sign_method", sign_method));
            params.add(new BasicNameValuePair("app_key", appKey));
            params.add(new BasicNameValuePair("sign", sign));
            params.add(new BasicNameValuePair("channelId", source));
            params.add(new BasicNameValuePair("queryType", queryType));
            params.add(new BasicNameValuePair("skuIds", skuIds.toString()));
            String result = restHttpUtil.klPost(ConfigInfo.ka_url+"/queryGoodsInfoByIds", params);
            return JSONArray.parseArray(result, KlGoodsResp.class);
        } catch (Exception e) {
            log.error("queryGoodsInfoById error {}, {}.", JSON.toJSONString(skuIds), e);
        }
        return null;
    }


}
