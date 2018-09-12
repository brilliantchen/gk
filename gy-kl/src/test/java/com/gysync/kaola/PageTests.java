package com.gysync.kaola;

import com.gysync.kaola.dao.OrderErrorDao;
import com.gysync.kaola.entity.page.PageResult;
import com.gysync.kaola.entity.param.OrderErrorParam;
import com.gysync.kaola.entity.po.OrderErrorPo;
import lombok.extern.slf4j.Slf4j;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.test.context.junit4.SpringRunner;

@RunWith(SpringRunner.class)
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@Slf4j
public class PageTests {

    @Autowired
    private OrderErrorDao orderErrorDao;

    @Test
    public void orderError() {
        OrderErrorPo po = new OrderErrorPo();
        po.setOrderId("111");
        orderErrorDao.save(po);

        OrderErrorParam param = new OrderErrorParam();
        param.setStart(0);
        param.setLength(10);
        //Sort sort = new Sort(Sort.Direction.DESC,"createTime"); //创建时间降序排序
        Pageable pageable = new PageRequest(param.getStart(),param.getLength());
        Page<OrderErrorPo> pages = orderErrorDao.findAll(pageable);
        System.out.println(pages);
        PageResult<OrderErrorPo> pageResult = new PageResult<OrderErrorPo>();
        pageResult.setDraw(param.getDraw());
        pageResult.setRecordsTotal(pages.getTotalElements());
        pageResult.setRecordsFiltered(pages.getTotalElements());
        pageResult.setData(pages.getContent());
        System.out.println(pageResult);
    }


}
