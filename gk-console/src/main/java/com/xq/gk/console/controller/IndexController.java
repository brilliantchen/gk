package com.xq.gk.console.controller;

import com.xq.gk.console.comm.Constant;
import com.xq.gk.console.entity.po.UserInfo;
import com.xq.gk.console.param.LoginParam;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.PostConstruct;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;


@Controller
@Slf4j
public class IndexController {

    private Map<String, UserInfo> users = new HashMap<>();

    @PostConstruct
    public void post(){
        users.put("kaola001", new UserInfo("kaola001","kaola001"));
        users.put("kaola002", new UserInfo("kaola002","kaola002"));
    }


    @RequestMapping("/")
    public ModelAndView home(HttpServletRequest request) {
        return new ModelAndView("index");
    }

    @RequestMapping("/index")
    public ModelAndView index(HttpServletRequest request) {
        return home(request);
    }

    @RequestMapping("/login")
    public ModelAndView login() {
        return new ModelAndView("login");
    }

    @RequestMapping("/loginVefify")
    public ModelAndView loginVefify(LoginParam loginParam, HttpServletRequest request, HttpSession session) {
        if(loginParam != null && users.get(loginParam.getUsername()) != null
                && users.get(loginParam.getUsername()).getPassword().equals(loginParam.getPassword())){
            session.setAttribute(Constant.SESSION_KEY,  users.get(loginParam.getUsername()));
            return new ModelAndView("index");
        } else {
            return new ModelAndView("redirect:/login");
        }
    }



}
