package com.xq.gk.console.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;


@Controller
@Slf4j
@RequestMapping(value = "/supplier")
public class SupplierController {


    /*@RequestMapping(value = "/page", method = RequestMethod.GET)
    public ModelAndView page(){

        ModelAndView modelAndView = new ModelAndView("/farm/supplier_list");
        modelAndView.addObject("typeMap", SupplierType.getAllSupplierType());
        return modelAndView;
    }

    @RequestMapping(value = "/add", method = RequestMethod.POST)
    @ResponseBody
    public ResultBase<Boolean> add(SupplierDomain supplierDomain){
        return supplierService.add(supplierDomain);
    }

    @RequestMapping(value = "/update", method = RequestMethod.POST)
    @ResponseBody
    public ResultBase<Boolean> update(SupplierDomain supplierDomain){
        return supplierService.update(supplierDomain);
    }

    @RequestMapping(value = "/del/{id}", method = RequestMethod.DELETE)
    @ResponseBody
    public ResultBase<Boolean> del(@PathVariable String id){
        return supplierService.del(id);
    }

    @RequestMapping(value = "/query/{id}", method = RequestMethod.GET)
    @ResponseBody
    public ResultBase<SupplierDomain> query(@PathVariable String id){
        return supplierService.query(id);
    }

    @RequestMapping(value = "/list", method = RequestMethod.GET)
    @ResponseBody
    public ResultBase<Page<SupplierDomain>> list(SupplierPaging supplierPaging){
        return supplierService.list(supplierPaging);
    }*/
}
