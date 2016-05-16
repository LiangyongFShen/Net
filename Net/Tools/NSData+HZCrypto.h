//
//  NSData+HZCrypto.h
//  HZHttpRequest
//
//  Created by 汉子MacBook－Pro on 16/5/13.
//  Copyright © 2016年 汉子MacBook－Pro. All rights reserved.
//

#import <Foundation/Foundation.h>

void *HZNewBase64Decode(
                      const char *inputBuffer,
                      size_t length,
                      size_t *outputLength);

char *HZNewBase64Encode(
                      const void *inputBuffer,
                      size_t length,
                      bool separateLines,
                      size_t *outputLength);

@interface NSData (HZCrypto)

+ (NSData *)HZDataFromBase64String:(NSString *)aString;
- (NSString *) HZMD5;
- (NSData *) HZReplaceNoUtf8:(NSData *)data;
- (NSString *)HZBase64EncodedString;
@end
