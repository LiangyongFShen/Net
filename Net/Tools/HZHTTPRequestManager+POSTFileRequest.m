//
//  HZHTTPRequestManager+POSTFileRequest.m
//  HZHttpRequest
//
//  Created by 汉子MacBook－Pro on 16/5/16.
//  Copyright © 2016年 汉子MacBook－Pro. All rights reserved.
//

#import "HZHTTPRequestManager+POSTFileRequest.h"

#define UTF8Encode(str) [str dataUsingEncoding:NSUTF8StringEncoding]

@implementation HZHTTPRequestManager (POSTFileRequest)
// post传文件请求
- (void)postFileRequestWithURL:(NSString * _Nonnull)urlString
                     postParms:(NSDictionary * _Nullable)postParms
                      getParms:(NSDictionary * _Nullable)getParms
                     filenames:(NSArray * _Nullable)filenames
                     filedatas:(NSArray * _Nullable)datas
                       headers:(NSMutableDictionary * _Nullable)headers
                       success:(success _Nullable)success
                         error:(Error _Nullable)error {
    self.success = success;
    self.error   = error;
    
    NSString *scheme = KScheme;
    NSString *host   = KHostURL;
    NSString *port   = KPort;
    NSString *method = @"POST";
    urlString        = (urlString==nil)?@"/":urlString;
    
    [self requestMethod:method scheme:scheme host:host port:port path:urlString headers:headers postParams:postParms getParams:getParms filenames:filenames filedatas:datas];
}

