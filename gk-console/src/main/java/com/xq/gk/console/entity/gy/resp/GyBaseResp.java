package com.xq.gk.console.entity.gy.resp;

import lombok.Data;

@Data
public class GyBaseResp {

    protected boolean success;

    protected String errorCode;
    protected String subErrorCode;
    protected String errorDesc;
    protected String subErrorDesc;
    protected String requestMethod;

    public static boolean isSuccecd(GyBaseResp resp){
        if(resp != null && resp.isSuccess()){
            return  true;
        }
        return  false;
    }

}
