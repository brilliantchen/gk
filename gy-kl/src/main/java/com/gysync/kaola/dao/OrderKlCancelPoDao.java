package com.gysync.kaola.dao;

import com.gysync.kaola.entity.po.OrderKlCancelPo;
import com.gysync.kaola.entity.po.OrderKlPayPo;
import org.springframework.data.jpa.repository.JpaRepository;

public interface OrderKlCancelPoDao extends JpaRepository<OrderKlCancelPo, Long> {


}
