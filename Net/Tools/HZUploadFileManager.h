//
//  HZUploadFileManager.h
//  HZHttpRequest
//
//  Created by 汉子MacBook－Pro on 16/5/16.
//  Copyright © 2016年 汉子MacBook－Pro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HZHTTPRequestManager.h"
#import "NSString+MiMeType.h"

typedef void(^SCallBack)(id sResponse);
typedef void(^ECallBack)(NSError *e, id eResponse);

@interface HZUploadFileManager : NSObject
// step1.获取分块大小
- (void)step_1_get_part_size_info_withURLString:(NSString *)urlString
                                       filePath:(NSString *)filePath
                                      sCallBack:(SCallBack)sCallBack
                                      eCallBack:(ECallBack)eCallBack;


// step2.获取文件id
- (void)step_2_get_file_id_withURLString:(NSString *)urlString
                                filePath:(NSString *)filePath
                               part_size:(long long)part_size
                                part_sum:(NSInteger)part_sum
                               sCallBack:(SCallBack)sCallBack
                               eCallBack:(ECallBack)eCallBack;

// step3.获取成功上传的信息

// step4.获取分块签名

// step5.获取成功上传的信息
@end
