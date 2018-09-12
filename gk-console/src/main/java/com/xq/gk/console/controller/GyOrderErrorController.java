package com.xq.gk.console.controller;

import com.xq.gk.console.client.GksClient;
import com.xq.gk.console.entity.ResultBase;
import com.xq.gk.console.entity.paging.PageResult;
import com.xq.gk.console.entity.param.OrderErrorParam;
import com.xq.gk.console.entity.po.OrderErrorPo;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

@RestController
@Slf4j
@RequestMapping(value = "/gk")
public class GyOrderErrorController {

    @Autowired
    private GksClient gksClient;

    @RequestMapping(value = "/gy/order/error/page", method = RequestMethod.GET)
    public ModelAndView getOrderErrorPage() {
        return new ModelAndView("/gy/gy_order_error");
    }

    @RequestMapping(value = "/gy/order/error/list", method = RequestMethod.POST)
    public PageResult<OrderErrorPo> getOrderError(OrderErrorParam param) {
        try {
            PageResult<OrderErrorPo> rs = gksClient.getOrderError(param);
            return rs;
        }catch (Exception e){
            log.error("error:", e);
            return new PageResult();
        }
    }

    @RequestMapping(value = "/gy/order/error/{orderId}/del", method = RequestMethod.GET)
    public ResultBase<String> delOrderError(@PathVariable String orderId){
        try {
            return gksClient.delOrderError(orderId);
        }catch (Exception e){
            return ResultBase.Fail(e.getMessage());
        }
    }
}