// 传文件使用
-(void)requestMethod:(NSString*)method scheme:(NSString*)scheme host:(NSString*)host port:(NSString*)port path:(NSString*)path  headers:(NSMutableDictionary*)headers postParams:(NSDictionary*)postParams getParams:(NSDictionary *)getParams filenames:(NSArray *)filenames filedatas:(NSArray *)filedatas {
    postParams = [NSMutableDictionary HZParamScale:postParams];
    headers    = [NSMutableDictionary HZParamScale:headers];
    
    NSString *url = [NSString string];
    if (![[path substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"/"]) {
        path = [NSString stringWithFormat:@"/%@",path];
    }
    url = [NSString stringWithFormat:@"%@://%@:%@%@",scheme,host,port,path];
    
    //如果存在get请求参数
    if (getParams.allKeys.count>0) {
        NSString *getDataStr = [[HZParamEncode new] HZParamsEncode:getParams];
        if ([url componentsSeparatedByString:@"?"].count>1) {
            url = [NSString stringWithFormat:@"%@&%@",path,getDataStr];
        }else{
            url = [NSString stringWithFormat:@"%@?%@",path,getDataStr];
        }
    }
    
    NSMutableData *body = [NSMutableData new];
    //NSString *boundary = [NSString boundary];
    /*********************拼接文件参数*********************/
    for (int i = 0; i < filenames.count; i++) {
        // 参数开始标志
        [body appendData:UTF8Encode(@"--EuN-a0Nad1G2HD1mR-hflKoJJlykgH\r\n")];
        
        // name: 服务器指定名称
        // filename: 文件名,任意
        NSString *name = filenames[i];
        NSString *dispostion = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"pic.png\"\r\n",name];
        [body appendData:UTF8Encode(dispostion)];
        [body appendData:UTF8Encode(@"Content-Type: application/octet-stream\r\n")];
        [body appendData:UTF8Encode(@"Content-Transfer-Encoding: binary\r\n")];
        
        [body appendData:UTF8Encode(@"\r\n")];
        
        NSData *imageData = filedatas[i];
        [body appendData:imageData];
        [body appendData:UTF8Encode(@"\r\n")];
    }
    
    /*********************拼接普通参数*********************/
    [postParams enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        // 参数开始标志
        [body appendData:UTF8Encode(@"--EuN-a0Nad1G2HD1mR-hflKoJJlykgH\r\n")];
        
        // 参数名
        NSString *dispostion = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n",key];
        [body appendData:UTF8Encode(dispostion)];
        [body appendData:UTF8Encode(@"\r\n")];
        
        // 参数值
        [body appendData:UTF8Encode(obj)];
        [body appendData:UTF8Encode(@"\r\n")];
    }];
    
    /********************参数拼接结束【--】**********************/
    [body appendData:UTF8Encode(@"--EuN-a0Nad1G2HD1mR-hflKoJJlykgH--\r\n")];
    
    
    /**********************读取会话数据*****************************/
    NSDictionary *dic = [[HZSessionInitManager new] unarchive_session_data];
    //反序列化
    HZSessionInitManager *mode = dic!=nil ? [[HZSessionInitManager alloc] initWithDictionary:dic] : nil;
    
    //生成请求id，使用guid算法生成
    NSString *session_request_id = [NSString HZGUID];
    //会话id
    NSString *session_id = [mode.session_id isEqual:@""] ? @"0" : mode.session_id;
    //会话key
    NSString *session_key = [mode.session_key isEqual:@""] ? @"session_key" : mode.session_key;
    //设备id
    NSString *session_card = [mode.session_card  isEqual: @""] ? [[HZExceptionManager new] exceptionSessionCard]:mode.session_card;
    //utc格林时间 格式 2016-01-19T09:41:48Z
     NSString *sign_utc_time = [NSDate HZNowUTC];
    //签名有效期 默认 1800 秒
    NSString *expired_time_offset = @"1800";
    //授权字符串
    NSString *auth_string = [NSString stringWithFormat:@"app-auth-v1/%@/%@/%@/%@/%@",session_request_id,session_id,session_card,sign_utc_time,expired_time_offset];
    //临时秘钥
    NSString *signing_key = [NSString HZHmacSHA256:auth_string withKey:session_key];
    
    
    /**********************定义签名头字典***************************/
    NSMutableDictionary *headersNew = [NSMutableDictionary dictionary];
    //定义签名头的key
    NSString *headerskey = @"";
    //强制复制小写的头，同时去除左右两边的空格
    for (NSString *key in headers) {
        //key 去首尾空格，同时转小写
        NSString* keys = [[key stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] lowercaseString];
        //values 去首尾空格
        NSString* values = [headers[key] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        //判断是否已经有headers
        if (headerskey.length>0) {
            headerskey =  [NSString stringWithFormat:@"%@;%@",headerskey,keys];
        }else{
            headerskey =  keys;
        }
        
        //插入签名头字典
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
    
    /******************如果请求存在bodydata 就加入相关头******************/
    
    //如果请求存在bodydata，也就是说不是get请求，就加入相关头
    if (body.length>0) {
        //加入请求体长度头
        NSString *lengStr  = [NSString stringWithFormat:@"%ld",(unsigned long)body.length];
        [headersNew setObject:lengStr forKey:@"content-length"];
        //加入请求格式和请求编码
        [headersNew setObject:@"multipart/form-data" forKey:@"content-type"];
        
        //算出请求体的md5
        NSString *bodyStr = [body HZMD5];
        NSString *md5Base64Str = [NSString HZHexMd5Base64Code:bodyStr];
        [headersNew setObject:md5Base64Str forKey:@"content-md5"];
        //拼接host
        if (headerskey.length>0) {
            headerskey =  [NSString stringWithFormat:@"%@;Content-Length;Content-Type;Content-Md5",headerskey];
        }else{
            headerskey =  @"Content-Length;Content-Type;Content-Md5";
        }
    }
    
    auth_string = [NSString stringWithFormat:@"%@/%@",auth_string,headerskey];
    //定义请求头信息签名字符串
    NSString *canonicalHeader =[[NSMutableDictionary HZParamSort:headersNew] componentsJoinedByString:@"\n"];
    NSString *canonicalQueryString = @"";
    
    //查找是否含有?号
    if ([url rangeOfString:@"?"].location!=NSNotFound) {
        //拆分出http_query_string
        NSRange range = [url rangeOfString:@"?"];
        NSString *http_query_string = [url substringFromIndex:range.location+1];
        NSArray * http_query_array = [http_query_string componentsSeparatedByString:@"&"];
        //定义签名头字典
        NSMutableArray *http_query_array_new = [NSMutableArray array];
        for(NSString *key in http_query_array){
            
            range = [key rangeOfString:@"="];
            
            NSString *keys  = [key substringToIndex:range.location];
            NSString *values = [key substringFromIndex:range.location+1];
            
            
            //key 去首尾空格
            keys  = [keys stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            //values 去首尾空格
            values = [values stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            //插入签名头字典
            NSString *stringValue = [NSString stringWithFormat:@"%@=%@",[NSString HZURLEscape:keys],[NSString HZURLEscape:values]];
            [http_query_array_new addObject:stringValue];
            
        }
        http_query_array_new = (id)[http_query_array_new sortedArrayUsingSelector:@selector(compare:)];
        
        //定义请求参数签名字符串
        canonicalQueryString = [http_query_array_new componentsJoinedByString:@"&"];
    }
    
    //xxxxxxxxx生成临时签名秘钥
    NSString* canonical_request = [NSString stringWithFormat:@"%@\n%@\n%@\n%@",
                                   method,
                                   [NSString HZURLEncodeExceptSlash:path],
                                   canonicalQueryString,
                                   canonicalHeader];
    
    
    NSString *session_sign = [NSString HZHmacSHA256:canonical_request withKey:signing_key];
    
    auth_string = [NSString stringWithFormat:@"%@/%@",auth_string,session_sign];
    [headersNew setObject:auth_string forKey:@"Authorization"];
    
    dispatch_queue_t dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(dispatchQueue, ^{
        [self sendRequestWithMethod:method URL:url body:body Header:headersNew];
    });
}

@end
