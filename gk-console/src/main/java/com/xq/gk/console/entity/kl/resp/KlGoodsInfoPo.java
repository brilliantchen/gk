package com.xq.gk.console.entity.kl.resp;

import lombok.Data;

@Data
public class KlGoodsInfoPo {

    private long goodsId;
    private KlGoodsWearHouse recommandStore;
    private double marketPrice;
    private double price;
    private long store;
    private double suggestPrice;
    private KlGoodsWearHouse warehouseStores;
    private int onlineStatus;
    private long productId;
    private String taxFees;
    private String afterTaxPrice;
    private int isFreeTax;
    private int isPresell;
    private int isFreeShipping;
    private int memberCount;
    private String skuId;

}
