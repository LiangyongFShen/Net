//
//  NSString+MiMeType.m
//  HZHttpRequest
//
//  Created by 汉子MacBook－Pro on 16/5/16.
//  Copyright © 2016年 汉子MacBook－Pro. All rights reserved.
//

#import "NSString+MiMeType.h"

@implementation NSString (MiMeType)
+ (void)mimeType:(NSString *)filePath CallBack:(MCallBack)callBack {
    NSURL *URL = [NSURL fileURLWithPath:filePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSHTTPURLResponse *response = nil;
    
    if ([[UIDevice currentDevice].systemVersion floatValue] < 9.0) {
        [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
        callBack(response.MIMEType);
    }else {
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            callBack(response.MIMEType);
        }];
        [dataTask resume];
    }
}
@end
