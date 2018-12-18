package com.gysync.kaola.entity.param;

import com.gysync.kaola.entity.page.Pagination;
import lombok.Data;

@Data
public class OrderErrorParam extends Pagination {

    private int errorType;
    private String orderId;
    private String thirdPartyId;

}
