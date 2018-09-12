package com.xq.gk.console.entity.po;

import lombok.Data;

import java.util.Date;

@Data
public class OrderErrorPo {

    private String orderId; //  使用管易发货单号code
    private String thirdPartyId; //  品台单号
    private String validateError;  // 本地校验失败
    private String klConfirmError;  // 考拉确认失败
    private String klPayError;  // 考拉支付失败
    private String gyWhousError;  //  管易转入外仓失败
    private String klQueryError;  // 考拉查询失败
    private String gyPrintExpressError;  //  管易物流打单失败
    private String gySyncExpressError;  //  管易同步物流失败

    private String klCancelError;  // 考拉取消失败


    private Date createTime = new Date();
    private Date updateTime = new Date();

}
