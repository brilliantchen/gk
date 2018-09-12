package com.gysync.kaola.controller;

import com.alibaba.fastjson.JSON;
import com.gysync.kaola.dao.*;
import com.gysync.kaola.entity.gy.resp.GyStockPo;
import com.gysync.kaola.entity.kl.resp.KlBaseResp;
import com.gysync.kaola.entity.kl.resp.KlOrderConfirmResp;
import com.gysync.kaola.entity.kl.resp.KlOrderPayResp;
import com.gysync.kaola.entity.po.*;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import java.util.Date;
import java.util.List;

@RestController
@Slf4j
public class HealthController {

    @Value("${demo.env:default}")
    private String env;

    @GetMapping(value = "/health")
    public String health() {
        log.info(env);
        return "health:" + env;
    }

    @Autowired
    private DemoRepository demoRepository;
    @Autowired
    private OrderPoDao orderPoDao;
    @Autowired
    private OrderKlConfirmPoDao orderKlConfirmPoDao;
    @Autowired
    private OrderKlPayPoDao orderKlPayPoDao;
    @Autowired
    private OrderKlCancelPoDao orderKlCancelPoDao;
    @Autowired
    private GyStockPoDao gyStockPoDao;
    @Autowired
    private OrderErrorDao orderErroDao;

    @RequestMapping(value = "/test/db", method = RequestMethod.GET)
    public String mocksql() {

        DemoPO demo = new DemoPO();
        demo.setCode("00001");
        demo.setName("demo");
        demo.setCreateTime(new Date());
        demoRepository.save(demo);
        List<DemoPO> list1 = demoRepository.findBySql();
        List<DemoPO> list2 = demoRepository.findByCuster(1l);
        List<DemoPO> list3 = demoRepository.findBySql(0,2);
        int rows = demoRepository.updateBySql(1l);

        return "";
    }

    @RequestMapping(value = "/db/init", method = RequestMethod.GET)
    public String dbinit(String orderId) {
        if(StringUtils.isEmpty(orderId)){
            return "null";
        }
        initdb(String.valueOf(orderId));
        return  "ok";
    }

    @RequestMapping(value = "/db/big", method = RequestMethod.GET)
    public String dbbig(String orderId) {
        if(StringUtils.isEmpty(orderId)){
            return "null";
        }
        int start = Integer.valueOf(orderId);
        /*int end = Integer.valueOf(orderId) + 10000000;
        for (int i = start; i<end; i++){
            log.info("==="+ i);
            initdb(String.valueOf(i));
        }*/
        return  "ok";
    }

    private void initdb(String orderId){
        OrderPo orderPo = new OrderPo();
        orderPo.setOrderId(orderId);
        orderPoDao.save(orderPo);

        OrderKlConfirmPo orderKlConfirmPo = new OrderKlConfirmPo();
        orderKlConfirmPo.setOrderId(orderId);
        orderKlConfirmPo.setRs(JSON.toJSONString(new KlOrderConfirmResp()));
        orderKlConfirmPoDao.save(orderKlConfirmPo);

        OrderKlPayPo orderKlPayPo = new OrderKlPayPo();
        orderKlPayPo.setOrderId(orderId);
        orderKlPayPo.setRs(JSON.toJSONString(new KlOrderPayResp()));
        orderKlPayPoDao.save(orderKlPayPo);

        OrderKlCancelPo orderKlCancelPo = new OrderKlCancelPo();
        orderKlCancelPo.setOrderId(orderId);
        orderKlCancelPo.setRs(JSON.toJSONString(new KlBaseResp()));
        orderKlCancelPoDao.save(orderKlCancelPo);

        OrderErrorPo errorPo = new OrderErrorPo();
        errorPo.setOrderId(orderId);
        orderErroDao.save(errorPo);

        GyStockPo gyStockPo = gyStockPoDao.findOne("0");
        if(null == gyStockPo){
            gyStockPo = new GyStockPo();
            gyStockPo.setSku_code("0");
            gyStockPo.setItem_code("0");
            gyStockPo.setWarehouse_code("0");
            gyStockPo.setQty(100);
            gyStockPoDao.save(gyStockPo);
        }

    }
}
