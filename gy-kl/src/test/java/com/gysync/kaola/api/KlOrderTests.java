package com.gysync.kaola.api;

import com.alibaba.fastjson.JSON;
import com.gysync.kaola.BaseTests;
import com.gysync.kaola.entity.gy.resp.GyDeliverysDetail;
import com.gysync.kaola.entity.gy.resp.GyDeliverysPo;
import com.gysync.kaola.entity.gy.resp.GyDeliverysResp;
import com.gysync.kaola.entity.kl.resp.*;
import com.gysync.kaola.service.KlApiService;
import lombok.extern.slf4j.Slf4j;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.util.CollectionUtils;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@Slf4j
public class KlOrderTests extends BaseTests {

  @Autowired
  private KlApiService klApiService;

  /**
   * 订单确认（分销2.0）
   */
  @Test
  public void orderConfirm() {
    Map<String, String> map = new HashMap<String, String>();
    String gyrs = "{\"success\":true,\"errorCode\":\"\",\"subErrorCode\":\"\",\"errorDesc\":\"\",\"subErrorDesc\":\"\",\"requestMethod\":\"gy.erp.trade.deliverys.get\",\"deliverys\":[{\"create_date\":\"2017-12-12 09:50:42\",\"modify_date\":\"2018-07-09 12:38:21\",\"code\":\"SDO63355385103\",\"qty\":2.0,\"amount\":78500.0,\"payment\":80000.0,\"pay_time\":\"2017-07-29 13:20:48\",\"cod\":true,\"refund\":0,\"invoiceDate\":null,\"bigchar\":null,\"cancel\":0,\"platform_code\":\"0006\",\"unpaid_amount\":0.0,\"post_fee\":0.0,\"cod_fee\":0.0,\"discount_fee\":0.0,\"post_cost\":0.0,\"plan_delivery_date\":null,\"buyer_memo\":null,\"seller_memo\":null,\"receiver_name\":\"MA Su Su\",\"receiver_phone\":\"024567\",\"receiver_mobile\":\"09456789\",\"receiver_zip\":\"100010\",\"receiver_address\":\"Mandalay\",\"create_name\":\"金城武\",\"express_no\":\"12345654321\",\"vip_name\":\"MaSuSu\",\"shop_name\":\"Online Shop\",\"area_name\":\"北京-北京市-东城区\",\"warehouse_name\":\"MandalayWarehouse\",\"express_code\":null,\"express_name\":null,\"tag_name\":\"延迟发货\",\"seller_memo_late\":null,\"shelf_no\":null,\"details\":[{\"qty\":2.0,\"price\":0.0,\"amount\":0.0,\"refund\":0,\"memo\":null,\"picUrl\":null,\"trade_code\":\"SO51625443603\",\"origin_price\":0.0,\"item_id\":\"45354683124\",\"item_sku_id\":\"45354682284\",\"item_code\":\"cr015\",\"item_name\":\"皮\",\"sku_code\":\"cr015\",\"sku_name\":\"皮\",\"sku_note\":\"\",\"platform_code\":\"0006\",\"discount_fee\":0.0,\"amount_after\":0.0,\"post_fee\":0.0,\"post_cost\":0.0,\"tax_rate\":0.0,\"tax_amount\":0.0,\"order_type\":\"Invoice\",\"platform_flag\":0,\"detail_unique\":[],\"detail_batch\":null,\"is_gift\":0,\"businessman_name\":\"SuSu\",\"item_add_attribute\":0}],\"delivery_statusInfo\":{\"scan\":false,\"weight\":false,\"wms\":0,\"delivery\":-1,\"cancel\":false,\"intercept\":false,\"print_express\":true,\"express_print_name\":\"liaochao\",\"express_print_date\":\"2018-05-14 14:53:17\",\"print_delivery\":false,\"delivery_print_name\":null,\"delivery_print_date\":null,\"scan_name\":null,\"scan_date\":null,\"weight_name\":null,\"weight_date\":null,\"wms_order\":0,\"delivery_name\":\"22601822\",\"delivery_date\":\"2018-03-07 23:54:49\",\"cancel_name\":null,\"cancel_date\":null,\"weight_qty\":\"0.0\",\"thermal_print\":2,\"thermal_print_status\":0,\"picking_user\":null,\"picking_date\":null,\"standard_weight\":0.0,\"pick_finish\":false},\"invoices\":[],\"vip_code\":\"005\",\"warehouse_code\":\"012\",\"shop_code\":\"1000\",\"vip_real_name\":\"Ma Su Su\",\"vip_id_card\":null,\"package_center_code\":null,\"package_center_name\":null,\"sync_status\":0,\"sync_memo\":null},{\"create_date\":\"2018-03-14 15:10:00\",\"modify_date\":\"2018-07-09 12:38:21\",\"code\":\"SDO69654886215\",\"qty\":1.0,\"amount\":0.0,\"payment\":0.0,\"pay_time\":\"2018-01-31 00:00:00\",\"cod\":false,\"refund\":0,\"invoiceDate\":null,\"bigchar\":null,\"cancel\":0,\"platform_code\":\"831211831211\",\"unpaid_amount\":0.0,\"post_fee\":0.0,\"cod_fee\":0.0,\"discount_fee\":0.0,\"post_cost\":0.0,\"plan_delivery_date\":null,\"buyer_memo\":null,\"seller_memo\":\"测试测试\",\"receiver_name\":\"贾青\",\"receiver_phone\":\"\",\"receiver_mobile\":\"18653131435\",\"receiver_zip\":\"\",\"receiver_address\":\"兖州区\",\"create_name\":\"SuSu\",\"express_no\":null,\"vip_name\":\"123\",\"shop_name\":\"维密内衣\",\"area_name\":\"山东-济宁市-高新区\",\"warehouse_name\":\"a共享库\",\"express_code\":\"JDKD\",\"express_name\":\"京东快递\",\"tag_name\":null,\"seller_memo_late\":null,\"shelf_no\":null,\"details\":[{\"qty\":1.0,\"price\":0.0,\"amount\":0.0,\"refund\":0,\"memo\":\"\",\"picUrl\":null,\"trade_code\":\"SO67041462177\",\"origin_price\":0.0,\"item_id\":\"45354683124\",\"item_sku_id\":\"45354682284\",\"item_code\":\"cr015\",\"item_name\":\"皮\",\"sku_code\":\"cr015\",\"sku_name\":\"皮\",\"sku_note\":\"\",\"platform_code\":\"831211831211\",\"discount_fee\":0.0,\"amount_after\":0.0,\"post_fee\":0.0,\"post_cost\":0.0,\"tax_rate\":0.0,\"tax_amount\":0.0,\"order_type\":\"Sales\",\"platform_flag\":0,\"detail_unique\":[],\"detail_batch\":null,\"is_gift\":0,\"businessman_name\":\"测试客服\",\"item_add_attribute\":0}],\"delivery_statusInfo\":{\"scan\":false,\"weight\":false,\"wms\":0,\"delivery\":0,\"cancel\":false,\"intercept\":false,\"print_express\":false,\"express_print_name\":null,\"express_print_date\":null,\"print_delivery\":false,\"delivery_print_name\":null,\"delivery_print_date\":null,\"scan_name\":null,\"scan_date\":null,\"weight_name\":null,\"weight_date\":null,\"wms_order\":0,\"delivery_name\":null,\"delivery_date\":null,\"cancel_name\":null,\"cancel_date\":null,\"weight_qty\":\"0.0\",\"thermal_print\":2,\"thermal_print_status\":0,\"picking_user\":null,\"picking_date\":null,\"standard_weight\":0.0,\"pick_finish\":false},\"invoices\":[],\"vip_code\":\"85_41096081304\",\"warehouse_code\":\"0006\",\"shop_code\":\"HS20170001\",\"vip_real_name\":\"贾青\",\"vip_id_card\":null,\"package_center_code\":null,\"package_center_name\":null,\"sync_status\":0,\"sync_memo\":null}],\"total\":1825}";
    GyDeliverysResp rs = JSON.parseObject(gyrs, GyDeliverysResp.class);
    if (GyDeliverysResp.isSuccecd(rs) && !CollectionUtils.isEmpty(rs.getDeliverys())) {
      for (GyDeliverysPo po : rs.getDeliverys()) {
        KlOrderConfirmResp orderconform = klApiService.orderConfirm(po);
        System.out.println(orderconform.toString());
      }
    }
  }

