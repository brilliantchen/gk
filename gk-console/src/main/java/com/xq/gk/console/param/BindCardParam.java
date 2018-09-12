package com.xq.gk.console.param;

import java.util.LinkedList;
import lombok.Data;

@Data
public class BindCardParam {

  private LinkedList<String> cardNumber;

  private String batchNo;

  private String mobile;

  private String password;

  private String operator;
}
