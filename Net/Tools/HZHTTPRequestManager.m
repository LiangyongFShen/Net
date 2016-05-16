//
//  HZHTTPRequestManager.m
//  HZHttpRequest
//
//  Created by 汉子MacBook－Pro on 16/5/13.
//  Copyright © 2016年 汉子MacBook－Pro. All rights reserved.
//

#import "HZHTTPRequestManager.h"

@implementation HZHTTPRequestManager
#pragma mark 不带会话的请求
- (void)requestWithMethod:(NSString * _Nonnull)method
                      URL:(NSString * _Nonnull)urlString
                getParams:(NSDictionary * _Nullable)getParams
               postParams:(NSDictionary * _Nullable)postParams
                  headers:(NSDictionary * _Nullable)headers
                  success:(success _Nullable)success
                    error:(Error _Nullable)error {
    // 请求回调Block
    _success = success;
    _error   = error;
    
    // get参数添加到url,避免中文问题
    if (getParams.allValues.count > 0) {
        NSString *getRequestURLParamString = [[HZParamEncode new] HZParamsEncode:getParams];
        if ([urlString componentsSeparatedByString:@"?"].count > 1) {
            urlString = [NSString stringWithFormat:@"%@&%@",urlString,getRequestURLParamString];
        }else{
            urlString = [NSString stringWithFormat:@"%@?%@",urlString,getRequestURLParamString];
        }
    }
    
    // post参数转成NSData
    NSData *body = [NSData new];
    if (postParams.allValues.count > 0) {
        NSString *postRequestURLParamString = [[HZParamEncode new] HZParamsEncode:postParams];
        body = [postRequestURLParamString dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    [self sendRequestWithMethod:method URL:urlString body:body Header:headers];
}


#pragma mark 签名: sessionInit
- (void)sessionInitWithURL:(NSString * _Nonnull)urlString
                   success:(success _Nullable)success
                     error:(Error _Nullable)error {
    // 请求回调Block
    _success = success;
    _error   = error;
    
    NSString *session_request_id = [NSString HZGUID];
    NSString *interference       = [NSString HZGUID];
    
    NSDictionary *dic = [[HZSessionInitManager new] unarchive_session_data];
    HZSessionInitManager *mode = dic != nil ? [[HZSessionInitManager alloc] initWithDictionary:dic] : nil;
    NSString *session_id = [mode.session_id  isEqual: @""] ? @"0" : mode.session_id;
    NSString *session_key = [mode.session_key  isEqual: @""] ? @"session_key" : mode.session_key;
    NSString *session_card = [mode.session_card  isEqual: @""] ? [[HZExceptionManager new] exceptionSessionCard]:mode.session_card;
    NSString *sign_utc_time = [NSDate HZNowUTC];
    NSString *sign_expired_time_offset = @"1800";
    NSString *auth_string = [NSString stringWithFormat:@"session-init-v1/%@/%@/%@/%@/%@",session_request_id,session_id,session_card,sign_utc_time,sign_expired_time_offset];
    NSString *signing_key = [NSString HZHmacSHA256:auth_string withKey:session_key];
    auth_string = [NSString stringWithFormat:@"%@/%@",auth_string,interference];
    NSString *session_sign = [NSString HZHmacSHA256:auth_string withKey:signing_key];
    auth_string = [NSString stringWithFormat:@"%@/%@",auth_string,session_sign];
    
    NSString *url = [NSString stringWithFormat:@"%@://%@:%@/%@",KScheme,KHostURL,KPort,urlString];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *headers = @{@"Authorization" :auth_string};
    
    [self sendRequestWithMethod:@"GET" URL:url body:nil Header:headers];
}


#pragma mark 签名: get请求
- (void)getRequestWithURL:(NSString * _Nonnull)urlString
                getParams:(NSDictionary * _Nullable)getParams
                  headers:(NSMutableDictionary * _Nullable)headers
                  success:(success _Nullable)success
                    error:(Error _Nullable)error {
    // 请求回调Block
    _success = success;
    _error   = error;
    
    
    NSString *scheme = KScheme;
    //服务器主机
    NSString *host   = KHostURL;
    //请求端口
    NSString *port   = KPort;
    //请求模式 GET POST PUT DELETE ...
    NSString *method = @"GET";
    //url的path
    urlString = (urlString==nil)?@"/":urlString;
    
    [self requestMethod:method getParams:getParams dataParams:nil headers:headers scheme:scheme host:host port:port path:urlString];
}

#pragma mark 签名: post请求
- (void)postRequestWithURL:(NSString * _Nonnull)urlString
                 postParms:(NSDictionary * _Nullable)postData
                 getParams:(NSDictionary * _Nullable)getParams
                   headers:(NSMutableDictionary * _Nullable)headers
                   success:(success _Nullable)success
                     error:(Error _Nullable)error {
    _success = success;
    _error   = error;
    
    NSString *scheme = KScheme;
    NSString *host   = KHostURL;
    NSString *port   = KPort;
    NSString *method = @"POST";
    urlString        = (urlString==nil)?@"/":urlString;
    
    [self requestMethod:method getParams:getParams dataParams:postData headers:headers scheme:scheme host:host port:port path:urlString];
}

#pragma mark 签名: put请求
- (void)putRequestWithURL:(NSString * _Nonnull)urlString
                 putParms:(NSDictionary * _Nullable)putParms
                getParams:(NSDictionary * _Nullable)getParams
                  headers:(NSMutableDictionary * _Nullable)headers
                  success:(success _Nullable)success
                    error:(Error _Nullable)error {
    _success = success;
    _error   = error;
    
    NSString *scheme = KScheme;
    NSString *host   = KHostURL;
    NSString *port   = KPort;
    NSString *method = @"PUT";
    urlString        = (urlString==nil)?@"/":urlString;
    
    [self requestMethod:method getParams:getParams dataParams:putParms headers:headers scheme:scheme host:host port:port path:urlString];
}

#pragma mark 签名: delect请求
- (void)delectRequestWithURL:(NSString * _Nonnull)urlString
                 delectParms:(NSDictionary * _Nullable)delectParms
                   getParams:(NSDictionary * _Nullable)getParams
                     headers:(NSMutableDictionary * _Nullable)headers
                     success:(success _Nullable)success
                       error:(Error _Nullable)error {
    _success = success;
    _error   = error;
    
    NSString *scheme = KScheme;
    NSString *host   = KHostURL;
    NSString *port   = KPort;
    NSString *method = @"DELETE";
    urlString        = (urlString==nil)?@"/":urlString;
    
    [self requestMethod:method getParams:getParams dataParams:delectParms headers:headers scheme:scheme host:host port:port path:urlString];
}

#pragma mark 请求底层:添加签名
-(void)requestMethod:(NSString*)method
           getParams:(NSDictionary*)getParams
          dataParams:(NSDictionary*)dataParams
             headers:(NSMutableDictionary*)headers
              scheme:(NSString*)scheme
                host:(NSString*)host
                port:(NSString*)port
                path:(NSString*)path {
    
    getParams  = [NSMutableDictionary HZParamScale:getParams];
    dataParams = [NSMutableDictionary HZParamScale:dataParams];
    headers    = [NSMutableDictionary HZParamScale:headers];
    
    NSString *url = [NSString string];
    if (![[path substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"/"]) {
        path = [NSString stringWithFormat:@"/%@",path];
    }
    url = [NSString stringWithFormat:@"%@://%@:%@%@",scheme,host,port,path];

    // get请求参数
    if (getParams.allKeys.count>0) {
        NSString *getDataStr = [[HZParamEncode new] HZParamsEncode:getParams];
        if ([url componentsSeparatedByString:@"?"].count>1) {
            url = [NSString stringWithFormat:@"%@&%@",url,getDataStr];
        }else{
            url = [NSString stringWithFormat:@"%@?%@",url,getDataStr];
        }
    }
    
    // 如果存在请body的时候【post put delect】
    NSString *bodyData = [NSString new];
    if (dataParams.allKeys.count>0) {
        NSString *paramDataString = [[HZParamEncode new] HZParamsEncode:dataParams];
        if ([method isEqualToString:@"GET"]) {
            if ([url rangeOfString:@"?"].location!=NSNotFound) {
                url = [NSString stringWithFormat:@"%@&%@",url,paramDataString];
            }else{
                url = [NSString stringWithFormat:@"%@?%@",url,paramDataString];
            }
        }else{
            bodyData = paramDataString;
        }
    }

    //读取会话数据
    NSDictionary *dic = [[HZSessionInitManager new] unarchive_session_data];
    HZSessionInitManager *mode = dic!=nil ? [[HZSessionInitManager alloc] initWithDictionary:dic] : nil;
    NSString *session_request_id = [NSString HZGUID];
    NSString *session_id = mode.session_id==nil ? @"0" : mode.session_id;
    NSString *session_key = mode.session_key==nil ? @"session_key":mode.session_key;
    NSString *session_card = [mode.session_card  isEqual: @""] ? [[HZExceptionManager new] exceptionSessionCard]:mode.session_card;
    NSString *sign_utc_time = [NSDate HZNowUTC];
    NSString *expired_time_offset = @"1800";
    NSString *auth_string = [NSString stringWithFormat:@"app-auth-v1/%@/%@/%@/%@/%@",session_request_id,session_id,session_card,sign_utc_time,expired_time_offset];
    NSString *signing_key = [NSString HZHmacSHA256:auth_string withKey:session_key];
    
    //定义签名头字典
    NSMutableDictionary *headersNew = [NSMutableDictionary dictionary];
    NSString *headerskey = @"";
    for (NSString *key in headers) {
        NSString* keys = [[key stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] lowercaseString];
        NSString* values = [headers[key] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (headerskey.length>0) {
            headerskey =  [NSString stringWithFormat:@"%@;%@",headerskey,keys];
        }else{
            headerskey =  keys;
        }
        [headersNew setObject:values forKey:keys];
    }
    
    //如果不存在host头就加入host头
    if (![headersNew objectForKey:@"host"]) {
        [headersNew setObject:host forKey:@"host"];
        //拼接host
        if (headerskey.length>0) {
            headerskey =  [NSString stringWithFormat:@"%@;host",headerskey];
        }else{
            headerskey =  @"host";
        }
    }
    
    //如果请求存在bodydata，也就是说不是get请求，就加入相关头
    if (bodyData.length>0) {
        NSString *lengStr  = [NSString stringWithFormat:@"%ld",(unsigned long)bodyData.length];
        [headersNew setObject:lengStr forKey:@"content-length"];
        [headersNew setObject:@"application/x-www-form-urlencoded; charset=UTF-8" forKey:@"content-type"];        
        NSString *md5Base64Str = [NSString HZMd5Base64Code:bodyData];
        [headersNew setObject:md5Base64Str forKey:@"content-md5"];
        if (headerskey.length>0) {
            headerskey =  [NSString stringWithFormat:@"%@;Content-Length;Content-Type;Content-Md5",headerskey];
        }else{
            headerskey =  @"Content-Length;Content-Type;Content-Md5";
        }
    }
    auth_string = [NSString stringWithFormat:@"%@/%@",auth_string,headerskey];
    NSString *canonicalHeader =[[NSMutableDictionary HZParamSort:headersNew] componentsJoinedByString:@"\n"];
    NSString *canonicalQueryString = @"";
    if ([url rangeOfString:@"?"].location!=NSNotFound) {
        NSRange range = [url rangeOfString:@"?"];
        NSString *http_query_string = [url substringFromIndex:range.location+1];
        NSArray * http_query_array = [http_query_string componentsSeparatedByString:@"&"];
        //定义签名头字典
        NSMutableArray *http_query_array_new = [NSMutableArray array];
        for(NSString *key in http_query_array){
            range = [key rangeOfString:@"="];

            NSString *keys  = [key substringToIndex:range.location];
            NSString *values = [key substringFromIndex:range.location+1];
            
            keys  = [keys stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            values = [values stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
       
            NSString *stringValue = [NSString stringWithFormat:@"%@=%@",[NSString HZURLEscape:keys],[NSString HZURLEscape:values]];
            [http_query_array_new addObject:stringValue];
        }
        http_query_array_new = (id)[http_query_array_new sortedArrayUsingSelector:@selector(compare:)];
        canonicalQueryString = [http_query_array_new componentsJoinedByString:@"&"];
    }
    
    //生成临时签名秘钥
    NSString* canonical_request = [NSString stringWithFormat:@"%@\n%@\n%@\n%@",method,[NSString HZURLEncodeExceptSlash:path],canonicalQueryString,canonicalHeader];
    NSString *session_sign = [NSString HZHmacSHA256:canonical_request withKey:signing_key];
    auth_string = [NSString stringWithFormat:@"%@/%@",auth_string,session_sign];
    [headersNew setObject:auth_string forKey:@"Authorization"];
    
    NSData *body = [bodyData dataUsingEncoding:NSUTF8StringEncoding];
    
    dispatch_queue_t dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(dispatchQueue, ^{
        [self sendRequestWithMethod:method URL:url body:body Header:headersNew];
    });
}

#pragma mark NSURLSession
-(void)sendRequestWithMethod:(NSString * _Nonnull)method
                         URL:(NSString * _Nonnull)urlString
                        body:(NSData * _Nullable)body
                      Header:(NSDictionary * _Nullable)header {
    NSURL *URL = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:8.0f];
    request.HTTPMethod = method;
    [request setAllHTTPHeaderFields:header];
    body = body == nil ? [NSData new] : body;// 否则出现 Domain=NSURLErrorDomain Code=-999
    
    NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session                     = [NSURLSession sessionWithConfiguration:configuration
                                                          delegate:self
                                                     delegateQueue:[NSOperationQueue mainQueue]];
    _uploadtask                               = [session uploadTaskWithRequest:request
                                                                      fromData:body
                                                             completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSDictionary *dic = nil;
        NSError *parseError;
        if (data) {
            dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parseError];
        }
        //[self print:dic];
        
        if (parseError != nil) {
            [self print:@"数据解析有误"];
            return;
        }
        
        long state = (long)((NSHTTPURLResponse*)response).statusCode;
        
        if (state==200) {
            _success(dic);
        }else{
            _error(error,data);
        }
    }];
    
    [_uploadtask resume];
}

- (void)print:(id)obj {
    NSLog(@"%@",obj);
}

@end
