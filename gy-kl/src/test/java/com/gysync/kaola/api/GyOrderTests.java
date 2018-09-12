package com.gysync.kaola.api;

import com.alibaba.fastjson.JSON;
import com.gysync.kaola.BaseTests;
import com.gysync.kaola.comm.ConfigInfo;
import com.gysync.kaola.comm.util.DateUtil;
import com.gysync.kaola.entity.gy.resp.GyBaseResp;
import com.gysync.kaola.entity.gy.resp.GyDeliveryUpdateResp;
import com.gysync.kaola.entity.gy.resp.GyDeliverysResp;
import com.gysync.kaola.entity.kl.resp.*;
import com.gysync.kaola.service.GyApiService;
import com.gysync.kaola.service.GyOrderUtilService;
import lombok.extern.slf4j.Slf4j;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.util.CollectionUtils;
import org.springframework.util.StringUtils;

import java.util.*;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@Slf4j
public class GyOrderTests extends BaseTests {

  @Autowired
  private GyApiService gyApiService;

  @Test
  public void hello() throws Exception{
    System.out.println("11111111111");
  }

  /**
   * 发货单查询（gy.erp.trade.deliverys.get）
   * @return
   */
  @Test
  public void getDeliverys(){
    Map<String, Object> map = new HashMap<String, Object>();
    //map.put("wms", "0"); //是否外仓单据 0 不是 1 是
    /*map.put("sync_status", "0"); //0:未同步
    map.put("del", "1"); //0:是否同时返回已作废的单据 0:不返回（默认
    map.put("warehouse_code", "kaola");
    map.put("page_no", "1"); //
    map.put("page_size", "10"); //*/
    //map.put("warehouse_code", "DS001");  //仓库代码 total 3
    // map.put("warehouse_code", "bfc0001");  //仓库代码 total 1
    //map.put("warehouse_code", "GZ001");  //仓库代码 total 3
    //map.put("warehouse_code", "252");  //仓库代码 total 1
    map.put("code", ""); // SDO1054847573
    GyDeliverysResp rs = gyApiService.getDeliverys(map);
    // {"success":true,"errorCode":"","subErrorCode":"","errorDesc":"","subErrorDesc":"","requestMethod":"gy.erp.trade.deliverys.get","deliverys":[{"create_date":"2018-08-22 18:06:45","modify_date":"2018-08-23 09:56:12","code":"SDO85409491418","qty":1.0,"amount":299.0,"payment":299.0,"pay_time":"2018-08-22 17:39:04","cod":false,"refund":0,"invoiceDate":null,"bigchar":null,"cancel":0,"platform_code":"389047406","unpaid_amount":0.0,"post_fee":0.0,"cod_fee":0.0,"discount_fee":0.0,"post_cost":0.0,"plan_delivery_date":null,"buyer_memo":null,"seller_memo":null,"receiver_name":"赵贤哲","receiver_phone":null,"receiver_mobile":"15599012815","receiver_zip":null,"receiver_address":"独墅湖高教区生物纳米科技园A1北座4楼L04室","create_name":"南京泛瑞工贸有限责任公司","express_no":"5852222222","vip_name":"123672916","shop_name":"禾诺客","area_name":"江苏省-苏州市-工业园区","warehouse_name":"天马仓","express_code":"YTO","express_name":"圆通速递","tag_name":null,"seller_memo_late":null,"shelf_no":null,"details":[{"qty":1.0,"price":299.0,"amount":299.0,"refund":0,"memo":null,"picUrl":null,"trade_code":"SO85408495937","origin_price":299.0,"item_id":"85405579438","item_sku_id":"85405577875","item_code":"B74494","item_name":"adidas 阿迪达斯 neo 男子 COURT 板鞋 B74494","sku_code":"B74494|41","sku_name":"41","sku_note":"","platform_code":"389047406","discount_fee":0.0,"amount_after":299.0,"post_fee":0.0,"post_cost":0.0,"tax_rate":0.0,"tax_amount":0.0,"order_type":"Sales","platform_flag":0,"detail_unique":null,"detail_batch":null,"is_gift":0,"businessman_name":null,"item_add_attribute":0}],"delivery_statusInfo":{"scan":false,"weight":false,"wms":1,"delivery":0,"cancel":false,"intercept":false,"print_express":true,"express_print_name":"tianma","express_print_date":"2018-08-23 09:55:35","print_delivery":false,"delivery_print_name":null,"delivery_print_date":null,"scan_name":null,"scan_date":null,"weight_name":null,"weight_date":null,"wms_order":12,"delivery_name":null,"delivery_date":null,"cancel_name":null,"cancel_date":null,"weight_qty":"0.0","thermal_print":2,"thermal_print_status":0,"picking_user":null,"picking_date":null,"standard_weight":0.0,"pick_finish":false},"invoices":[],"vip_code":"123672916","warehouse_code":"01","shop_code":"1","vip_real_name":null,"vip_id_card":null,"package_center_code":null,"package_center_name":null,"sync_status":1,"sync_memo":null}],"total":1}
    assert(GyBaseResp.isSuccecd(rs));
  }

  /**
   * 26	发货单修改（gy.erp.trade.deliverys.update）
   * 考拉确认订单后修改为 3:转入外仓
   * @return
   */
  @Test
  public void updateDeliverysTo3(){
    Map<String, Object> map = new HashMap<String, Object>();
    //map.put("code", ""); //单据编号
    map.put("code", ""); //单据编号
    List<Map<String, Object>> deliverys_state_paramlist = new ArrayList<Map<String, Object>>();
    Map<String, Object> action = new LinkedHashMap<String, Object>();
    action.put("area_id", "3");
    action.put("operator", ConfigInfo.operater);
    action.put("operator_date", DateUtil.dateToString(new Date()));
    deliverys_state_paramlist.add(action);
    map.put("deliverys_state_paramlist", deliverys_state_paramlist);
    GyDeliveryUpdateResp rs = gyApiService.updateDelivery(map);
    assert(GyBaseResp.isSuccecd(rs));
  }

