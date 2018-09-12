package com.gysync.kaola.entity.enu;

public enum OrderStatus {

    INIT_SYNC(100, "初始状态"),
    CONFIRMED(200, "确认可下单"),
    PAYED(300, "下单并支付成功"),
    DELIVERYED(400, "订单已发货"),
    SUCCESS(1000, "交易成功"),
    PAYED_SEND_FAILED(1100, "订单交易失败（用户支付后不能发货）"),
    OTHER(10000, "其他");

    private int code;
    private String desc;

    OrderStatus(int code, String desc) {
        this.code = code;
        this.desc = desc;
    }

    public int getCode() {
        return code;
    }

    public String getDesc() {
        return desc;
    }

    public static String getDescByCode(int code) {
        for (OrderStatus item : OrderStatus.values()) {
            if (item.getCode() == code) {
                return item.getDesc();
            }
        }
        return null;
    }

}
