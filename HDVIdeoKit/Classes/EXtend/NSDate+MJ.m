//
//  NSDate+MJ.m
//  ItcastWeibo
//
//  Created by apple on 14-5-9.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "NSDate+MJ.h"

@implementation NSDate (MJ)
/**
 *  是否为今天
 */
- (BOOL)isToday
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear;
    
    // 1.获得当前时间的年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    
    // 2.获得self的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    return
    (selfCmps.year == nowCmps.year) &&
    (selfCmps.month == nowCmps.month) &&
    (selfCmps.day == nowCmps.day);
}

/**
 *  是否为昨天
 */
- (BOOL)isYesterday
{
    // 2014-05-01
    NSDate *nowDate = [[NSDate date] dateWithYMD];
    
    // 2014-04-30
    NSDate *selfDate = [self dateWithYMD];
    
    // 获得nowDate和selfDate的差距
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay fromDate:selfDate toDate:nowDate options:0];
    return cmps.day == 1;
}

- (NSDate *)dateWithYMD
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *selfStr = [fmt stringFromDate:self];
    return [fmt dateFromString:selfStr];
}

/**
 *  是否为今年
 */
- (BOOL)isThisYear
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitYear;
    
    // 1.获得当前时间的年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    
    // 2.获得self的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    
    return nowCmps.year == selfCmps.year;
}

- (NSDateComponents *)deltaWithNow
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    return [calendar components:unit fromDate:self toDate:[NSDate date] options:0];
}

- (NSString *)timeStringWithTimeInterval:(NSString *)timeInterval {
    NSDate * created_at= [NSDate dateWithTimeIntervalSince1970:[timeInterval floatValue]];
    NSDateFormatter * fmt=[[NSDateFormatter alloc]init];
    [fmt setDateFormat:@"MM-dd HH:mm:ss"];
    
    if ([created_at isThisYear]) {//今年
        
        if ([created_at isToday]) {//今天
            
            // 计算跟当前时间差距
            NSDateComponents *cmp = [created_at deltaWithNow];
            
//            NSLog(@"%ld--%ld--%ld",cmp.hour,cmp.minute,cmp.second);
            
            if (cmp.hour >= 1) {
                return [NSString stringWithFormat:@"%ld小时之前",cmp.hour];
            }else if (cmp.minute > 1){
                return [NSString stringWithFormat:@"%ld分钟之前",cmp.minute];
            }else{
                return @"刚刚";
            }
        }
        else if ([created_at isYesterday]){//昨天
            fmt.dateFormat = @"昨天";
            return  [fmt stringFromDate:created_at];
        }
        else{//前天
            fmt.dateFormat = @"MM-dd";
            return  [fmt stringFromDate:created_at];
        }
        
    }
    else{//不是今年
        
        fmt.dateFormat = @"yyyy-MM-dd";
        
        return [fmt stringFromDate:created_at];
        
    }
}
@end
