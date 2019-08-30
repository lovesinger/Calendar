//
//  NSDate+EXCalendar.m
//  test
//
//  Created by 许立强 on 2019/8/22.
//  Copyright © 2019 xlq. All rights reserved.
//

#import "NSDate+EXCalendar.h"

@implementation NSDate (EXCalendar)

+(NSString*)convertDateToDateString:(NSDate*)date andDateFormat:(NSString*)dateFormat{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:dateFormat];
    return [dateFormatter stringFromDate:date];
}

+(NSDate*)convertDateStringToDate:(NSString*)dateString andDateFormat:(NSString*)dateFormat{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:dateFormat];
    return [dateFormatter dateFromString:dateString];
}

+(NSInteger)firstWeekdayInThisMonth:(NSDate*)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    //设置每周的第一天从周几开始,默认为1,从周日开始   1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    [calendar setFirstWeekday:1];
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    //若设置从周日开始算起则需要减一,若从周一开始算起则不需要减
    return firstWeekday - 1;
}

+(NSDate*)getFirstDayofThisMonthWithDate:(NSDate*)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    return firstDayOfMonthDate;
}

+(NSDate*)getLastDayOfThisMonthWithDate:(NSDate*)date andDateFormat:(NSString*)dateFormat{
    //获取下个月对应的日期
    NSString* nextMonthDate = [self getDestinationDateFromDate:[self convertDateToDateString:date andDateFormat:dateFormat] andMonth:1 andDateFormat:dateFormat];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[self convertDateStringToDate:nextMonthDate andDateFormat:dateFormat]];
    //获取下个月第一天日期
    [comp setDay:1];
    NSDate* nextFirstDate = [calendar dateFromComponents:comp];
    //获取当月最后一天日期
    NSDateComponents* addComps = [[NSDateComponents alloc]init];
    [addComps setDay:-1];
    
    return [calendar dateByAddingComponents:addComps toDate:nextFirstDate options:0];
}

+(NSInteger)weekdayOfDestinationDate:(NSDate*)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:1];
    NSUInteger weekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:date];
    return weekday - 1;
}

+(NSInteger)totaldaysInThisMonth:(NSDate *)date{
    NSRange daysInLastMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return daysInLastMonth.length;
}

+(NSComparisonResult)compareDateWithOneDate:(NSString *)oneDateStr andTwoDate:(NSString *)TwoDateStr andDateFormat:(NSString*)dateFormat{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:dateFormat];
    NSDate* oneDate = [formatter dateFromString:oneDateStr];
    NSDate* twoDate = [formatter dateFromString:TwoDateStr];
    NSComparisonResult result = [oneDate compare:twoDate];
    
    return result;
}

+(NSArray<NSString*>*)getMaxDateAndMinDateWithDateArr:(NSArray<NSString*>*)dateArr andDateFormat:(NSString *)dateFormat{
    NSString* maxDateStr = nil;
    NSString* minDateStr = nil;
    
    for (NSString* dateStr in dateArr) {
        if (!minDateStr || [self compareDateWithOneDate:minDateStr andTwoDate:dateStr andDateFormat:dateFormat] == NSOrderedDescending) {
            minDateStr = dateStr;
        }
        if (!maxDateStr || [self compareDateWithOneDate:maxDateStr andTwoDate:dateStr andDateFormat:dateFormat] == NSOrderedAscending) {
            maxDateStr = dateStr;
        }
    }
    
    return @[minDateStr, maxDateStr];
}

+(NSInteger)computeMonthsWithStartDate:(NSString *)startDateStr andEndDate:(NSString *)endDateStr andDateFormat:(NSString *)dateFormat{
//    //此方法为计算包括天数的算法
//    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
//    [formatter setDateFormat:dateFormat];
//    NSDate* startDate = [formatter dateFromString:startDateStr];
//    NSDate* endDate = [formatter dateFromString:endDateStr];
//
//    NSDateComponents* delta = [[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:startDate toDate:endDate options:0];
//    return delta.month;
    
    //此方法为只计算到月份，不考虑天数
    NSDate* startDate = [self convertDateStringToDate:startDateStr andDateFormat:dateFormat];
    NSDate* endDate = [self convertDateStringToDate:endDateStr andDateFormat:dateFormat];
    NSDateComponents* startComps = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:startDate];
    NSDateComponents* endComps = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:endDate];
    
    return (endComps.year*12+endComps.month)-(startComps.year*12+startComps.month);
}

+(NSString*)getDestinationDateFromDate:(NSString*)dateStr andMonth:(NSInteger)month andDateFormat:(NSString *)dateFormat{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:dateFormat];
    NSDate* date = [formatter dateFromString:dateStr];
    
    NSDateComponents* comps = [[NSDateComponents alloc]init];
    [comps setMonth:month];
    NSDate* destinationDate = [[NSCalendar currentCalendar] dateByAddingComponents:comps toDate:date options:0];

    return [self convertDateToDateString:destinationDate andDateFormat:dateFormat];
}

+(NSArray<NSString*>*)filterSameMonthDateWithDateArr:(NSArray<NSString*>*)dateArr andDestinationDate:(NSString*)destinationDateStr andDateFormat:(NSString *)dateFormat{
    NSMutableArray* destArr = [NSMutableArray array];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:dateFormat];
    NSDate* destDate = [formatter dateFromString:destinationDateStr];
    NSDateComponents* destComps = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:destDate];

    for (NSString* dateStr in dateArr) {
        NSDate* date = [formatter dateFromString:dateStr];
        NSDateComponents* dateComps = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:date];
        if (destComps.year == dateComps.year && destComps.month == dateComps.month) {
            [destArr addObject:dateStr];
        }
    }
    
    return [destArr copy];
}





@end
