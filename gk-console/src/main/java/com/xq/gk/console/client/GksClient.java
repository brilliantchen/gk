package com.xq.gk.console.client;

import com.xq.gk.console.entity.ResultBase;
import com.xq.gk.console.entity.paging.PageResult;
import com.xq.gk.console.entity.param.OrderErrorParam;
import com.xq.gk.console.entity.po.OrderErrorPo;
import org.springframework.cloud.netflix.feign.FeignClient;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@FeignClient(name="gykl", url = "${url.gykl}")
public interface GksClient {

    @RequestMapping(value = "/gks/api/order/error", method = RequestMethod.POST)
    public PageResult<OrderErrorPo> getOrderError(@RequestBody OrderErrorParam param);

    @RequestMapping(value = "/gks/api/order/error/{orderId}/del", method = RequestMethod.GET)
    public ResultBase<String> delOrderError(@PathVariable("orderId") String orderId);

  /*@RequestMapping(value = "/v1/card/generateBatchNo", method = RequestMethod.GET)
  ResultBase<String> generateBatchNo();


  @RequestMapping(value = "/v1/card/queryGenerateCard/{batchNo}", method = RequestMethod.GET)
  ResultBase<GenerateCardVO> queryGenerateCard(@PathVariable("batchNo") String batchNo);

  @RequestMapping(value = "/v1/card/findGenerateCard", method = RequestMethod.POST, consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  PageResult<GenerateCardVO> queryGenerateCard(@RequestBody Pagination pagination);

  @RequestMapping(value = "/v1/card/queryCard", method = RequestMethod.POST, consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  PageResult<CardVO> queryCard(@RequestBody CardParam cardParam);

  @RequestMapping(value = "/v1/card/saveCard", method = RequestMethod.POST, consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  ResultBase<Boolean> saveCard(@RequestBody CardParam cardParam);

  @RequestMapping(value = "/v1/card/bindCard", method = RequestMethod.POST, consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  ResultBase<Boolean> bindCard(@RequestBody CardParam cardParam);

  @RequestMapping(value = "/v1/card/bindCards", method = RequestMethod.POST, consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  ResultBase<Boolean> bindCards(@RequestBody BindCardParam cardParam);

  @RequestMapping(value = "/v1/card/statistics", method = RequestMethod.POST, consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  PageResult<GenerateCardVO> statistics(@RequestBody CardParam cardParam);

  @RequestMapping(value = "/v1/card/listBindCard", method = RequestMethod.POST, consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  PageResult<CardVO> listBindCard(@RequestBody CardParam cardParam);

  @RequestMapping(value = "/v1/card/exportCard/{batchNo}", method = RequestMethod.GET)
  ResultBase<List<CardVO>> exportCard(@PathVariable("batchNo") String batchNo);*/
}