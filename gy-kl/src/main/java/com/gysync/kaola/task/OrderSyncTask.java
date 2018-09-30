package com.gysync.kaola.task;

import com.gysync.kaola.comm.ConfigInfo;
import com.gysync.kaola.comm.util.DateUtil;
import com.gysync.kaola.service.SyncOrderService;
import lombok.Data;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Component
@Slf4j
@Data
public class OrderSyncTask extends BaseTask {

    private boolean jobEnable = false;
    private volatile boolean isrunning = false;

    @Autowired
    private SyncOrderService syncOrderService;


    /**
     * 抽取管易未同步的发货单去考拉下单，并更新考拉发货单状态
     */
    //@Scheduled(cron = "0 5,35 * * * ?")
    @Scheduled(initialDelay = 2 * 60 * 1000,fixedRate = 20 * 60 * 1000)
    public void gyklOrderSync() {
        try {
            if(jobEnable){
                isrunning = true;
                String warehouseCode = ConfigInfo.GY_KLWAREHOUSECODE;
                Map<String, Object> map = new HashMap<String, Object>();
                map.put("warehouse_code", warehouseCode); //须制定仓库
                map.put("sync_status", "0"); // -1 失败 0 未同步 1 成功
                map.put("del", "0");
                syncOrderService.gyklOrderSync(map);
                log.info("gyklOrderSync task:" + DateUtil.dateToString(new Date()));
            }else{
                log.info("gyklOrderSync !!!!! task:" + DateUtil.dateToString(new Date()));
            }
        }catch (Exception e){
            isrunning = false;
            log.error("gyklOrderSync", e);
        }
        isrunning = false;
    }

    /**
     * 修复支付失败
     */
    @Scheduled(initialDelay = 10 * 60 * 1000,fixedRate = 60 * 60 * 1000)
    public void gyklOrderPayErrorSync() {
        try {
            if(jobEnable){
                isrunning = true;
                String warehouseCode = ConfigInfo.GY_KLWAREHOUSECODE;
                Map<String, Object> map = new HashMap<String, Object>();
                map.put("warehouse_code", warehouseCode); //须制定仓库
                map.put("sync_status", "-1"); // -1 失败 0 未同步 1 成功
                map.put("del", "0");
                syncOrderService.gyklOrderSync(map);
                log.info("gyklOrderPayErrorSync task:" + DateUtil.dateToString(new Date()));
            }else{
                log.info("gyklOrderPayErrorSync !!!!! task:" + DateUtil.dateToString(new Date()));
            }
        }catch (Exception e){
            isrunning = false;
            log.error("gyklOrderPayErrorSync", e);
        }
        isrunning = false;
    }

    /**
     * 抽取管易同步成功的发货单，并且发货单未打印，同步考拉发货状态
     */
    //@Scheduled(cron = "0 0/10 * * * ?")
    @Scheduled(initialDelay = 4 * 60 * 1000,fixedRate = 30 * 60 * 1000)
    public void gyklOrderExpressSync() {
        try {
            if(jobEnable){
                isrunning = true;
                String warehouseCode = ConfigInfo.GY_KLWAREHOUSECODE;
                Map<String, Object> map = new HashMap<String, Object>();
                map.put("warehouse_code", warehouseCode); //须制定仓库
                map.put("sync_status", "1"); // -1 失败 0 未同步 1 成功
                map.put("print", "0"); //0:未打单
                // 取消订单(暂时放在一起)：获得废弃发货单
                map.put("del", "0"); //0:是否同时返回已作废的单据 1:返回
                // map.put("start_create", ""); //0:创建时间开始 于当前时间2天前，用于过滤重复已作废单据（待定）
                syncOrderService.gyklOrderExpressSync(map);
                log.info("gyklOrderExpressSync task:" + DateUtil.dateToString(new Date()));
            }else {
                log.info("gyklOrderExpressSync !!! task:" + DateUtil.dateToString(new Date()));
            }
        }catch (Exception e){
            isrunning = false;
            log.error("gyklOrderExpressSync", e);
        }
        isrunning = false;
    }

    /**
     * 取消订单，抽取管易同步成功的发货单，并且发货单未打印，已作废
     */
    @Scheduled(initialDelay = 6 * 60 * 1000,fixedRate = 30 * 60 * 1000)
    //@Scheduled(cron = "0 0/30 * * * ?")
    public void gyklOrderCancelSync() {
        try {
            if(jobEnable){
                String warehouseCode = ConfigInfo.GY_KLWAREHOUSECODE;
                Map<String, Object> map = new HashMap<String, Object>();
                map.put("warehouse_code", warehouseCode); //须制定仓库
                map.put("sync_status", "1"); // -1 失败 0 未同步 1 成功
                map.put("print", "0"); //0:未打单
                // 取消订单(暂时放在一起)：获得废弃发货单
                map.put("del", "1"); //0:是否同时返回已作废的单据 1:返回
                Calendar calendar = Calendar.getInstance();
                calendar.setTime(new Date());
                calendar.add(Calendar.DATE, -10);
                map.put("start_create", DateUtil.dateToString(calendar.getTime())); //0:创建时间开始 于当前时间2天前，用于过滤重复已作废单据（待定）
                syncOrderService.gyklOrderCancel(map);
                log.info("gyklOrderExpressSync task:" + DateUtil.dateToString(new Date()));
            }else {
                log.info("gyklOrderExpressSync !!! task:" + DateUtil.dateToString(new Date()));
            }
        }catch (Exception e){
            isrunning = false;
            log.error("gyklOrderExpressSync", e);
        }
        isrunning = false;
    }




}
