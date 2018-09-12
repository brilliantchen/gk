package com.gysync.kaola.controller;

import com.gysync.kaola.entity.ResultBase;
import com.gysync.kaola.dao.OrderErrorDao;
import com.gysync.kaola.entity.page.PageResult;
import com.gysync.kaola.entity.param.OrderErrorParam;
import com.gysync.kaola.entity.po.OrderErrorPo;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.web.bind.annotation.*;

@RestController
@Slf4j
public class ApiController {

    @Autowired
    private OrderErrorDao orderErrorDao;

    @RequestMapping(value = "/api/order/error", method = RequestMethod.POST)
    public PageResult<OrderErrorPo> getOrderError(@RequestBody OrderErrorParam param) {
        try {
            //Sort sort = new Sort(Sort.Direction.DESC,"createTime"); //创建时间降序排序
            Pageable pageable = new PageRequest(param.getStart()/param.getLength(),param.getLength());
            Page<OrderErrorPo> pages = orderErrorDao.findAll(pageable);

            PageResult<OrderErrorPo> pageResult = new PageResult<OrderErrorPo>();
            pageResult.setDraw(param.getDraw());
            pageResult.setRecordsTotal(pages.getTotalElements());
            pageResult.setRecordsFiltered(pages.getTotalElements());
            pageResult.setData(pages.getContent());
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
