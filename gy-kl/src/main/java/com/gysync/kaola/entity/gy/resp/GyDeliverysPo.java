package com.gysync.kaola.entity.gy.resp;

import com.alibaba.fastjson.JSONObject;
import com.gysync.kaola.entity.kl.resp.KlOrderConfirmResp;
import lombok.Data;
import org.springframework.util.CollectionUtils;
import org.springframework.util.StringUtils;

import java.util.List;

@Data
public class GyDeliverysPo {

    private String create_date;
    private String modify_date;
    private String code;
    private int qty;
    private double amount;
    private double payment;
    private String pay_time;
    private boolean cod;
    private int refund;
    private String invoiceDate;
    private String bigchar;
    private int cancel;
    private String platform_code;
    private double unpaid_amount;
    private double post_fee;
    private double cod_fee;
    private double discount_fee;
    private double post_cost;
    private String plan_delivery_date;
    private String buyer_memo;
    private String seller_memo;
    private String receiver_name;
    private String receiver_phone;
    private String receiver_mobile;
    private String receiver_zip;
    private String receiver_address;
    private String create_name;
    private String express_no;
    private String vip_name;
    private String shop_name;
    private String area_name;
    private String warehouse_name;
    private String express_code;
    private String express_name;
    private String tag_name;
    private String seller_memo_late;
    private String shelf_no;
    private List<GyDeliverysDetail> details;
    private GyDeliverysStatusInfo delivery_statusInfo;
    private List<JSONObject> invoices;
    private String vip_code;
    private String warehouse_code;
    private String shop_code;
    private String vip_real_name;
    private String vip_id_card;
    private String package_center_code;
    private String package_center_name;
    private int sync_status;
    private String sync_memo;

    public static KlOrderConfirmResp isValidated(GyDeliverysPo po){
        KlOrderConfirmResp errorResp = new KlOrderConfirmResp();
        errorResp.setRecCode(-10000);
        if(StringUtils.isEmpty(po.getPlatform_code())) {
            errorResp.setRecMeg("本地校验失败-发货单号为空");
            return errorResp;
        }
        if(StringUtils.isEmpty(po.getArea_name())) {
            errorResp.setRecMeg("本地校验失败-地区信息为空："+po.getArea_name());
            return errorResp;
        }
        String[] ares = po.getArea_name().split("-");
        if(ares.length < 3) {
            errorResp.setRecMeg("本地校验失败-地区信息格式错误："+po.getArea_name());
            return errorResp;
        }
        if(StringUtils.isEmpty(po.getReceiver_name())) {
            errorResp.setRecMeg("本地校验失败-姓名为空");
            return errorResp;
        }
        if(StringUtils.isEmpty(po.getReceiver_mobile())){
            errorResp.setRecMeg("本地校验失败-手机号空");
            return errorResp;
        }
        if(CollectionUtils.isEmpty(po.getDetails())) {
            errorResp.setRecMeg("本地校验失败-详细地址空");
            return errorResp;
        }
        errorResp.setRecCode(200);
        return errorResp;
    }

}
