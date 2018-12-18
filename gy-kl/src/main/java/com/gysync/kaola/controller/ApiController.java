package com.gysync.kaola.controller;

import com.gysync.kaola.dao.OrderErrorDao;
import com.gysync.kaola.entity.ResultBase;
import com.gysync.kaola.entity.page.PageResult;
import com.gysync.kaola.entity.param.OrderErrorParam;
import com.gysync.kaola.entity.po.OrderErrorPo;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;
import java.util.List;

@RestController
@Slf4j
public class ApiController {

    @Autowired
    private OrderErrorDao orderErrorDao;
    @PersistenceContext
    private EntityManager em;

    @RequestMapping(value = "/api/order/error", method = RequestMethod.POST)
    public PageResult<OrderErrorPo> getOrderError(@RequestBody OrderErrorParam param) {
        try {
            //Sort sort = new Sort(Sort.Direction.DESC,"createTime"); //创建时间降序排序
            Pageable pageable = new PageRequest(param.getStart()/param.getLength(),param.getLength());
            // Page<OrderErrorPo> pages = orderErrorDao.findAll(pageable);
            String whereSql = " where 1 = 1 ";
            if(param.getErrorType() == 1){
                whereSql += "and kl_confirm_error is not null ";

            }else if(param.getErrorType() == 2){
                whereSql += "and kl_pay_error is not null ";
            }else if(param.getErrorType() == 9){
                whereSql += "and (kl_cancel_error is not null or gy_sync_express_error is not null or gy_whous_error is not null or gy_print_express_error is not null) ";
            }
            if(!StringUtils.isEmpty(param.getOrderId())){
                whereSql += "and order_id  like '"+param.getOrderId()+"%' ";
            }
            if(!StringUtils.isEmpty(param.getThirdPartyId())){
                whereSql += "and third_party_id  like '"+param.getThirdPartyId()+"%' ";
            }

            Query queryCount = em.createNativeQuery("select count(1) from ORDER_ERROR_PO"+whereSql);
            Object rs =  queryCount.getSingleResult();
            Long count = Long.valueOf(String.valueOf(rs));
            String limitStr = " limit "+String.valueOf(param.getStart()) +","+String.valueOf(param.getLength());
            Query queryList = em.createNativeQuery("select * from ORDER_ERROR_PO"+whereSql+limitStr, OrderErrorPo.class);
            List<OrderErrorPo> list = queryList.getResultList();

            PageResult<OrderErrorPo> pageResult = new PageResult<OrderErrorPo>();
            pageResult.setDraw(param.getDraw());
            pageResult.setRecordsTotal(Long.valueOf(count));
            pageResult.setRecordsFiltered(Long.valueOf(count));
            pageResult.setData(list);
            return pageResult;

        }catch (Exception e){
            return null;
        }
    }

    @RequestMapping(value = "/api/order/error/{orderId}/del", method = RequestMethod.GET)
    public ResultBase<String> delOrderError(@PathVariable String orderId) {
        try {
            orderErrorDao.delete(orderId);
            return ResultBase.Success(orderId);
        }catch (Exception e){
            return ResultBase.Fail(orderId);
        }
    }




}
