package com.gysync.kaola;

import com.alibaba.fastjson.JSON;
import com.gysync.kaola.dao.OrderKlCancelPoDao;
import com.gysync.kaola.dao.OrderKlConfirmPoDao;
import com.gysync.kaola.dao.OrderKlPayPoDao;
import com.gysync.kaola.dao.OrderPoDao;
import com.gysync.kaola.entity.gy.resp.GyBaseResp;
import com.gysync.kaola.entity.gy.resp.GyDeliveryUpdateResp;
import com.gysync.kaola.entity.gy.resp.GyDeliverysPo;
import com.gysync.kaola.entity.gy.resp.GyDeliverysResp;
import com.gysync.kaola.entity.kl.resp.KlOrderConfirmPkg;
import com.gysync.kaola.entity.kl.resp.KlOrderConfirmResp;
import com.gysync.kaola.entity.kl.resp.KlOrderPayResp;
import com.gysync.kaola.entity.po.OrderKlCancelPo;
import com.gysync.kaola.entity.po.OrderKlConfirmPo;
import com.gysync.kaola.entity.po.OrderKlPayPo;
import com.gysync.kaola.entity.po.OrderPo;
import com.gysync.kaola.service.GyApiService;
import com.gysync.kaola.service.GyOrderUtilService;
import com.gysync.kaola.service.KlApiService;
import com.gysync.kaola.service.impl.SyncOrderServiceImpl;
import lombok.extern.slf4j.Slf4j;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.MockitoAnnotations;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.boot.test.mock.mockito.SpyBean;
import org.springframework.test.context.junit4.SpringRunner;

import java.util.HashMap;
import java.util.Map;

import static org.mockito.Matchers.*;
import static org.mockito.Mockito.when;

@RunWith(SpringRunner.class)
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@Slf4j
public class SyncOrderServiceImplTests {

    @InjectMocks
    private SyncOrderServiceImpl syncOrderServiceImpl;

    @SpyBean
    private GyApiService gyApiService;

    @MockBean
    private KlApiService klApiService;
    @MockBean
    private OrderPoDao orderPoDao;
    @MockBean
    private OrderKlConfirmPoDao orderKlConfirmPoDao;
    @MockBean
    private OrderKlPayPoDao orderKlPayPoDao;
    @MockBean
    private GyOrderUtilService gyOrderUtilService;
    @MockBean
    private OrderKlCancelPoDao orderKlCancelPoDao;

    @Before
    public void setup() {
        MockitoAnnotations.initMocks(this);
        when(orderPoDao.save(any(OrderPo.class))).thenReturn(any(OrderPo.class));
        when(orderKlConfirmPoDao.save(any(OrderKlConfirmPo.class))).thenReturn(any(OrderKlConfirmPo.class));
        when(orderKlPayPoDao.save(any(OrderKlPayPo.class))).thenReturn(any(OrderKlPayPo.class));
        when(orderKlCancelPoDao.save(any(OrderKlCancelPo.class))).thenReturn(any(OrderKlCancelPo.class));
        when(gyOrderUtilService.getDeliverys(any(Map.class))).thenReturn(any(GyDeliverysResp.class));
        when(gyOrderUtilService.getGyDeliverByCode(anyString())).thenReturn(any(GyDeliverysResp.class));
        when(gyOrderUtilService.updateDeliverysToOtherWareHouse(anyString())).thenReturn(any(GyDeliveryUpdateResp.class));
        when(gyOrderUtilService.updateDeliverysToExpress(anyString(), anyString(), anyString())).thenReturn(any(GyDeliveryUpdateResp.class));
        when(gyOrderUtilService.updateDeliveryStatus(anyString(), anyInt())).thenReturn(any(GyBaseResp.class));
        String orderconfirmStr = "{\"orderForm\":{\"orderAmount\":199,\"payAmount\":222.68,\"taxPayAmount\":23.68,\"logisticsPayAmount\":0,\"needVerifyLevel\":1,\"orderCloseTime\":43200,\"packageList\":[{\"payAmount\":110.78,\"taxPayAmount\":11.78,\"logisticsPayAmount\":0,\"importType\":1,\"needVerifyLevel\":1,\"packageOrder\":0,\"warehouse\":{\"warehouseId\":7,\"warehouseName\":\"郑州保税仓\",\"warehouseNameAlias\":\"郑州保税仓\"},\"goodsList\":[{\"goodsId\":19085,\"skuId\":\"12864-68a3e5516d7a7dc21fbe0e7ee13bfc1c\",\"sku\":{\"skuId\":\"12864-68a3e5516d7a7dc21fbe0e7ee13bfc1c\",\"actualCurrentPrice\":59,\"xyTaxRate\":0.3},\"warehouseId\":7,\"goodsUnitPriceWithoutTax\":99,\"goodsTaxAmount\":11.781,\"goodsPayAmount\":99,\"goodsBuyNumber\":1,\"imageUrl\":\"http://haitao.nos.netease.com/onlinei9wqpucq10762.jpg\",\"composeTaxRate\":0.119}],\"goodsSource\":\"郑州保税仓 发货\"}]},\"recCode\":200,\"recMeg\":\"成功\"}";
        KlOrderConfirmResp orderconform = JSON.parseObject(orderconfirmStr, KlOrderConfirmResp.class);
        when(klApiService.orderConfirm(any(GyDeliverysPo.class))).thenReturn(orderconform);
        String orderPayStr = "{\"gorder\":{\"id\":\"201612262323GORDER56612040\",\"gpayAmount\":323.4,\"originalGpayAmount\":323.4,\"gorderAmount\":323.4,\"goodsName\":\"短标题20161012113503597\",\"gorderStatus\":0},\"recCode\":200,\"recMeg\":\"支付成功\"}";
        KlOrderPayResp klOrderPayResp = JSON.parseObject(orderPayStr, KlOrderPayResp.class);
        when(klApiService.bookpayorder(any(GyDeliverysPo.class), any(KlOrderConfirmPkg.class))).thenReturn(klOrderPayResp);
    }

    @Test
    public void gyOrderSyncByRoundTest(){

        Map<String, Object> map = new HashMap<>();
        //map.put("warehouse_code", "80772237978");  //仓库代码
        //map.put("delivery", "0"); //0:未发货、发货中、发货失败 1:发货成功
        map.put("sync_status", "0"); //0:未同步
        map.put("del", "1"); //0:是否同时返回已作废的单据 0:不返回（默认
        syncOrderServiceImpl.gyklOrderSync(map);
        System.out.println(".....end");


    }




}
