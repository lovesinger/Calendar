# Calendar
创建的日历方法封装，以及一个标注日期的demo
## Usage
封装了常见的日历类相关的方法，用于日历控件的编写，在NSDate+EXCalendar分类中，可以直接拖入项目中使用

```Objective-C
/**
 日期转字符串

 @param date 日期
 @param dateFormat 日期格式
 @return 字符串
 */
+(NSString*)convertDateToDateString:(NSDate*)date andDateFormat:(NSString*)dateFormat;


/**
 字符串转日期

 @param dateString 字符串
 @param dateFormat 日期格式
 @return 日期
 */
+(NSDate*)convertDateStringToDate:(NSString*)dateString andDateFormat:(NSString*)dateFormat;


/**
 获取指定日期所在月份的第一天是星期几

 @param date 指定日期
 @return 该月第一天星期几
 */
+ (NSInteger)firstWeekdayInThisMonth:(NSDate *)date;


/**
 获取指定日期所在月份的第一天日期

 @param date 指定日期
 @return 第一天日期
 */
+(NSDate*)getFirstDayofThisMonthWithDate:(NSDate*)date;


/**
 获取指定日期所在月份的最后一天日期

 @param date 指定日期
 @param dateFormat 日期格式
 @return 最后一天日期
 */
+(NSDate*)getLastDayOfThisMonthWithDate:(NSDate*)date andDateFormat:(NSString*)dateFormat;


/**
 获取指定日期是星期几

 @param date 日期
 @return 星期几
 */
+(NSInteger)weekdayOfDestinationDate:(NSDate*)date;


/**
 获取指定日期所在月份一共有多少天

 @param date 指定日期
 @return 该日期所在月份共有多少天
 */
+(NSInteger)totaldaysInThisMonth:(NSDate *)date;



/**
 比较两个日期字符串的大小

 @param oneDateStr 日期一
 @param TwoDateStr 日期二
 @param dateFormat 日期格式
 @return 比较结果
 */
+(NSComparisonResult)compareDateWithOneDate:(NSString *)oneDateStr andTwoDate:(NSString *)TwoDateStr andDateFormat:(NSString*)dateFormat;



/**
 比较一组日期，获取最小值和最大值

 @param dateArr 日期数组
 @param dateFormat 日期格式
 @return 最小值和最大值
 */
+(NSArray<NSString*>*)getMaxDateAndMinDateWithDateArr:(NSArray<NSString*>*)dateArr andDateFormat:(NSString*)dateFormat;



/**
 获取两个日期之间相差多少个月(只计算到具体月份，不算天数)

 @param startDateStr 开始日期
 @param endDateStr 结束日期
 @param dateFormat 日期格式
 @return 相差多少月份
 */
+(NSInteger)computeMonthsWithStartDate:(NSString *)startDateStr andEndDate:(NSString *)endDateStr andDateFormat:(NSString *)dateFormat;


/**
 获取指定日期相差n个月的日期

 @param dateStr 指定日期
 @param month 多少个月
 @param dateFormat 日期格式
 @return 目标日期
 */
+(NSString*)getDestinationDateFromDate:(NSString*)dateStr andMonth:(NSInteger)month andDateFormat:(NSString *)dateFormat;



/**
 筛选出一组日期和指定日期属于同一个月的日期

 @param dateArr 一组日期
 @param destinationDateStr 目标日期
 @param dateFormat 日期格式
 @return 筛选出的符合要求的日期数组
 */
+(NSArray<NSString*>*)filterSameMonthDateWithDateArr:(NSArray<NSString*>*)dateArr andDestinationDate:(NSString*)destinationDateStr andDateFormat:(NSString *)dateFormat;

```

## Demo
另外，写了一个日历相关的控件，主要是用于在日历上面标注日期，方面查看，比直接显示文字看起来更方面，也更美观。主要的类：EXCustomCalendarView、EXCustomCalendarCell

<img src="https://github.com/lovesinger/Calendar/blob/master/pic1.png" width="300" height="652" alt="效果图1"/>
<img src="https://github.com/lovesinger/Calendar/blob/master/pic2.png" width="300" height="652" alt="效果图2"/>
<img src="https://github.com/lovesinger/Calendar/blob/master/pic3.png" width="300" height="652" alt="效果图3"/>


## License
This code is distributed under the terms and conditions of the MIT license.


## Tips
[简书主页](https://www.jianshu.com/u/620c06c9141f)&nbsp;&nbsp;&nbsp;
     [掘金主页](https://juejin.im/user/5a7ae2f66fb9a0633426583b)&nbsp;&nbsp;&nbsp;
     [github主页](https://github.com/lovesinger)






