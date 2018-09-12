package com.gysync.kaola.entity.page;

import lombok.Data;


@Data
public class Pagination {

    private Integer draw;

    private Integer start;

    private Integer length;

    public Pagination(){}

    public Pagination(Integer start, Integer length){
        this.start = start;
        this.length = length;
    }

}
