//
//  HZExceptionManager.h
//  HZHttpRequest
//
//  Created by 汉子MacBook－Pro on 16/5/13.
//  Copyright © 2016年 汉子MacBook－Pro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HZSessionInitManager.h"
#import "NSString+HZCrypto.h"
#import "NSString+HZDevicePlatform.h"

@interface HZExceptionManager : NSObject <NSURLSessionDelegate>
@property (nonatomic, strong)NSURLSessionUploadTask *uploadtask;
+ (instancetype)shareManager;
+ (void)catchException;
- (BOOL)isCrash;
- (BOOL)cleanCrash;
- (void)sendExceptionWithURL:(NSString *)urlString;
- (NSString *)exceptionSessionCard;
@end
