package com.xq.gk.console.entity.gy.resp;

import lombok.Data;

@Data
public class GyDeliverysStatusInfo {

    private boolean scan;
    private boolean weight;
    private int wms;
    private int delivery;
    private boolean cancel;
    private boolean intercept;
    private boolean print_express;
    private String express_print_name;
    private String express_print_date;
    private boolean print_delivery;
    private String delivery_print_name;
    private String delivery_print_date;
    private String scan_name;
    private String scan_date;
    private String weight_name;
    private String weight_date;
    private int wms_order;
    private String delivery_name;
    private String delivery_date;
    private String cancel_name;
    private String cancel_date;
    private String weight_qty;
    private int thermal_print;
    private int thermal_print_status;
    private String picking_user;
    private String picking_date;
    private double standard_weight;
    private boolean pick_finish;

}
