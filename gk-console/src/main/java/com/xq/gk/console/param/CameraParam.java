package com.xq.gk.console.param;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class CameraParam {
    // 组长ID
    private String groupId;

    // 分页参数
    private int pageNo;

    // 分页参数
    private int pageSize;

    // 记录ID
    private String id;
    // 养殖场ID
    private String farmCode;

    // 摄像头名称
    private String cameraName;

    private String address;

    private String desc;

    private String configId;

    private int configStatus;
}
