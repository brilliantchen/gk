package com.gysync.kaola.entity.gy.param;

import lombok.Data;

@Data
public class GyBaseParam {

    /**
     * 租户appkey
     */
    protected String appkey;
    /**
     * 租户sessionkey
     */
    protected String sessionkey;
    /**
     * 接口名称
     */
    protected String method;
    /**
     * 签名
     */
    protected String sign;

}
