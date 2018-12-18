package com.gysync.kaola.controller;

import com.gysync.kaola.comm.util.KlGyAddressUtil;
import com.gysync.kaola.task.OrderSyncTask;
import com.gysync.kaola.task.StockSyncTask;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
@Slf4j
public class UtilController {

    @Autowired
    StockSyncTask stockSyncTask;
    @Autowired
    OrderSyncTask orderSyncTask;
    @Autowired
    KlGyAddressUtil klGyAddressUtil;

    @ApiOperation(value = "检查同步脚本是否开启", tags = "系统参数")
    @GetMapping(value = "/task/state")
    public String search() {
        log.info(String.valueOf(orderSyncTask.isJobEnable()));
        log.info(String.valueOf(orderSyncTask.isIsrunning()));
        return "enable:"+String.valueOf(orderSyncTask.isJobEnable())+" running:"+String.valueOf(orderSyncTask.isIsrunning());
    }

    @ApiOperation(value = "开启同步脚本", tags = "系统参数")
    @GetMapping(value = "/task/enable")
    public String enable() {
        stockSyncTask.setJobEnable(true);
        orderSyncTask.setJobEnable(true);
        log.info(String.valueOf(stockSyncTask.isJobEnable()));
        return String.valueOf(stockSyncTask.isJobEnable());
    }

    @ApiOperation(value = "关闭同步脚本", tags = "系统参数")
    @GetMapping(value = "/task/disable")
    public String disable() {
        stockSyncTask.setJobEnable(false);
        orderSyncTask.setJobEnable(false);
        log.info(String.valueOf(stockSyncTask.isJobEnable()));
        return String.valueOf(stockSyncTask.isJobEnable());
    }

    @ApiOperation(value = "获取地址映射", tags = "系统配置")
    @GetMapping(value = "/config/getDistrictMapping")
    public Map<String, String> getDistrictMapping() {
        return klGyAddressUtil.getDistrictMap();
    }

    @ApiOperation(value = "刷新地址映射", tags = "系统配置")
    @GetMapping(value = "/config/refreshDistrictMapping")
    public Map<String, String> refreshDistrictMapping() {
        return klGyAddressUtil.refreshDistrictMapping();
    }

}
