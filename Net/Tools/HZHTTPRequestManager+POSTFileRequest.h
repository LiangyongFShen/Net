//
//  HZHTTPRequestManager+POSTFileRequest.h
//  HZHttpRequest
//
//  Created by 汉子MacBook－Pro on 16/5/16.
//  Copyright © 2016年 汉子MacBook－Pro. All rights reserved.
//

#import "HZHTTPRequestManager.h"
#import "NSData+HZCrypto.h"

@interface HZHTTPRequestManager (POSTFileRequest)
// post传文件请求
- (void)postFileRequestWithURL:(NSString * _Nonnull)urlString
                     postParms:(NSDictionary * _Nullable)postParms
                      getParms:(NSDictionary * _Nullable)getParms
                     filenames:(NSArray * _Nullable)filenames
                     filedatas:(NSArray * _Nullable)datas
                       headers:(NSMutableDictionary * _Nullable)headers
                       success:(success _Nullable)success
                         error:(Error _Nullable)error;


@end
