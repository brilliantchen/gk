package com.xq.gk.console.entity.gy.resp;

import lombok.Data;


import java.util.Date;

@Data

public class GyStockPo {

    private String barcode;
    private boolean del;
    private int qty;
    private String warehouse_code;
    private String item_code;

    private String sku_code;
    private int salable_qty;
    private int road_qty;
    private int pick_qty;
    private String item_name;
    private String item_sku_name;
    private String warehouse_name;

    // ------------------add for kaola
    // 考拉供货价
    private double klprice;
    private long klgoodsId;
    private long klstore;
    private int klonlineStatus; //0:下架不可卖，1：上架可卖
    private Date update_time = new Date();

}
