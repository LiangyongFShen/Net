//
//  NSString+HZCrypto.h
//  HZHttpRequest
//
//  Created by 汉子MacBook－Pro on 16/5/13.
//  Copyright © 2016年 汉子MacBook－Pro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (HZCrypto)

- (NSString*)HZMD5;

- (NSData *)HZStringToHexData;

+ (NSString*)HZMd5Base64Code:(NSString*)bodyData;

+ (NSString*)HZHexMd5Base64Code:(NSString*)bodyData;

+ (NSString *)HZHmacSHA256:(NSString *)plaintext withKey:(NSString *)key;

+ (NSString *)HZGetFileMD5_SHA1_CRC32WithPath:(NSString *)path;

@end
