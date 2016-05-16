//
//  HZExceptionManager.m
//  HZHttpRequest
//
//  Created by 汉子MacBook－Pro on 16/5/13.
//  Copyright © 2016年 汉子MacBook－Pro. All rights reserved.
//

#import "HZExceptionManager.h"

#define kCrashFilePath [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"ExceptionFromIOS.txt"]

void UncaughtExceptionHandler(NSException *exception) {
    
    // 记录时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *date = [NSDate date];
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:dateString forKey:@"crashDate"];
    [user synchronize];
    
    
    NSArray *arr = [exception callStackSymbols];//得到当前调用栈信息
    NSString *reason = [exception reason];      //非常重要，就是崩溃的原因
    NSString *name = [exception name];          //异常类型
    
    NSString *cashMessage = [NSString stringWithFormat:@"exception type : %@ \n crash reason : %@ \n call stack info : %@", name, reason, arr];
    
    NSLog(@"%@",cashMessage);
    
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:kCrashFilePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:kCrashFilePath error:nil];
    }
    
    [cashMessage writeToFile:kCrashFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

@implementation HZExceptionManager

+ (instancetype)shareManager {
    static HZExceptionManager *manager;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        if (!manager) {
            manager = [[HZExceptionManager alloc] init];
        }
    });
    return manager;
}

+ (void)catchException {
    NSSetUncaughtExceptionHandler (&UncaughtExceptionHandler);
}

- (NSDictionary *)getPram {
    NSDictionary *dic = @{@"input_uid":[self input_uid],
                          @"content":[self content],
                          @"crash_log_time":[self crashLogTime],
                          @"device_type":[self deviceType],
                          @"device_id":[self deviceID],
                          @"device_os":[self device_os],
                          @"device_model":[self deviceModel],
                          @"device_version_sdk":[self deviceVersionSdk],
                          @"device_version_release":[self deviceVersionRelease],
                          @"input_card_id":[self input_card_id],
                          @"error_type":[self error_type],
                          @"error_line":[self error_line],
                          @"error_url":[self error_url]
                          };
    return dic;
}

- (BOOL)isCrash {
    return ([self content].length > 0 && [self content] != nil) ? true : false;
}

- (BOOL)cleanCrash {
    if ([[NSFileManager defaultManager] fileExistsAtPath:kCrashFilePath]) {
        return [[NSFileManager defaultManager] removeItemAtPath:kCrashFilePath error:nil];
    }
    return true;
}

- (void)sendExceptionWithURL:(NSString *)urlString {
    NSDictionary *paramDic = [self getPram];
    NSData *data = [NSJSONSerialization dataWithJSONObject:paramDic options:NSJSONWritingPrettyPrinted error:nil];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = nil;
    request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:8.0f];
    
    request.HTTPMethod = @"POST";
    [request setHTTPBody:data];
    
    NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    _uploadtask = [session uploadTaskWithRequest:request fromData:data completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dic = nil;
        NSError *pariseError;
        if (data) {
            dic =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&pariseError];
        }
        long state = (long)((NSHTTPURLResponse*)response).statusCode;
        if (state==200) {
            NSLog(@"发送异常成功");
            // 清楚异常缓存
            [self cleanCrash];
        }else{
            NSLog(@"发送异常失败");
        }
    }];
    [_uploadtask resume];
}

