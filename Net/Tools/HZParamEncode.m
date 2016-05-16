//
//  HZParamEncode.m
//  HZHttpRequest
//
//  Created by 汉子MacBook－Pro on 16/5/13.
//  Copyright © 2016年 汉子MacBook－Pro. All rights reserved.
//

#import "HZParamEncode.h"

@implementation HZParamEncode
- (NSString *)HZParamsEncode:(NSDictionary *)parameters {
    NSMutableDictionary *components = [NSMutableDictionary new];
    NSString *result = @"";
    for (NSString *key in parameters.allKeys) {
        id value = parameters[key];
        [components setValuesForKeysWithDictionary:[self HZQueryComponentsWithKey:key object:value]];
    }
    for (NSString *key in components.allKeys) {
        NSString *value = components[key];
        if (![result isEqualToString:@""]) {
            result = [result stringByAppendingString:@"&"];
        }
        result = [result stringByAppendingString:[NSString stringWithFormat:@"%@=%@", key, value]];
    }
    
    return result;
}

- (NSMutableDictionary *)HZQueryComponentsWithKey:(NSString *)key object:(id)object {
    NSMutableDictionary *components = [NSMutableDictionary new];
    if ([object isKindOfClass:[NSDictionary class]]) {
        for (NSString *nestedKey in ((NSDictionary *)object).allKeys) {
            id value = ((NSDictionary *)object)[nestedKey];
            [components setValuesForKeysWithDictionary:[self HZQueryComponentsWithKey:[NSString stringWithFormat:@"%@[%@]", key, nestedKey] object:value]];
        }
    }
    else if ([object isKindOfClass:[NSArray class]]) {
        for (id value in (NSArray *)object) {
            [components setValuesForKeysWithDictionary:[self HZQueryComponentsWithKey:key object:value]];
        }
    }
    else {
        [components setObject:[self HZEscape:[NSString stringWithFormat:@"%@", object]] forKey:[self HZEscape:key]];
    }
    
    return components;
}

- (NSString *)HZEscape:(NSString *)string {
    if ([UIDevice currentDevice].systemVersion.floatValue >= 9.0) {
        NSString *charactersToEscape = @":&=;+!@#$()',*";
        NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
        NSString *result = [string stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
        return result;
    }
    
    CFStringRef legalURLCharactersToBeEscaped = (__bridge CFStringRef)@":&=;+!@#$()',*";
    NSString *result2 = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(nil,
                                                                                  (__bridge CFStringRef)string,
                                                                                  nil,
                                                                                  legalURLCharactersToBeEscaped,
                                                                                  kCFStringEncodingUTF8));
    return result2;
}
@end
