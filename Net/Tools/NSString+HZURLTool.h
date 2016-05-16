//
//  NSString+HZURLTool.h
//  HZHttpRequest
//
//  Created by 汉子MacBook－Pro on 16/5/13.
//  Copyright © 2016年 汉子MacBook－Pro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (HZURLTool)
/* 对URL编码,将非URL字符编码成URL字符
 * http://192.168.1.3:80/api/v1/login?name=xx&password=xxx
 * 对:api/v1/login?name=xx&password=xxx部分编码
 */
- (NSString *)HZURLEncodedString;

+ (NSString *)HZURLEscape:(NSString *)urlString;

+ (NSString *)HZURLEncodeExceptSlash:(NSString*)string;
@end