  @Test
  public void orderConfirm2(){
    GyDeliverysPo gyDeliverysPo = new GyDeliverysPo();
    gyDeliverysPo.setCode("gyO00000018372");
    gyDeliverysPo.setReceiver_mobile("15109342312");
    gyDeliverysPo.setVip_code("test@163.com");
    gyDeliverysPo.setArea_name("上海-上海-浦东新区");
    gyDeliverysPo.setVip_code("gy000000000001");
    gyDeliverysPo.setReceiver_address("人民路100号");
    gyDeliverysPo.setVip_real_name("曾千山");
    gyDeliverysPo.setReceiver_name("曾千山");
    gyDeliverysPo.setVip_id_card("510421198302065863"); //一般贸易商品可不传
    GyDeliverysDetail po = new GyDeliverysDetail();
    po.setItem_code("49255695");
    //po.setItem_code("2133725");
    po.setSku_code("49255695-ecc4090b639c47f89b453980923afb8e");
    //po.setSku_code("00005649821");
    po.setQty(1);
    po.setAmount(200d);
    List<GyDeliverysDetail> list = new ArrayList<>();
    list.add(po);
    gyDeliverysPo.setDetails(list);

    KlOrderConfirmResp rs = klApiService.orderConfirm(gyDeliverysPo);
    System.out.println(rs.toString());
  }

