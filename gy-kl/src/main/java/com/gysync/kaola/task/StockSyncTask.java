package com.gysync.kaola.task;

import com.gysync.kaola.comm.ConfigInfo;
import com.gysync.kaola.comm.util.DateUtil;
import com.gysync.kaola.service.SyncGoodsService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.util.Date;

@Component
@Slf4j
public class StockSyncTask extends BaseTask {

    private boolean jobEnable = false;

    @Autowired
    private SyncGoodsService syncGoodsService;

    /**
     * 拉取考拉商品库存，更新到管易
     * 每天凌晨1点执行
     */
    @Scheduled(cron = "0 0 1 * * ?")
    public void mockGyOrder() {
        if(jobEnable){
            String warehouseCode = ConfigInfo.GY_KLWAREHOUSECODE;
            syncGoodsService.goodsSync(warehouseCode);
            log.info("StockSyncTask task:" + DateUtil.dateToString(new Date()));
        }
        log.info("StockSyncTask !!! task:" + DateUtil.dateToString(new Date()));
    }

    public void setJobEnable(boolean jobEnable) {
        this.jobEnable = jobEnable;
    }
    public boolean isJobEnable() {
        return jobEnable;
    }
}
