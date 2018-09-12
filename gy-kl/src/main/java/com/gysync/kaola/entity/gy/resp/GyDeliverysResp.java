package com.gysync.kaola.entity.gy.resp;

import lombok.Data;

import java.util.List;

@Data
public class GyDeliverysResp extends GyBaseResp {

    private List<GyDeliverysPo> deliverys;

    private int total;



}

