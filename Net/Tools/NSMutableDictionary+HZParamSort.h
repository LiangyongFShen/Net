//
//  NSMutableDictionary+HZParamSort.h
//  HZHttpRequest
//
//  Created by 汉子MacBook－Pro on 16/5/13.
//  Copyright © 2016年 汉子MacBook－Pro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+HZURLTool.h"

@interface NSMutableDictionary (HZParamSort)
+ (NSArray *)HZParamSort:(NSDictionary *)param;
@end
