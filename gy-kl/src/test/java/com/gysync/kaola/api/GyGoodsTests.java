package com.gysync.kaola.api;

import com.gysync.kaola.BaseTests;
import com.gysync.kaola.entity.gy.resp.*;
import com.gysync.kaola.entity.kl.resp.GyupdateStockResp;
import com.gysync.kaola.service.GyApiService;
import lombok.extern.slf4j.Slf4j;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.*;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@Slf4j
public class GyGoodsTests extends BaseTests {

  @Autowired
  private GyApiService gyApiService;
  //@Autowired
  //private GyStockPoDao gyStockPoDao;

  @Test
  public void getGoods() {
    Map<String, Object> map = new HashMap<>();
    GyGoodsResp rs = gyApiService.getGoods(map);
    System.out.println(rs.toString());
  }

  @Test
  public void getStock() {
    Map<String, Object> map = new HashMap<>();
    map.put("warehouse_code", "GZ001"); //须制定仓库
    GyStockGetResp rs = gyApiService.getStock(map);
    if(GyBaseResp.isSuccecd(rs)){
      List<GyStockPo> stocks = rs.getStocks();
      //List<GyStockPo> stocks2 =  gyStockPoDao.save(stocks);
      //System.out.println(stocks2.size());
    }
    System.out.println(rs.toString());
  }

  @Test
  public void updateStock(){
    // {"success":true,"errorCode":"","subErrorCode":"","errorDesc":"","subErrorDesc":"","requestMethod":"gy.erp.stock.count.add","code":"WCO85429276203","detailErrorList":[]}
    Map<String, Object> map = new HashMap<>();
    map.put("warehouse_code", "GZ001"); // v1:00007,demo:CK003;
    // map.put("note", "test inventory..");
    List<Map<String, Object>> details = new ArrayList<Map<String, Object>>();

    Map<String, Object> item = new LinkedHashMap<String, Object>();
    item.put("item_code", "A0100161001952"); // demo:20170528002;
    item.put("sku_code", "A0100161001952"); // demo:20170528002;
    item.put("qty", "900");
    //item.put("stockDate", "2018-8-19 00:00:00");
    //item.put("note", "考拉同步库存");
    details.add(item);

    map.put("details", details);
    GyupdateStockResp rs = gyApiService.updateStock(map);
    System.out.println(rs);

  }




}
