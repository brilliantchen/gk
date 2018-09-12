package com.gysync.kaola.service.impl;

import com.alibaba.fastjson.JSONArray;
import com.gysync.kaola.comm.ConfigInfo;
import com.gysync.kaola.comm.Constant;
import com.gysync.kaola.dao.GyStockPoDao;
import com.gysync.kaola.entity.gy.resp.GyBaseResp;
import com.gysync.kaola.entity.gy.resp.GyStockGetResp;
import com.gysync.kaola.entity.gy.resp.GyStockPo;
import com.gysync.kaola.entity.kl.resp.GyupdateStockResp;
import com.gysync.kaola.entity.kl.resp.KlBaseResp;
import com.gysync.kaola.entity.kl.resp.KlGoodsInfoPo;
import com.gysync.kaola.entity.kl.resp.KlGoodsResp;
import com.gysync.kaola.service.GyApiService;
import com.gysync.kaola.service.SyncGoodsService;
import com.gysync.kaola.service.KlApiService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.CollectionUtils;

import java.util.*;

@Service
@Slf4j
public class SyncGoodsServiceImpl implements SyncGoodsService {

    @Autowired
    private GyApiService gyApiService;
    @Autowired
    private KlApiService klApiService;
    @Autowired
    private GyStockPoDao gyStockPoDao;


    @Override
    public long goodsSync(String warehouseCode) {
        long cost = 0l;
        long time = System.currentTimeMillis();
        log.info("gykl goods sync start...");
        updateGyStock(warehouseCode);
        cost = (System.currentTimeMillis()-time)/1000;
        log.info("gykl goods sync end... time cost:{}s", System.currentTimeMillis()-time/1000);
        return cost;

    }

    @Override
    public void stockSync(String warehouseCode) {
        long time = System.currentTimeMillis();
        log.info("gykl stock sync start...");
        //
        log.info("gykl stock sync end... time cost:{}s", (System.currentTimeMillis()-time)/1000);
    }

    private void gyGoodsyncByRound(String warehouseCode, int currentPage, int count, boolean syncStock){
        Map<String, Object> map = new HashMap<>();
        map.put("warehouse_code", warehouseCode); //须制定仓库
        map.put("page_no", String.valueOf(currentPage));
        map.put("page_size", String.valueOf(Constant.page_size20));
        try {
            // 1.抽取管易库存，获取需要同步的商品
            GyStockGetResp rs = gyApiService.getStock(map);
            if(currentPage == 1) count = rs.getTotal();
            log.info("gyGoodsSync success:{} count:{} currentPage:{} ...",rs.isSuccess(), count, currentPage);
            if(count > 0){
                if(GyBaseResp.isSuccecd(rs)){
                    try {
                        List<GyStockPo> stocks = rs.getStocks();
                        // 2.查询考拉商品库存
                        if(syncStock){
                            JSONArray skuIds = new JSONArray();
                            for (GyStockPo gyStockPo:stocks) {
                                skuIds.add(gyStockPo.getSku_code());
                            }
                            List<KlGoodsResp> klGoodsResps = klApiService.queryGoodsInfoByIds(skuIds);
                            localSave(klGoodsResps, stocks);
                            // 更新管易库存
                            map.put("warehouse_code", warehouseCode); // v1:00007,demo:CK003;
                            // map.put("note", "test inventory..");
                            List<Map<String, Object>> details = new ArrayList<Map<String, Object>>();
                            putDetail(details, klGoodsResps);
                            map.put("details", details);
                            // 3.更新考拉库存至管易
                            GyupdateStockResp gyupdateStockResp =  gyApiService.updateStock(map);
                            if(GyBaseResp.isSuccecd(gyupdateStockResp)){
                                log.info("gyGoodsSync gyApiService.updateStock success{}",gyupdateStockResp.isSuccess());
                            }
                        }
                    }catch (Exception e){
                        log.info("gyGoodsSync error currentPage::{}. ",currentPage, e);
                    }
                }
                count -= Constant.page_size;
                if(count > 0){
                    gyGoodsyncByRound(warehouseCode,currentPage+1, count, syncStock);
                }
            }
        }catch (Exception e){
            log.info("gyGoodsSync error currentPage::{}. ",currentPage, e);
        }
    }

