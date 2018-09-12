package com.gysync.kaola.controller;

import com.alibaba.fastjson.JSON;
import com.gysync.kaola.dao.GyStockPoDao;
import com.gysync.kaola.entity.ResultBase;
import com.gysync.kaola.service.GyApiService;
import com.gysync.kaola.service.SyncGoodsService;
import com.gysync.kaola.service.KlApiService;
import io.swagger.annotations.Api;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@Slf4j
@Api(description = "管易商品库存管理")
public class GyStockController {

    @Autowired
    private SyncGoodsService syncGoodsService;


    /**
     * 获取管易所有考拉仓商品
     * @return
     */
    @RequestMapping(value = "/gy/goods/sync", method = RequestMethod.GET)
    public String gyGoodsSync(@RequestParam String warehouseCode) {
        try {
            if(StringUtils.isEmpty(warehouseCode)){
                return JSON.toJSONString(ResultBase.Fail(-1, "请输入仓库代码", ""));
            }
            syncGoodsService.goodsSync(warehouseCode);
            return  JSON.toJSONString(ResultBase.Success("success"));
        }catch (Exception e){
            return JSON.toJSONString(ResultBase.Fail(-2, "", e.getMessage()));
        }
    }



}
