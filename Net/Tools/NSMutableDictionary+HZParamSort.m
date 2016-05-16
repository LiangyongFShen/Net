//
//  NSMutableDictionary+HZParamSort.m
//  HZHttpRequest
//
//  Created by 汉子MacBook－Pro on 16/5/13.
//  Copyright © 2016年 汉子MacBook－Pro. All rights reserved.
//

#import "NSMutableDictionary+HZParamSort.h"

@implementation NSMutableDictionary (HZParamSort)
+ (NSArray *)HZParamSort:(NSDictionary *)param {
    NSArray *keys = param.allKeys;
    NSArray *sortArray = [keys sortedArrayUsingSelector:@selector(compare:)];
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSString *key in sortArray) {
        
        NSString *value = param[key];
        
        NSString *obj = [NSString stringWithFormat:@"%@:%@",[NSString HZURLEscape:key],[NSString HZURLEscape:value]];
        
        [array addObject:obj];
    }
    
    return array;
}

@end
