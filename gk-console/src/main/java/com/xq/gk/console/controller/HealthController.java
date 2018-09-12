
package com.xq.gk.console.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

/**
 * 类HealthController.java的实现描述：TODO 类实现描述
 *
 * @author za-qixiaochen 2017年5月26日 下午2:08:41
 */
@Controller
public class HealthController {

  @RequestMapping(value = "/health")
  @ResponseBody
  public String health() {
    return "health";
  }

  @RequestMapping(value = "/page401", method = RequestMethod.GET)
  public ModelAndView page401() {
    return new ModelAndView("error");
  }

  @RequestMapping(value = "/page404", method = RequestMethod.GET)
  public ModelAndView page404() {
    return new ModelAndView("404");
  }

  @RequestMapping(value = "/page500", method = RequestMethod.GET)
  public ModelAndView page500() {
    return new ModelAndView("error");
  }

}
