package com.xq.gk.console.entity.kl.resp;

import com.alibaba.fastjson.JSONObject;
import lombok.Data;

import java.util.List;

@Data
public class KlOrderStatusResult {

    private String desc;
    private int status;
    private String limitReason;
    private boolean isLimit;
    private List<JSONObject> skuList;
    private String deliverName; //物流
    private String deliverNo; //运单号
    private String orderId;

}
