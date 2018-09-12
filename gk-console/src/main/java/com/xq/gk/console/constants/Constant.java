package com.xq.gk.console.constants;

import java.util.HashMap;
import java.util.Map;

public class Constant {
    public static final Map<String, String> roleMap = new HashMap<>();
    static {
        roleMap.put("100", "超级管理员");
        roleMap.put("10", "养殖户");
        roleMap.put("20", "操作员");
        roleMap.put("30", "政府机构");
        roleMap.put("40", "公益组织");
        roleMap.put("50", "个人");
        roleMap.put("60", "企业");
        roleMap.put("70", "运营");
        roleMap.put("80", "运营管理");
        roleMap.put("300", "测试");
    }
}
