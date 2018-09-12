package com.gysync.kaola.entity.po;

import lombok.Data;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;
import java.util.Date;

@Data
@Entity
@Table(name = "OrderKlPayPo")
public class OrderKlPayPo {

    @Id
    @GeneratedValue
    private Long id;
    private String klOrderId;
    private String orderId;
    private int klOrderSize;
    private double klOrderAmount;
    private boolean klOrderPay;
    private int klOrderStatus;
    private String rs;
    private Date createTime = new Date();
    private Date updateTime = new Date();

}
