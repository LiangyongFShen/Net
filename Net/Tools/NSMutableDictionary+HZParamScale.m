//
//  NSMutableDictionary+HZParamScale.m
//  HZHttpRequest
//
//  Created by 汉子MacBook－Pro on 16/5/13.
//  Copyright © 2016年 汉子MacBook－Pro. All rights reserved.
//

#import "NSMutableDictionary+HZParamScale.h"

@implementation NSMutableDictionary (HZParamScale)
+(NSMutableDictionary*)HZParamScale:(NSDictionary*)param {
    
    NSArray *array = [NSArray array];
    if ([param isKindOfClass:[NSArray class]]) {
        array = (id)param;
    }else{
        return [NSMutableDictionary dictionaryWithDictionary:param];
    }
    
    NSInteger num = array.count/2;
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    for (int i=0; i<num; i++) {
        NSArray* arr = [array subarrayWithRange:NSMakeRange(i*2, 2)];
        [dic setObject:arr[1] forKey:arr[0]];
    }
    
    return dic;
}

@end
