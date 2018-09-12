package com.xq.gk.console.enums;

import lombok.Getter;

import java.util.HashMap;
import java.util.Map;

/**
 * @author za-huwei
 * @date 2017/12/18
 */
@Getter
public enum BaseStationStatus {

    WORK(1, "工作"),
    NOT_WORK(-1, "不工作");

    private int code;
    private String desc;

    BaseStationStatus(int code, String desc){
        this.code = code;
        this.desc = desc;
    }

    public static Map<Integer, String> getStatusMap(){
        Map<Integer, String> map = new HashMap<>();
        for (BaseStationStatus baseStationStatus : BaseStationStatus.values()){
            map.put(baseStationStatus.getCode(), baseStationStatus.getDesc());
        }

        return map;
    }

    public static String getDesc(int code){
        for (BaseStationStatus baseStationStatus : BaseStationStatus.values()){
            if (baseStationStatus.getCode() == code){
                return baseStationStatus.getDesc();
            }
        }

        return null;
    }
}