    private void updateGyStock(String warehouseCode){
        Map<String, Object> map = new HashMap<>();
        // 更新管易库存
        map.put("warehouse_code", warehouseCode); // v1:00007,demo:CK003;
        map.put("operator", ConfigInfo.operater); // v1:00007,demo:CK003;
        map.put("note", ConfigInfo.operater);
        List<Map<String, Object>> details = new ArrayList<Map<String, Object>>();
        this.buildStocks(details, warehouseCode,1,0);
        map.put("details", details);
        // 3.更新考拉库存至管易
        GyupdateStockResp gyupdateStockResp =  gyApiService.updateStock(map);
        if(GyBaseResp.isSuccecd(gyupdateStockResp)){
            log.info("gyGoodsSync gyApiService.updateStock success{} count::::::",gyupdateStockResp.isSuccess(), details.size());
        }
    }

    private List<Map<String, Object>> buildStocks(List<Map<String, Object>> details,String warehouseCode, int currentPage, int count){
        Map<String, Object> map = new HashMap<>();
        map.put("warehouse_code", warehouseCode); //须制定仓库
        map.put("page_no", String.valueOf(currentPage));
        map.put("page_size", String.valueOf(Constant.page_size20));
        try {
            // 1.抽取管易库存，获取需要同步的商品
            GyStockGetResp rs = gyApiService.getStock(map);
            if(currentPage == 1) count = rs.getTotal();
            log.info("gyGoodsSync success:{} count:{} currentPage:{} ...",rs.isSuccess(), count, currentPage);
            if(count > 0){
                if(GyBaseResp.isSuccecd(rs)){
                    try {
                        List<GyStockPo> stocks = rs.getStocks();
                        // 2.查询考拉商品库存
                        JSONArray skuIds = new JSONArray();
                        for (GyStockPo gyStockPo:stocks) {
                            skuIds.add(gyStockPo.getSku_code());
                        }
                        List<KlGoodsResp> klGoodsResps = klApiService.queryGoodsInfoByIds(skuIds);
                        localSave(klGoodsResps, stocks);
                        this.putDetail(details, klGoodsResps);
                    }catch (Exception e){
                        log.info("gyGoodsSync error currentPage::{}. ",currentPage, e);
                    }
                }
                count -= Constant.page_size20;
                if(count > 0){
                    this.buildStocks(details,warehouseCode,currentPage+1, count);
                }
            }
        }catch (Exception e){
            log.info("gyGoodsSync error currentPage::{}. ",currentPage, e);
        }
        return details;
    }

    private void putDetail(List<Map<String, Object>> details, List<KlGoodsResp> klGoodsResps){
        for (KlGoodsResp klGoodsResp:klGoodsResps) {
            if(KlBaseResp.isSuccecd(klGoodsResp)) {
                Map<String, Object> item = new HashMap<String, Object>();
                item.put("item_code", String.valueOf(klGoodsResp.getGoodsInfo().getGoodsId()));
                item.put("sku_code", klGoodsResp.getGoodsInfo().getSkuId());
                item.put("qty", String.valueOf(klGoodsResp.getGoodsInfo().getStore()));
                details.add(item);
            }
        }
        log.info("////"+details.size());
    }

    private void gyGoodsyncByRoundHandler(List<GyStockPo> stocks){

    }

    private void localSave(List<KlGoodsResp> klGoodsResps, List<GyStockPo> stocks){
        try {
            if(!CollectionUtils.isEmpty(klGoodsResps)){
                buildGyStockPoKlInfo(stocks, klGoodsResps);
            }
            gyStockPoDao.save(stocks); //更新本地库存
        }catch (Exception e){
            log.info("gyGoodsSync goods localSave error", e);
        }
    }

    private void buildGyStockPoKlInfo(List<GyStockPo> gyStockPos, List<KlGoodsResp> klGoodsResps){
        for (KlGoodsResp klGoodsResp:klGoodsResps) {
            if(KlBaseResp.isSuccecd(klGoodsResp)){
                for (GyStockPo gyStockPo:gyStockPos) {
                    if (gyStockPo.getSku_code().equals(klGoodsResp.getGoodsInfo().getSkuId())) {
                        buildGyStockPoKlInfo(gyStockPo, klGoodsResp.getGoodsInfo());
                        break;
                    }
                }
            }
        }
    }

    private void buildGyStockPoKlInfo(GyStockPo gyStockPo, KlGoodsInfoPo klGoodsInfoPo){
        gyStockPo.setKlgoodsId(klGoodsInfoPo.getGoodsId());
        gyStockPo.setKlonlineStatus(klGoodsInfoPo.getOnlineStatus());
        gyStockPo.setKlprice(klGoodsInfoPo.getPrice());
        gyStockPo.setKlstore(klGoodsInfoPo.getStore());
        gyStockPo.setUpdate_time(new Date());
    }



}
