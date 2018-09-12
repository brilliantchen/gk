package com.xq.gk.console;

import lombok.extern.slf4j.Slf4j;
import org.junit.Before;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.RequestBuilder;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

/**
 * BaseTests.java的实现描述：
 *
 * @author za-qixiaochen 2017年9月1日 下午2:24:38
 */
@RunWith(SpringRunner.class)
@Slf4j
public class BaseTests {

  private final static String authKey = "Authorization";
  private final static String authValue = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1aWQiOiIxMzEyMDkyMDQ2NSIsImlzcyI6Imh0dHA6Ly93d3cuemhvbmdhbi5jb20vIiwiZXhwIjoxNTEwOTA1NTA4LCJpYXQiOjE1MDgzMTM1MDgsImp0aSI6IjBlZDEzMDBkLTNiYmYtNDkwZC04MWM0LTkzODg4NzViYjFiNyJ9.dnIZtso8Q_bkQAflSNpbUVTjcFdBcQeS_dso-3vGyf8";

  private MockMvc mockMvc;

  @Autowired
  private WebApplicationContext wac;

  @Before
  public void setup() {
    mockMvc = MockMvcBuilders.webAppContextSetup(wac).build();
    // mockMvc = MockMvcBuilders.standaloneSteup(userController).build();
  }

  protected void doPost(String uri, String params) throws Exception {
    log.info(params);
    RequestBuilder request = MockMvcRequestBuilders.post(uri)
        .accept(MediaType.APPLICATION_JSON).content(params)
        .contentType(MediaType.APPLICATION_JSON_UTF8)
        .header(authKey, authValue);
    MvcResult mvcResult = mockMvc.perform(request).andReturn();
    System.out.println("返回结果：" + mvcResult.getResponse().getStatus());
    System.out.println(mvcResult.getResponse().getContentAsString());
  }

  protected void doPut(String uri, String params) throws Exception {
    log.info(params);
    RequestBuilder request = MockMvcRequestBuilders.put(uri)
        .accept(MediaType.APPLICATION_JSON).content(params)
        .contentType(MediaType.APPLICATION_JSON_UTF8)
        .header(authKey, authValue);
    MvcResult mvcResult = mockMvc.perform(request).andReturn();
    System.out.println("返回结果：" + mvcResult.getResponse().getStatus());
    System.out.println(mvcResult.getResponse().getContentAsString());
  }

  protected void doGet(String uri, String params) throws Exception {
    log.info(params);
    RequestBuilder request = MockMvcRequestBuilders.get(uri)
        .accept(MediaType.APPLICATION_JSON).content(params)
        .contentType(MediaType.APPLICATION_JSON_UTF8)
        .header(authKey, authValue);
    MvcResult mvcResult = mockMvc.perform(request).andReturn();
    System.out.println("返回结果：" + mvcResult.getResponse().getStatus());
    System.out.println(mvcResult.getResponse().getContentAsString());
  }

  protected void doDelete(String uri, String params) throws Exception {
    log.info(params);
    RequestBuilder request = MockMvcRequestBuilders.delete(uri)
        .accept(MediaType.APPLICATION_JSON).content(params)
        .contentType(MediaType.APPLICATION_JSON_UTF8)
        .header(authKey, authValue);
    MvcResult mvcResult = mockMvc.perform(request).andReturn();
    System.out.println("返回结果：" + mvcResult.getResponse().getStatus());
    System.out.println(mvcResult.getResponse().getContentAsString());
  }

}
