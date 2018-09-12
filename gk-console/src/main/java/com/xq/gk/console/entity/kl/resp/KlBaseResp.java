package com.xq.gk.console.entity.kl.resp;

import lombok.Data;

@Data
public class KlBaseResp {

    private int recCode;
    private int subCode;
    private String recMeg;

    public static boolean isSuccecd(KlBaseResp resp){
        if(resp != null && 200 == resp.getRecCode()){
            return  true;
        }
        return  false;
    }

}
