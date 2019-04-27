//
//  NSDate+LCQ.h
//  Category
//
//  Created by apple on 16/8/26.
//  Copyright © 2016年 qingxunLv. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  2日历之间相差的天数或月份数
 */
typedef  NS_ENUM(NSInteger,NSDateDifferType) {
    /**
     *  月份数
     */
    NSDateDifferTypeMonth,
    /**
     *  天数
     */
    NSDateDifferTypeDay
};
@interface NSDate (LCQ)



/**
 *  计算这个月有多少天
 *
 *  @return 天数
 */
- (NSUInteger)numberOfDaysInCurrentMonth;

/**
 *  获取这个月有多少周
 *
 *  @return 周数
 */
- (NSUInteger)numberOfWeeksInCurrentMonth;

/**
 *  计算这个月的第一天是礼拜几
 *
 *  @return 礼拜几
 */
- (NSUInteger)weeklyOrdinality;

/**
 *  计算这个月最开始的一天
 *  @return NSDate *
 */
- (NSDate *)firstDayOfCurrentMonth;

/**
 *  计算这个月最后一天
 *  @return NSDate *
 */
- (NSDate *)lastDayOfCurrentMonth;

/**
 *  上一个月
 *
 *  @return 上一个月
 */
- (NSDate *)dayInThePreviousMonth;

/**
 *  下一个月
 *
 *  @return 下一个月
 */
- (NSDate *)dayInTheFollowingMonth;

/**
 *  获取当前日期之后的几个月
 *
 *  @param month 月份个数
 *
 *  @return  几个月后的日期
 */
- (NSDate *)dayInTheFollowingMonth:(int)month;

/**
 *  获取当前日期之后的几个天
 *
 *  @param day 天数个数
 *
 *  @return 几天后的日期
 */
- (NSDate *)dayInTheFollowingDay:(int)day;

/**
 *  获取年月日对象
 *
 *  @return 年月日对象
 */
- (NSDateComponents *)YMDComponents;

/**
 * NSString转NSDate
 *
 *  @param dateString 待转字符串 默认格式 @"yyyy-MM-dd"
 *
 *  @return NSDate
 */
- (NSDate *)dateFromString:(NSString *)dateString;

/**
 *  NSDate转NSString
 *
 *  @param date 待转NSDate
 *
 *  @return 字符串 默认转换成 @"yyyy-MM-dd" 这种格式
 */
- (NSString *)stringFromDate:(NSDate *)date;

/**
 *  两个日历之间相差多少月或多少天
 *
 *  @param today      NSDate1
 *  @param beforday   NSDate2
 *  @param differType 需要计算的相差类型 NSDateDifferTypeMonth 月份数,NSDateDifferTypeDay 天数
 *
 *  @return  数量
 */
+ (NSInteger)getDayNumbertoDay:(NSDate *)today beforDay:(NSDate *)beforday differType:(NSDateDifferType)differType;

/**
 *  得到周几
 *
 *  @return 周日是“1”，周一是“2”...
 */
-(int)getWeekIntValueWithDate;

/**
 *  判断日期是今天,明天,后天,周几
 *
 *  @return 字符串
 */
-(NSString *)compareIfTodayWithDate;

/**
 *  通过数字返回星期几
 *
 *  @param week 1,2,3,4,5,6,7 只有这几个值!!!!!!
 *
 *  @return 星期几 若不是这几个值返回@""
 */
+(NSString *)getWeekStringFromInteger:(NSInteger)week;


@end
