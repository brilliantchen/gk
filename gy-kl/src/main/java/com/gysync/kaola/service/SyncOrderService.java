package com.gysync.kaola.service;

import com.gysync.kaola.entity.gy.resp.GyDeliverysPo;

import java.util.List;
import java.util.Map;

public interface SyncOrderService {

    /**
     * 下单：抽取管易未同步的发货单去考拉下单，并更新考拉发货单状态
     * 需要传入
     * map.put("warehouse_code", "002");  //仓库代码
     * map.put("sync_status", "0"); //0:未同步
     * map.put("del", "0"); //0:是否同时返回已作废的单据 0:不返回（默认）
     */
    public long gyklOrderSync(Map<String, Object> map);
    void gyOrderSyncRoundHandler(List<GyDeliverysPo> deliverys, int round);

    /**
     * 下单失败重试：修复管易同步失败的发货单（考拉下单失败）去考拉下单，并更新考拉发货单状态
     * 需要传入
     *  map.put("warehouse_code", "002");  //仓库代码
     *  map.put("sync_status", "-1"); //0:同步失败
     *  map.put("end_create", ""); //0:创建时间小于当前时间半小时（待定）
     */
    public long gyklOrderFix(Map<String, Object> map);


    /**
     * 物流状态同步：抽取管易同步成功的发货单，并且发货单未打印，同步考拉发货状态
     * 需要传入
     *  map.put("warehouse_code", "002");  //仓库代码
     *  map.put("sync_status", "1"); //0:同步成功
     *  map.put("print", "0"); //0:未打单

     */
    public long gyklOrderExpressSync(Map<String, Object> map);
    void gyklOrderExpressSyncHandler(List<GyDeliverysPo> deliverys, int round);

    /**
     * 取消订单：管易废弃发货单操作，考拉取消订单（未发货前可取消）
     * 需要传入
     *  map.put("warehouse_code", "002");  //仓库代码
     *  map.put("del", "1"); //0:是否同时返回已作废的单据 1:返回
     *  map.put("sync_status", "1"); // 1:已同步，说明此订单已在考拉下单成功
     *  map.put("print", "0"); //0:未打单,已打单不能取消
     *  map.put("start_create", ""); //0:创建时间开始 于当前时间1天前，用于过滤未同步物流的发货单，但是仍有重复已作废单据
     */
    public long gyklOrderCancel(Map<String, Object> map);
    public void gyklOrderCancelSyncHandler(List<GyDeliverysPo> deliverys, int round);
}
