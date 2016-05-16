//
//  NSString+HZGUID.m
//  HZHttpRequest
//
//  Created by 汉子MacBook－Pro on 16/5/13.
//  Copyright © 2016年 汉子MacBook－Pro. All rights reserved.
//

#import "NSString+HZGUID.h"

@implementation NSString (HZGUID)
/* 生成干扰码
 */
+ (NSString *)HZGUID {
    CFUUIDRef    uuidObj = CFUUIDCreate(nil);
    NSString    *uuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(nil, uuidObj));
    CFRelease(uuidObj);
    return [uuidString lowercaseString];
}
@end
