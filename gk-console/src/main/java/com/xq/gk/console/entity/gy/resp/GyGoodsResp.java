package com.xq.gk.console.entity.gy.resp;

import lombok.Data;

import java.util.List;

@Data
public class GyGoodsResp extends GyBaseResp {
    private List<GyGoodsPo> items;
    private int total;
}