  /**
   * 渠道订单代下代支付
   */
  @Test
    public void bookpayorder(){
      String gydeliverStr = "{\"create_date\":\"2018-03-14 15:10:00\",\"modify_date\":\"2018-07-09 12:38:21\",\"code\":\"SDO69654886215\",\"qty\":1,\"amount\":0,\"payment\":0,\"pay_time\":\"2018-01-31 00:00:00\",\"cod\":false,\"refund\":0,\"invoiceDate\":null,\"bigchar\":null,\"cancel\":0,\"platform_code\":\"831211831211\",\"unpaid_amount\":0,\"post_fee\":0,\"cod_fee\":0,\"discount_fee\":0,\"post_cost\":0,\"plan_delivery_date\":null,\"buyer_memo\":null,\"seller_memo\":\"测试测试\",\"receiver_name\":\"贾青\",\"receiver_phone\":\"\",\"receiver_mobile\":\"18653131435\",\"receiver_zip\":\"\",\"receiver_address\":\"兖州区\",\"create_name\":\"SuSu\",\"express_no\":null,\"vip_name\":\"123\",\"shop_name\":\"维密内衣\",\"area_name\":\"山东-济宁市-高新区\",\"warehouse_name\":\"a共享库\",\"express_code\":\"JDKD\",\"express_name\":\"京东快递\",\"tag_name\":null,\"seller_memo_late\":null,\"shelf_no\":null,\"details\":[{\"qty\":1,\"price\":0,\"amount\":0,\"refund\":0,\"memo\":\"\",\"picUrl\":null,\"trade_code\":\"SO67041462177\",\"origin_price\":0,\"item_id\":\"45354683124\",\"item_sku_id\":\"45354682284\",\"item_code\":\"cr015\",\"item_name\":\"皮\",\"sku_code\":\"cr015\",\"sku_name\":\"皮\",\"sku_note\":\"\",\"platform_code\":\"831211831211\",\"discount_fee\":0,\"amount_after\":0,\"post_fee\":0,\"post_cost\":0,\"tax_rate\":0,\"tax_amount\":0,\"order_type\":\"Sales\",\"platform_flag\":0,\"detail_unique\":[],\"detail_batch\":null,\"is_gift\":0,\"businessman_name\":\"测试客服\",\"item_add_attribute\":0}],\"delivery_statusInfo\":{\"scan\":false,\"weight\":false,\"wms\":0,\"delivery\":0,\"cancel\":false,\"intercept\":false,\"print_express\":false,\"express_print_name\":null,\"express_print_date\":null,\"print_delivery\":false,\"delivery_print_name\":null,\"delivery_print_date\":null,\"scan_name\":null,\"scan_date\":null,\"weight_name\":null,\"weight_date\":null,\"wms_order\":0,\"delivery_name\":null,\"delivery_date\":null,\"cancel_name\":null,\"cancel_date\":null,\"weight_qty\":\"0.0\",\"thermal_print\":2,\"thermal_print_status\":0,\"picking_user\":null,\"picking_date\":null,\"standard_weight\":0,\"pick_finish\":false},\"invoices\":[],\"vip_code\":\"85_41096081304\",\"warehouse_code\":\"0006\",\"shop_code\":\"HS20170001\",\"vip_real_name\":\"贾青\",\"vip_id_card\":null,\"package_center_code\":null,\"package_center_name\":null,\"sync_status\":0,\"sync_memo\":null}";
      GyDeliverysPo gydeliver = JSON.parseObject(gydeliverStr, GyDeliverysPo.class);
      String orderconfirmStr = "{\"orderForm\":{\"orderAmount\":199,\"payAmount\":222.68,\"taxPayAmount\":23.68,\"logisticsPayAmount\":0,\"needVerifyLevel\":1,\"orderCloseTime\":43200,\"packageList\":[{\"payAmount\":110.78,\"taxPayAmount\":11.78,\"logisticsPayAmount\":0,\"importType\":1,\"needVerifyLevel\":1,\"packageOrder\":0,\"warehouse\":{\"warehouseId\":7,\"warehouseName\":\"郑州保税仓\",\"warehouseNameAlias\":\"郑州保税仓\"},\"goodsList\":[{\"goodsId\":19085,\"skuId\":\"12864-68a3e5516d7a7dc21fbe0e7ee13bfc1c\",\"sku\":{\"skuId\":\"12864-68a3e5516d7a7dc21fbe0e7ee13bfc1c\",\"actualCurrentPrice\":59,\"xyTaxRate\":0.3},\"warehouseId\":7,\"goodsUnitPriceWithoutTax\":99,\"goodsTaxAmount\":11.781,\"goodsPayAmount\":99,\"goodsBuyNumber\":1,\"imageUrl\":\"http://haitao.nos.netease.com/onlinei9wqpucq10762.jpg\",\"composeTaxRate\":0.119}],\"goodsSource\":\"郑州保税仓 发货\"}]},\"recCode\":200,\"recMeg\":\"成功\"}";

        KlOrderConfirmResp orderconform = JSON.parseObject(orderconfirmStr, KlOrderConfirmResp.class);
        if(KlBaseResp.isSuccecd(orderconform)){
          List<KlOrderConfirmPkg> packageList = orderconform.getOrderForm().getPackageList();
            // 可能会拆包，一般不会拆包
          for (KlOrderConfirmPkg pkg:packageList) {
            // 下单
            KlOrderPayResp KlOrderDoRespStr = klApiService.bookpayorder(gydeliver, pkg);
            System.out.println(JSON.toJSONString(KlOrderDoRespStr));
          }
        }
  }

