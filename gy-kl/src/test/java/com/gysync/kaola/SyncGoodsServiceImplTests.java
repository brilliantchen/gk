package com.gysync.kaola;

import com.gysync.kaola.dao.GyStockPoDao;
import com.gysync.kaola.service.GyApiService;
import com.gysync.kaola.service.KlApiService;
import com.gysync.kaola.service.impl.SyncGoodsServiceImpl;
import lombok.extern.slf4j.Slf4j;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.boot.test.mock.mockito.SpyBean;
import org.springframework.test.context.junit4.SpringRunner;

@RunWith(SpringRunner.class)
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@Slf4j
public class SyncGoodsServiceImplTests {

    @InjectMocks
    private SyncGoodsServiceImpl syncGoodsServiceImpl;
    @SpyBean
    private GyApiService gyApiService;
    @MockBean
    private KlApiService klApiService;
    @MockBean
    private GyStockPoDao gyStockPoDao;




}
