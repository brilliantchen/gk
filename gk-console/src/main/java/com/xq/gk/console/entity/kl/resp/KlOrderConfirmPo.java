package com.xq.gk.console.entity.kl.resp;

import lombok.Data;

import java.util.List;

@Data
public class KlOrderConfirmPo {

    private double orderAmount;
    private double payAmount;
    private double taxPayAmount;
    private double logisticsPayAmount;
    private int needVerifyLevel;
    private long orderCloseTime;
    private List<KlOrderConfirmPkg> packageList;

}
