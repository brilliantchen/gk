package com.gysync.kaola.entity.kl.resp;

import lombok.Data;

@Data
public class KlOrderPayPo {

    private String id;
    // 实际支付金额
    private double gpayAmount;
    private double originalGpayAmount;
    private double gorderAmount;
    private String goodsName;
    private int gorderStatus;

}
