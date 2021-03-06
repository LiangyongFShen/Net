//
//  HZHTTPRequestManager+POSTFile3PartRequest.h
//  HZHttpRequest
//
//  Created by 汉子MacBook－Pro on 16/5/16.
//  Copyright © 2016年 汉子MacBook－Pro. All rights reserved.
//

#import "HZHTTPRequestManager.h"
/**
 *
 *
 */

@interface HZHTTPRequestManager (POSTFile3PartRequest)
#pragma mark: 传文件请求 -put文件分块到第三方服务器
- (void)putFileRequest3PartServerWithURL:(NSString * _Nonnull)urlString
                               postParms:(NSDictionary * _Nullable)postParms
                                getParms:(NSDictionary * _Nullable)getParms
                               filenames:(NSArray * _Nullable)filenames
                               filedatas:(NSArray * _Nullable)datas
                                 headers:(NSMutableDictionary * _Nullable)headers
                                 success:(success _Nullable)success
                                   error:(Error _Nullable)error;
@end