  /**
   * 24	发货单同步状态批量修改 gy.erp.trade.deliverys.syncstatus.update
   * 考拉下单支付：数据同步状态-成功-已同步  支付失败-同步失败
   */
  @Test
  public void updateDeliveryStatus(){
    Map<String, Object> map = new HashMap<String, Object>();
    List<String> deliveryCodeList = new ArrayList<String>();
    //deliverys_state_paramlist.add("SDO84187717531");
    deliveryCodeList.add("");  //单据编号
    map.put("status", "1");
    map.put("deliveryCodeList", deliveryCodeList);  // 发货单号列表
    // map.put("sync_memo", "");
    map.put("operator", ConfigInfo.operater);
    GyBaseResp rs = gyApiService.updateDeliveryStatus(map);
    System.out.println(JSON.toJSONString(rs));
  }

  /**
   * 26	发货单修改（gy.erp.trade.deliverys.update）
   * 考拉订单发货：发货单修改，物流信息 ，已打单0
   * @return
   */
  @Test
  public void updateDeliverysTo2WithExpress(){
    String orderStatuesStr = "{\"gorderId\":\"201606XXXXXX23\",\"result\":[{\"desc\":\"交易成功\",\"status\":5,\"limitReason\":\"\",\"isLimit\":false,\"skuList\":[{\"buyCnt\":1,\"skuid\":\"5988-68a3e5516d7a7dc21fbe0e7ee13bfc1c\"}],\"deliverName\":\"EMS\",\"deliverNo\":\"XXXXX\",\"orderId\":\"201606XXXXx0038100\"}],\"recCode\":200,\"gpayAmount\":98.75,\"totalOverseaLogisticsAmount\":0,\"totalServiceFee\":0,\"logisticsTaxAmount\":0,\"trackLogistics\":{},\"totalChinaLogisticsAmount\":0,\"totalTaxAmount\":10.51,\"recMeg\":\"查询成功\",\"gorderStatus\":3}";
    KlOrderStatusQueryResp orderStatues = JSON.parseObject(orderStatuesStr, KlOrderStatusQueryResp.class);
    if(KlBaseResp.isSuccecd(orderStatues)){
      if(!CollectionUtils.isEmpty(orderStatues.getResult())){
        KlOrderStatusResult result = orderStatues.getResult().get(0);
        if(!StringUtils.isEmpty(result.getDeliverName()) && !StringUtils.isEmpty(result.getDeliverNo())){
          // 已发货
          Map<String, Object> map = new HashMap<String, Object>();
          map.put("code", "sdfdsfdsf"); //单据编号
          map.put("express_code", "EMS"); //物流公司代码
          map.put("mail_no", "SXD344334343421141"); //运单号
          List<Map<String, Object>> deliverys_state_paramlist = new ArrayList<Map<String, Object>>();
          Map<String, Object> action = new LinkedHashMap<String, Object>();
          action.put("area_id", "0");
          action.put("operator", ConfigInfo.operater);
          action.put("note", "打单");
          action.put("operator_date", DateUtil.dateToString(new Date()));
          deliverys_state_paramlist.add(action);
         /* Map<String, Object> action2 = new LinkedHashMap<String, Object>();
          action2.put("area_id", "1");
          action2.put("operator", "systemkaola");
          action2.put("operator_date", DateUtil.dateToString(new Date()));
          Map<String, Object> action3 = new LinkedHashMap<String, Object>();
          action3.put("area_id", "2");
          action3.put("operator", "systemkaola");
          action3.put("operator_date", DateUtil.dateToString(new Date()));
          Map<String, Object> action4 = new LinkedHashMap<String, Object>();
          action4.put("area_id", "4");
          action4.put("operator", "systemkaola");
          action4.put("operator_date", DateUtil.dateToString(new Date()));

          deliverys_state_paramlist.add(action2);
          deliverys_state_paramlist.add(action3);
          deliverys_state_paramlist.add(action4);*/

          map.put("deliverys_state_paramlist", deliverys_state_paramlist);
          GyDeliveryUpdateResp rs = gyApiService.updateDelivery(map);
          //assert(GyBaseResp.isSuccecd(rs));
        }
      }
    }

  }

  @Autowired
  GyOrderUtilService gyOrderUtilService;
  @Test
  public void utilsTest(){

    gyOrderUtilService.getGyDeliverByCode("");
    gyOrderUtilService.updateDeliverysToOtherWareHouse("");
    gyOrderUtilService.updateDeliverysToExpress("", "EMS","111111111");

  }


  @Test
  public void fix(){
    Map<String, Object> map = new HashMap<String, Object>();
    map.put("code", ""); //单据编号
    map.put("express_code", "SFSY"); //物流公司代码
    map.put("mail_no", "455168677516"); //运单号
      List<Map<String, Object>> deliverys_state_paramlist = new ArrayList<Map<String, Object>>();
      Map<String, Object> action = new LinkedHashMap<String, Object>();
      action.put("area_id", "0");
      action.put("operator", ConfigInfo.operater);
      action.put("operator_date", DateUtil.dateToString(new Date()));
      map.put("deliverys_state_paramlist", deliverys_state_paramlist);
      deliverys_state_paramlist.add(action);
    GyDeliveryUpdateResp rs = gyApiService.updateDelivery(map);
    System.out.println(rs);
  }

}
