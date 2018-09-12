package com.gysync.kaola.entity.po;

import lombok.Data;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;
import java.util.Date;

@Data
@Entity
@Table(name = "OrderKlCancelPo")
public class OrderKlCancelPo {

    @Id
    @GeneratedValue
    private Long id;
    private String orderId;
    private String rs;
    private Date createTime = new Date();
    private Date updateTime = new Date();

}
