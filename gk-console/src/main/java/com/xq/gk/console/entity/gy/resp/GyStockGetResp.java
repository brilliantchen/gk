package com.xq.gk.console.entity.gy.resp;

import lombok.Data;

import java.util.List;

@Data
public class GyStockGetResp extends GyBaseResp {

    private List<GyStockPo> stocks;
    private int total;

}
