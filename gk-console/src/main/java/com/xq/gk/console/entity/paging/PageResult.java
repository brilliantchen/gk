package com.xq.gk.console.entity.paging;

import lombok.Data;

import java.util.List;


@Data
public class PageResult<T> {
    private Integer draw;
    private Long recordsTotal;
    private Long recordsFiltered;
    private List<T> data;
}
