package com.gysync.kaola.dao;

import com.gysync.kaola.entity.po.OrderErrorPo;
import com.gysync.kaola.entity.po.OrderPo;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

public interface OrderErrorDao extends JpaRepository<OrderErrorPo, String> {

    /*@Query(value = "SELECT * FROM USERS WHERE ORDER_ID  = ?1",
            countQuery = "SELECT count(*) FROM USERS WHERE ORDER_ID   = ?1",
            nativeQuery = true)
    Page<OrderErrorDao> findByLastname(String orderId, Pageable pageable);*/


}
