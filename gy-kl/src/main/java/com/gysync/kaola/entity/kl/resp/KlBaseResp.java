package com.gysync.kaola.entity.kl.resp;

import com.gysync.kaola.entity.gy.resp.GyBaseResp;
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
