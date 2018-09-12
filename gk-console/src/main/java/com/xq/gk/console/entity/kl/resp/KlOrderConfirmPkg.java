package com.xq.gk.console.entity.kl.resp;

import lombok.Data;

import java.util.List;

@Data
public class KlOrderConfirmPkg {

    private double payAmount;
    private double taxPayAmount;
    private double logisticsPayAmount;
    private int importType;
    private int needVerifyLevel; //level=0,无需实名；level=1，需真实姓名和证件号；level=2，需真实姓名+证件号+证件正反照片
    private int packageOrder;
    private KlOrderWarehouse warehouse;
    private List<KlOrderGoods> goodsList;
    private String goodsSource;

}