  /**
   * 渠道订单代下代支付
   */
  @Test
  public void bookpayorder2(){
    KlOrderConfirmResp orderconform = JSON.parseObject("{\"orderForm\":{\"orderAmount\":200.00,\"payAmount\":294.00,\"logisticsTaxAmount\":0.00,\"taxPayAmount\":94.00,\"logisticsPayAmount\":0,\"needVerifyLevel\":1,\"orderCloseTime\":43200,\"packageList\":[{\"payAmount\":294.00,\"taxPayAmount\":94.00,\"logisticsPayAmount\":0,\"importType\":1,\"needVerifyLevel\":1,\"packageOrder\":0,\"warehouse\":{\"warehouseId\":2,\"warehouseName\":\"下沙保税仓库\",\"warehouseNameAlias\":\"下沙保税仓库别名\"},\"goodsList\":[{\"goodsId\":49255695,\"skuId\":\"49255695-ecc4090b639c47f89b453980923afb8e\",\"sku\":{\"skuId\":\"49255695-ecc4090b639c47f89b453980923afb8e\",\"actualCurrentPrice\":200,\"xyTaxRate\":0},\"warehouseId\":2,\"goodsUnitPriceWithoutTax\":200.00,\"goodsTaxAmount\":94.0000,\"goodsPayAmount\":200.00,\"goodsBuyNumber\":1,\"imageUrl\":\"http://haitao.nos.netease.com/irgblckx76_800_800.jpg\",\"composeTaxRate\":0.47000}],\"goodsSource\":\"下沙保税仓库别名 发货\"}]},\"recCode\":200,\"recMeg\":\"成功\"}", KlOrderConfirmResp.class);
    GyDeliverysPo gyDeliverysPo = new GyDeliverysPo();
    gyDeliverysPo.setCode("gyO00000018372");
    gyDeliverysPo.setReceiver_mobile("15109342313");
    gyDeliverysPo.setVip_code("test@163.com");
    gyDeliverysPo.setArea_name("上海-上海-浦东新区");
    gyDeliverysPo.setVip_code("gy000000000001");
    gyDeliverysPo.setReceiver_address("人民路100号");
    gyDeliverysPo.setVip_real_name("曾千山");
    gyDeliverysPo.setReceiver_name("曾千山");
    gyDeliverysPo.setVip_id_card("510421198302065863"); //一般贸易商品可不传
    GyDeliverysDetail po = new GyDeliverysDetail();
    po.setItem_code("49255695");
    po.setSku_code("49255695-ecc4090b639c47f89b453980923afb8e");
    po.setQty(1);
    po.setAmount(200d);
    List<GyDeliverysDetail> list = new ArrayList<>();
    list.add(po);
    gyDeliverysPo.setDetails(list);

    List<KlOrderConfirmPkg> packageList = orderconform.getOrderForm().getPackageList();
    for (KlOrderConfirmPkg pkg:packageList) {
      // 下单
      KlOrderPayResp KlOrderDoRespStr = klApiService.bookpayorder(gyDeliverysPo, pkg);
      System.out.println(JSON.toJSONString(KlOrderDoRespStr));
    }
    //考拉下单：{"gorder":{"goodsName":"短标题20161024114254428","gorderAmount":294.0,"gorderStatus":0,"gpayAmount":294.0,"id":"201808292326GORDER90228568","originalGpayAmount":294.0},"recCode":200,"recMeg":"支付成功"}
    //重复下单：{"recCode":200,"subCode":200,"recMeg":"订单已经支付成功,无需重复支付"}
    //取消再下单：{"recCode":200,"subCode":200,"recMeg":"订单已经支付成功,无需重复支付"}

  }

