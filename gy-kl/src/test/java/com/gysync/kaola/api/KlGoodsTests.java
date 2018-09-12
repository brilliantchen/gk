package com.gysync.kaola.api;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.gysync.kaola.BaseTests;
import com.gysync.kaola.comm.util.APIUtil;
import com.gysync.kaola.entity.kl.resp.*;
import com.gysync.kaola.service.KlApiService;
import lombok.extern.slf4j.Slf4j;
import org.apache.http.HttpEntity;
import org.apache.http.NameValuePair;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.config.RequestConfig;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.sql.Timestamp;
import java.util.*;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@Slf4j
public class KlGoodsTests extends BaseTests {

  @Autowired
  private KlApiService klApiService;

  /**
   * 渠道下单个商品信息详情查询
   * @return
   */
  @Test
  public void queryAllGoodsId(){
    String rs = klApiService.queryAllGoodsId();
    System.out.println(rs);
  }

  /**
   * 渠道下单个商品信息详情查询
   * @return
   */
  @Test
  public void queryGoodsInfoById(){
    // {"goodsInfo":{"goodsId":49255695,"recommandStore":{"warehouseName":"下沙保税仓库","warehouseId":2,"warehouseStore":945},"isPresell":1,"marketPrice":300,"price":200.00,"store":945,"suggestPrice":200,"warehouseStores":{"下沙保税仓库":{"warehouseName":"下沙保税仓库","warehouseId":2,"warehouseStore":945}},"isFreeShipping":0,"onlineStatus":1,"memberCount":0,"isFreeTax":0,"productId":49255695},"recCode":200,"recMsg":"同步成功"}
    String skuId = "155451-68a3e5516d7a7dc21fbe0e7ee13bfc1c";
    KlGoodsResp rs = klApiService.queryGoodsInfoById(skuId);
    System.out.println(rs.toString());
  }

  @Test
  public void queryGoodsInfoByIds(){
    // [{"goodsInfo":{"goodsId":49255695,"recommandStore":{"warehouseName":"下沙保税仓库","warehouseId":2,"warehouseStore":945},"isPresell":1,"marketPrice":300,"price":200.00,"store":945,"suggestPrice":200,"warehouseStores":{"下沙保税仓库":{"warehouseName":"下沙保税仓库","warehouseId":2,"warehouseStore":945}},"skuId":"49255695-ecc4090b639c47f89b453980923afb8e","isFreeShipping":0,"onlineStatus":1,"memberCount":0,"isFreeTax":0,"productId":49255695},"recCode":200,"recMsg":"同步成功"},{"goodsInfo":{"goodsId":22286339,"recommandStore":{"warehouseName":"下沙保税仓库","warehouseId":2,"warehouseStore":2509958},"isPresell":0,"marketPrice":45,"price":46.00,"store":2509958,"suggestPrice":45,"warehouseStores":{"下沙保税仓库":{"warehouseName":"下沙保税仓库","warehouseId":2,"warehouseStore":2509958}},"skuId":"22286339-ecc4090b639c47f89b453980923afb8e","isFreeShipping":0,"onlineStatus":1,"memberCount":0,"isFreeTax":0,"productId":22286339},"recCode":200,"recMsg":"同步成功"}]
    JSONArray skuIds= new JSONArray();
    skuIds.add("49255695-ecc4090b639c47f89b453980923afb8e");
    skuIds.add("22286339-ecc4090b639c47f89b453980923afb8e");
    List<KlGoodsResp> list = klApiService.queryGoodsInfoByIds(skuIds);
    System.out.println(JSON.toJSONString(list));
  }






  String v = "1.0";
  String source = "1200";
  String sign_method = "md5";
  String appKey = "bb0b3ad64c9e5eb06c2fb6f163bf179e79051bd5c9b652fc45dc68a2b5dd23c7";
  String appSecret = "4ed8b056c32939b9fd66987470b3e9fb720bcsqd02197e678e516bdcdf810833";

  @Test
  public void aaa(){
    String url = "http://test1.thirdpart.kaolatest.netease.com/api/queryAllGoodsId";
    HttpPost httpRequst = new HttpPost(url);// 创建HttpPost对象
    long time = System.currentTimeMillis();

    TreeMap<String, String> parameterMap = new TreeMap<String, String>();
    parameterMap.put("timestamp", new Timestamp(time).toString());
    parameterMap.put("v", v);
    parameterMap.put("sign_method", sign_method);
    parameterMap.put("app_key", appKey);
    parameterMap.put("channelId", source);

    String sign = APIUtil.createSign(appSecret, parameterMap);
    List<NameValuePair> params = new ArrayList<NameValuePair>();
    params.add(new BasicNameValuePair("timestamp", new Timestamp(time).toString()));
    params.add(new BasicNameValuePair("v", v));
    params.add(new BasicNameValuePair("sign_method", sign_method));
    params.add(new BasicNameValuePair("app_key", appKey));
    params.add(new BasicNameValuePair("sign", sign));
    params.add(new BasicNameValuePair("channelId", source));
    System.out.println(JSON.toJSONString(params));
    try {
      httpRequst.setEntity(new UrlEncodedFormEntity(params, "UTF-8"));
      RequestConfig requestConfig = RequestConfig.custom().setSocketTimeout(10 * 1000).setConnectTimeout(5 * 1000).build();//设置请求和传输超时时间
      httpRequst.setConfig(requestConfig);
      CloseableHttpClient httpclient = HttpClients.createDefault();
      CloseableHttpResponse httpResponse = httpclient.execute(httpRequst);
      System.out.println(httpResponse.getStatusLine().getStatusCode());
      HttpEntity httpEntity = httpResponse.getEntity();
      String result = EntityUtils.toString(httpEntity);// 取出应答字符串
      log.info("[Thirdpart ThirdpartQueryAllGoodsIdTest][result] " + result);
      System.out.println("[Thirdpart ThirdpartQueryAllGoodsIdTest][result] " + result);

    } catch (UnsupportedEncodingException e) {
      log.error("[Thirdpart Order][result] ", e);
    } catch (ClientProtocolException e) {
      log.error("[[Thirdpart Order][result] ", e);
    } catch (IOException e) {
      log.error("[[Thirdpart Order][result] ", e);
    } catch (Exception e) {
      log.error("[[Thirdpart Order][result] ", e);
    }
    System.out.println("end...");

  }



}
