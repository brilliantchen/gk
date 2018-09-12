package com.xq.gk.console.entity.kl.resp;

import com.xq.gk.console.entity.gy.resp.GyBaseResp;
import lombok.Data;

import java.util.List;

@Data
public class GyupdateStockResp extends GyBaseResp {
    private String code;
    private List<String> detailErrorList;
}
