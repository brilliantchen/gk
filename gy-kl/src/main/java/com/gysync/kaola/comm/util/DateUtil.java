package com.gysync.kaola.comm.util;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.format.DateTimeFormatter;
import java.util.Date;

public class DateUtil {
    public static final String dateTimeFormat = "yyyy-MM-dd HH:mm:ss";
    public static final String dateFormat = "yyyy-MM-dd";
    public static final String timeStempFormat = "yyyyMMddHHmmssSSS";
    public static final DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern(dateTimeFormat);
    public static final DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern(dateFormat);

    public static String dateToString(Date date) {
        SimpleDateFormat sdf = new SimpleDateFormat(dateTimeFormat);
        String str = sdf.format(date);
        return str;
    }

    public static String dateToString(Date date, String format) {
        SimpleDateFormat sdf = new SimpleDateFormat(format);
        String str = sdf.format(date);
        return str;
    }

    public static Date stringToDate(String dateStr, String format) {
        SimpleDateFormat sdf = new SimpleDateFormat(format);
        Date date = null;
        try {
            date = sdf.parse(dateStr);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return date;
    }


}
