package com.xq.gk.console.service;

import com.xq.gk.console.entity.gy.resp.*;
import com.xq.gk.console.entity.kl.resp.GyupdateStockResp;

import java.util.Map;

public interface GyApiService {

    /**
     * 发货单查询（gy.erp.trade.deliverys.get）
     * @return
     */
    public GyDeliverysResp getDeliverys(Map<String, Object> map);

    /**
     * 26	发货单修改（gy.erp.trade.deliverys.update）
     * @return
     */
    public GyDeliveryUpdateResp updateDelivery(Map<String, Object> map);

    /**
     * 24	发货单同步状态批量修改接口（gy.erp.trade.deliverys.syncstatus.update）	50
     * @param map
     */
    public GyBaseResp updateDeliveryStatus(Map<String, Object> map);

    /**
     * 商品查询（gy.erp.items.get） 全量商品使用库存查询
     * @param map
     * @return
     */
    public GyGoodsResp getGoods(Map<String, Object> map);

    /**
     * 新库存查询（gy.erp.new.stock.get）
     * @param map
     * @return
     */
    public GyStockGetResp getStock(Map<String, Object> map);

    //50	盘点单新增并审核（gy.erp.stock.count.add）
    public GyupdateStockResp updateStock(Map<String, Object> map);

}
