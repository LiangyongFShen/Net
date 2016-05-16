//
//  HZUploadFileManager.m
//  HZHttpRequest
//
//  Created by 汉子MacBook－Pro on 16/5/16.
//  Copyright © 2016年 汉子MacBook－Pro. All rights reserved.
//

#import "HZUploadFileManager.h"

@implementation HZUploadFileManager
- (void)step_1_get_part_size_info_withURLString:(NSString *)urlString
                                       filePath:(NSString *)filePath
                                      sCallBack:(SCallBack)sCallBack
                                      eCallBack:(ECallBack)eCallBack {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:filePath error:nil];
    
    long long file_size = [fileAttributes fileSize];
    NSString *device_type = @"ios";
    
    [NSString mimeType:filePath CallBack:^(NSString *mimeType) {
        [self step_1_sendRequestWithURLString:urlString file_size:file_size file_type:mimeType device_type:device_type sCallBack:sCallBack eCallBack:eCallBack];
    }];
}

- (void)step_1_sendRequestWithURLString:(NSString *)urlString
                              file_size:(long long)file_size
                              file_type:(NSString *)file_type
                            device_type:(NSString *)device_type
                              sCallBack:(SCallBack)sCallBack
                              eCallBack:(ECallBack)eCallBack {
    
    NSDictionary *params = @{
                             @"file_size"  :[NSString stringWithFormat:@"%lld",file_size],
                             @"file_type"  :file_type,
                             @"device_type":device_type
                             };
    
    [[HZHTTPRequestManager new] putRequestWithURL:urlString putParms:params getParams:nil headers:nil success:^(id response) {
        sCallBack(response);
    } error:^(NSError *error, NSData *data) {
        eCallBack(error, data);
    }];
}

- (void)step_2_get_file_id_withURLString:(NSString *)urlString
                                filePath:(NSString *)filePath
                               part_size:(long long)part_size
                                part_sum:(NSInteger)part_sum
                               sCallBack:(SCallBack)sCallBack
                               eCallBack:(ECallBack)eCallBack {
    
    NSString *fle_name = @"";
    NSString *file_size = @"";
    NSString *file_type = @"";
    NSString *last_modified = @"";
    NSString *manage_type = @"";
    NSString *directory = @"";
    NSString *device_type = @"";
    
    
}

@end
