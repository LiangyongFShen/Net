//
//  HZHTTPRequestManager.h
//  HZHttpRequest
//
//  Created by 汉子MacBook－Pro on 16/5/13.
//  Copyright © 2016年 汉子MacBook－Pro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+HZGUID.h"
#import "NSString+HZURLTool.h"
#import "NSDate+HZNowUTC.h"
#import "NSMutableDictionary+HZParamScale.h"
#import "NSMutableDictionary+HZParamSort.h"
#import "HZParamEncode.h"
#import "HZSessionInitManager.h"
#import "HZExceptionManager.h"

#define KScheme         @"http"
#define KHostURL        @"api.video.ping-qu.com"
#define KPort           @"80"

typedef  void (^success)(id response);
typedef  void (^Error)(NSError *error, NSData *data);

@protocol HZHTTPRequestManagerDelegate <NSObject>
- (void)sessionInitSuccess;
- (void)sessionInitFail;
@end

@interface HZHTTPRequestManager : NSObject<NSURLSessionDelegate>
@property(nonatomic, strong)NSURLSessionUploadTask *uploadtask;
@property(nonatomic, copy)success success;
@property(nonatomic, copy)Error error;
@property(nonatomic, weak)id<HZHTTPRequestManagerDelegate>delegate;

// 不带会话的请求
- (void)requestWithMethod:(NSString * _Nonnull)method
                      URL:(NSString * _Nonnull)urlString
                getParams:(NSDictionary * _Nullable)getParams
               postParams:(NSDictionary * _Nullable)postParams
                  headers:(NSDictionary * _Nullable)headers
                  success:(success _Nullable)success
                    error:(Error _Nullable)error;


// 会话初始化
- (void)sessionInitWithURL:(NSString * _Nonnull)urlString
                   success:(success _Nullable)success
                     error:(Error _Nullable)error;


// get请求
- (void)getRequestWithURL:(NSString * _Nonnull)urlString
                getParams:(NSDictionary * _Nullable)getParams
                  headers:(NSMutableDictionary * _Nullable)headers
                  success:(success _Nullable)success
                    error:(Error _Nullable)error;


// post请求
- (void)postRequestWithURL:(NSString * _Nonnull)urlString
                 postParms:(NSDictionary * _Nullable)postData
                 getParams:(NSDictionary * _Nullable)getParams
                   headers:(NSMutableDictionary * _Nullable)headers
                   success:(success _Nullable)success
                     error:(Error _Nullable)error;


// put请求
- (void)putRequestWithURL:(NSString * _Nonnull)urlString
                putParms:(NSDictionary * _Nullable)putParms
                getParams:(NSDictionary * _Nullable)getParams
                  headers:(NSMutableDictionary * _Nullable)headers
                  success:(success _Nullable)success
                    error:(Error _Nullable)error;


// delect请求
- (void)delectRequestWithURL:(NSString * _Nonnull)urlString
                   delectParms:(NSDictionary * _Nullable)delectParms
                   getParams:(NSDictionary * _Nullable)getParams
                     headers:(NSMutableDictionary * _Nullable)headers
                     success:(success _Nullable)success
                       error:(Error _Nullable)error;



-(void)sendRequestWithMethod:(NSString * _Nonnull)method
                         URL:(NSString * _Nonnull)urlString
                        body:(NSData * _Nullable)body
                      Header:(NSDictionary * _Nullable)header;

@end
