//
//  NSDate+HZNowUTC.m
//  HZHttpRequest
//
//  Created by 汉子MacBook－Pro on 16/5/13.
//  Copyright © 2016年 汉子MacBook－Pro. All rights reserved.
//

#import "NSDate+HZNowUTC.h"

@implementation NSDate (HZNowUTC)
+ (NSString*)HZNowUTC {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    [formatter setTimeZone:timeZone];
    
    NSDate *confromTimesp = [NSDate date];
    
    NSString *cStr = (id)[formatter stringFromDate:confromTimesp];
    NSString *nowDate = [NSString stringWithFormat:@"%@T%@Z",[cStr substringToIndex:10],[cStr substringWithRange:NSMakeRange(cStr.length-8, 8)]];
    
    return nowDate;
}
@end
