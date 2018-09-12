package com.gysync.kaola.entity;

import lombok.Data;

import java.io.Serializable;

@Data
public class ResultBase<T> implements Serializable {

    private String respMsg;

    private int respCode;

    private T content;

    public ResultBase() {
        this.respCode = 0;
        this.respMsg = "";
    }

    public ResultBase(T content) {
        this.respCode = 0;
        this.respMsg = "";
        this.content = content;
    }

    public ResultBase(int respCode, String respMsg) {
        super();
        this.respCode = respCode;
        this.respMsg = respMsg;
    }

    public ResultBase(int respCode, String respMsg, T data) {
        super();
        this.respCode = respCode;
        this.respMsg = respMsg;
        this.content = data;
    }

    public static <T> ResultBase<T> Success(T data) {
        return new ResultBase(200,  "", data);
    }
    public static <T> ResultBase<T> Fail(int respCode, String respMsg, T data) {
        return new ResultBase(respCode,  respMsg, data);
    }

    public static <T> ResultBase<T>  Fail(T data){
        return new ResultBase(-1,  "系统异常：", data);
    }

    public static boolean isSucceed(ResultBase rs){
        if(rs != null && 200== rs.respCode){
            return true;
        }
        return false;
    }



}