  /**
   * 渠道订单状态查询
   */
  @Test
  public void queryOrderStatus(){
    String thirdPartOrderId = "gyO00000018372";
    KlOrderStatusQueryResp rs = klApiService.queryOrderStatus(thirdPartOrderId);
    System.out.println(JSON.toJSONString(rs));
    // "{\"gorderId\":\"201606XXXXXX23\",\"result\":[{\"desc\":\"交易成功\",\"status\":5,\"limitReason\":\"\",\"isLimit\":false,\"skuList\":[{\"buyCnt\":1,\"skuid\":\"5988-68a3e5516d7a7dc21fbe0e7ee13bfc1c\"}],\"deliverName\":\"EMS\",\"deliverNo\":\"XXXXX\",\"orderId\":\"201606XXXXx0038100\"}],\"recCode\":200,\"gpayAmount\":98.75,\"totalOverseaLogisticsAmount\":0,\"totalServiceFee\":0,\"logisticsTaxAmount\":0,\"trackLogistics\":{},\"totalChinaLogisticsAmount\":0,\"totalTaxAmount\":10.51,\"recMeg\":\"查询成功\",\"gorderStatus\":3}";
    //
  }

  /**
   * 订单支付过后取消订单
   * @return
   */
  @Test
  public void cancelOrder(){
    String thirdPartOrderId = "gyO00000018372";
    KlBaseResp rs = klApiService.cancelOrder(thirdPartOrderId);
    System.out.println(JSON.toJSONString(rs));
    // 取消：{"recCode":200,"recMsg":"取消成功"}
    //重复取消：{"recCode":200,"recMsg":"取消成功"}
  }


}
