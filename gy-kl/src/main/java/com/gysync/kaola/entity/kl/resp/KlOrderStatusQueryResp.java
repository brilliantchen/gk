package com.gysync.kaola.entity.kl.resp;

import com.alibaba.fastjson.JSONObject;
import lombok.Data;

import java.util.List;

@Data
public class KlOrderStatusQueryResp extends KlBaseResp {

    private String gorderId;
    private List<KlOrderStatusResult> result;
    private double gpayAmount;
    private double totalOverseaLogisticsAmount;
    private double totalServiceFee;
    private double logisticsTaxAmount;
    private JSONObject trackLogistics;
    private double totalChinaLogisticsAmount;
    private double totalTaxAmount;
    private int gorderStatus;

}
