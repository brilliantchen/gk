package com.gysync.kaola.entity.po;

import java.util.Date;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;
import lombok.Data;

@Data
@Entity
@Table(name = "demopo")
public class DemoPO {

    @Id
    @GeneratedValue
    private Long id;
    private String name;
    private String code;

    private Date createTime;
    @Column(name="update_time")
    private Date updateTime;

}
