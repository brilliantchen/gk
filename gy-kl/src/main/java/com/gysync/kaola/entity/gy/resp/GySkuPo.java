package com.gysync.kaola.entity.gy.resp;

import lombok.Data;

@Data
public class GySkuPo {

    private long id;
    private String code;
    private String name;
    private String note;
    private int order;
    private double weight;
    private double volume;
    private double package_point;
    private double sales_point;
    private double sales_price;
    private double purchase_price;
    private double agent_price;
    private double cost_price;
    private String stock_status_code;
    private String bar_code;
    private String tax_no;
    private double tax_rate;
    private String origin_area;
    private String supplier_outerid;

}
