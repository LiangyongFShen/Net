//
//  NSString+MiMeType.h
//  HZHttpRequest
//
//  Created by 汉子MacBook－Pro on 16/5/16.
//  Copyright © 2016年 汉子MacBook－Pro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^MCallBack)(NSString *mimeType);

@interface NSString (MiMeType)
+ (void)mimeType:(NSString *)filePath CallBack:(MCallBack)callBack;
@end