- (NSString *)exceptionSessionCard{
    NSString *m1;
    NSString *m2;
    NSString *m3;
    NSString *m4;
    NSString *m5;
    
    NSString *MacID = @"MacID";
    
    m1  = [MacID HZMD5];
    m2  = [[m1 stringByAppendingFormat:@"%@%@",MacID,[self deviceModel]] HZMD5];
    m3  = [[NSString stringWithFormat:@"%@%@%@",[self deviceVersionRelease],m1,m2] HZMD5];
    m4  = [[NSString stringWithFormat:@"%@%@%.0fX%.0f",m3,m1,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height] HZMD5];
    m5  = [[NSString stringWithFormat:@"%@%@%@%@%@",m1,m2,m4,MacID,m3] HZMD5];
    
    
    NSString *Str;
    
    Str = [NSString stringWithFormat:@"%@-%@-%@-%@-%@-%@%@-%@",
           [m5 substringWithRange:NSMakeRange(5-1, 4)],
           [m5 substringWithRange:NSMakeRange(9-1, 8)],
           [m5 substringWithRange:NSMakeRange(1-1, 4)],
           [m5 substringWithRange:NSMakeRange(5-1, 4)],
           [m5 substringWithRange:NSMakeRange(1-1, 4)],
           [m5 substringWithRange:NSMakeRange(9-1, 8)],
           [m5 substringWithRange:NSMakeRange(1-1, 4)],
           [m5 substringWithRange:NSMakeRange(9-1, 8)]
           ];
    
    return Str;
}


#pragma mark Tool function
// 1.input_uid用户id
- (NSString *)input_uid
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"user_id"];
    if (uid == nil) {
        uid = @"";
    }
    [user synchronize];
    return uid;
}

// 2.content崩溃日志
- (NSString *)content
{
    return [NSString stringWithContentsOfFile:kCrashFilePath encoding:NSUTF8StringEncoding error:nil];
}

// 3.crash_log_time崩溃日期
- (NSString *)crashLogTime
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *str = [user objectForKey:@"crashDate"];
    [user synchronize];
    return str;
}

// 4.device_type
- (NSString *)deviceType
{
    return @"ios";
}

// 5.device_id
- (NSString *)deviceID
{
    return @"debug 1.0";
}

// 6.device_os
- (NSString *)device_os {
    return @"iOS";
}

// 7.device_model
- (NSString *)deviceModel
{
    return [NSString HZDevicePlatform];
}

// 8.device_version_release
- (NSString *)deviceVersionSdk
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

// 9.device_version_sdk
- (NSString *)deviceVersionRelease
{
    return [[UIDevice currentDevice] systemVersion];
}

// 10.input_card_id
- (NSString *)input_card_id {
    //读取会话数据
    NSDictionary *dic = [[HZSessionInitManager new] unarchive_session_data];
    
    //反序列化
    HZSessionInitManager *mode = dic!=nil ? [[HZSessionInitManager alloc] initWithDictionary:dic] : nil;
    return mode.session_card == nil ? @"" : mode.session_card;
}

// 11.error_type
- (NSString *)error_type {
    return @"debug";
}

// 12.error_line
- (NSString *)error_line {
    return @"0";
}

// 13.error_url
- (NSString *)error_url {
    return @"zhongqitest3.ping-qu.com";
}

- (NSString *)uid_Key
{
    return [self getDefaultValueWithKey:@"uid"];
}

- (NSString *)uid_Value
{
    return [self getDefaultValueWithKey:[self getDefaultValueWithKey:@"uid"]];
}

- (NSString *)cardID
{
    return @"";
}

- (NSString *)session_id_name_Key
{
    return [self getDefaultValueWithKey:@"session_id_name"];
}

- (NSString *)session_id_name_Value
{
    return [self getDefaultValueWithKey:[self getDefaultValueWithKey:@"session_id_name"]];
}

- (NSString *)card_id_name_Key
{
    return [self getDefaultValueWithKey:@"card_id_name"];
}

- (NSString *)card_id_name_Value
{
    return [self getDefaultValueWithKey:[self getDefaultValueWithKey:@"card_id_name"]];
}

- (NSString *)getDefaultValueWithKey:(NSString *)key
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    key = [NSString stringWithFormat:@"cjbapp-%@",key];
    NSString *value = [user objectForKey:key];
    [user synchronize];
    
    if (value == nil || [value isEqualToString:@""]) {
        
        value = @"";
        
    }else{
        
        if ([value hasPrefix:@"str-"]) {
            value = [value substringFromIndex:4];
        }
    }
    
    return value;
}

@end
