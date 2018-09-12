package com.gysync.kaola.entity.kl.resp;

import lombok.Data;

@Data
public class KlOrderGoods {

    private long goodsId;
    private String skuId;
    private KlSku sku;
    private long warehouseId;
    private double goodsUnitPriceWithoutTax;
    private double goodsTaxAmount;
    private double goodsPayAmount;
    private int goodsBuyNumber;
    private String imageUrl;
    private double composeTaxRate;

}
