package com.xq.gk.console.enums;

import lombok.Getter;

/**
 * @author za-huwei
 * @date 2017/12/15
 */
@Getter
public enum BindDevice {

    YES(1, "是"),
    NO(2, "否");

    private int code;
    private String desc;

    BindDevice(int code, String desc){
        this.code = code;
        this.desc = desc;
    }
}
