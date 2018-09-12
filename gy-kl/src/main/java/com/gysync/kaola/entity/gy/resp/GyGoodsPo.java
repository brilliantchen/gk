package com.gysync.kaola.entity.gy.resp;

import com.alibaba.fastjson.JSONObject;
import lombok.Data;

import java.util.List;

@Data
public class GyGoodsPo {
    private long id;
    private String create_date;
    private String modify_date;
    private String code;
    private String name;
    private String note;
    private double weight;
    private boolean combine;
    private boolean del;
    private double length;
    private double width;
    private double height;
    private double volume;
    private String simple_name;
    private String category_code;
    private String category_name;
    private String supplier_code;
    private String item_unit_code;
    private String item_unit_name;
    private double package_point;
    private double sales_point;
    private double sales_price;
    private double purchase_price;
    private double agent_price;
    private double cost_price;
    private String stock_status_code;
    private String pic_url;
    private String tax_no;
    private double tax_rate;
    private String origin_area;
    private String supplier_outerid;
    private int shelf_life;
    private int warning_days;
    private List<GySkuPo> skus;
    private List<String> combine_items;
    private JSONObject custom_attr;
    private int item_add_attribute;
    private String item_brand_id;
    private String item_brand_code;
    private String item_brand_name;
}
