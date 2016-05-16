//
//  HZParamEncode.h
//  HZHttpRequest
//
//  Created by 汉子MacBook－Pro on 16/5/13.
//  Copyright © 2016年 汉子MacBook－Pro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HZParamEncode : NSObject
- (NSString *)HZParamsEncode:(NSDictionary *)parameters;

- (NSMutableDictionary *)HZQueryComponentsWithKey:(NSString *)key object:(id)object;
@end
