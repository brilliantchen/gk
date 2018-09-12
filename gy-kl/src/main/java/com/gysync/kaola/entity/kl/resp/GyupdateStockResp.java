package com.gysync.kaola.entity.kl.resp;

import com.gysync.kaola.entity.gy.resp.GyBaseResp;
import lombok.Data;

import java.util.List;

@Data
public class GyupdateStockResp extends GyBaseResp {
    private String code;
    private List<String> detailErrorList;
}
