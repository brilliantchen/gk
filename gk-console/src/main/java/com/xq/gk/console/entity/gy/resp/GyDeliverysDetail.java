package com.xq.gk.console.entity.gy.resp;

import lombok.Data;

import java.util.List;

@Data
public class GyDeliverysDetail {

    private int qty;
    private double price;
    private double amount;
    private int refund;
    private String memo;
    private String picUrl;
    private String trade_code;
    private int origin_price;
    private String item_id;
    private String item_sku_id;
    private String item_code;
    private String item_name;
    private String sku_code;
    private String sku_name;
    private String sku_note;
    private String platform_code;
    private int discount_fee;
    private int amount_after;
    private int post_fee;
    private int post_cost;
    private double tax_rate;
    private double tax_amount;
    private String order_type;
    private int platform_flag;
    private List<String> detail_unique;
    private String detail_batch;
    private int is_gift;
    private String businessman_name;
    private String item_add_attribute;

}
