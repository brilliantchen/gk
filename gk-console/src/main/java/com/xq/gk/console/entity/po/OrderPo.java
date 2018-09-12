package com.xq.gk.console.entity.po;

import lombok.Data;

import java.util.Date;

@Data
public class OrderPo {

    private String orderId; //  使用管易发货单号code
    private String thirdPartOrderId;  //
    private String receiverName;
    private String mobile;
    private String realName;
    private String realCard;
    private int orderItemSize;
    private String areaMame;
    private String address;
    private double gyAmount;

    private int gySyncStatus; // 管易发货单同步状态 -1:同步失败 0:未同步 1:已同步
    private int gyEpressStatus; // 管易发货单同步状态 -1:同步失败 0:未同步 1:已同步

    // for cofirm
    private int klOrderConform; // 0 未  1成功 -1失败
    private int klOrderSize;
    private int klVerifylevel; //level=0,无需实名；level=1，需真实姓名和证件号；level=2，需真实姓名+证件号+证件正反照片
    // for pay 针对单个订单有效
    private String klOrderId;
    private int klOrderPay; // 0 未  1成功 -1失败
    private double klAmount;

    private int klDelivery; // 0 未  1成功 -1失败
    // for 取消状态
    private int klCancelStatus; // 0 初始  1取消成功 -1取消失败
    private int cancelTimes; // 0取消次数，失败重试限制3次

    // for 状态同步
    /*1, "订单同步成功（等待支付）"
    2, "订单支付成功（等待发货）"
    3, "订单支付失败"
    4, "订单已发货"
    5,"交易成功"
    6, "订单交易失败（用户支付后不能发货）【最终状态】"
    7, "订单关闭"
    8, "退款成功"(分销走线下不做更新)
    9, "退款失败"(分销走线下不做更新)
    0, "订单同步失败"
     */
    private int klOrderStatus; // 考拉订单状态，查询接口返回


    private Date createTime = new Date();
    private Date updateTime = new Date();


}
