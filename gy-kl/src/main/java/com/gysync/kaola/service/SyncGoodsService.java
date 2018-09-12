package com.gysync.kaola.service;

public interface SyncGoodsService {

    public long goodsSync(String warehouseCode);
    public void stockSync(String warehouseCode);

}
