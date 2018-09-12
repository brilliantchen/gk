package com.xq.gk.console.param;

import lombok.Getter;
import lombok.Setter;

/**
 * Created by za-zhouhui on 2017/5/9.
 */
@Setter
@Getter
public class BaseParam {
    //组长ID
    private String groupId;

    //分页参数
    private int pageNo;

    //分页参数
    private int pageSize;

    //记录ID
    private String id;
}
