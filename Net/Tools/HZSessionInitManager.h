//
//  HZSessionInitManager.h
//  HZHttpRequest
//
//  Created by 汉子MacBook－Pro on 16/5/13.
//  Copyright © 2016年 汉子MacBook－Pro. All rights reserved.
//

#import "JSONModel.h"
#import "HZHTTPRequestManager.h"

typedef void(^SessionCallBack)(BOOL isSuccess);

@interface HZSessionInitManager : JSONModel
@property(nonatomic,copy) NSString *session_id_name;
@property(nonatomic,copy) NSString *session_card_name;
@property(nonatomic,copy) NSString *session_key_name;
@property(nonatomic,copy) NSString *session_sign_name;
@property(nonatomic,copy) NSString *session_prefix;
@property(nonatomic,copy) NSString *session_id;
@property(nonatomic,copy) NSString *session_card;
@property(nonatomic,copy) NSString *session_key;
@property(nonatomic,copy) NSString *session_sign;

// 存储会话接口返回的数据
- (void)archive_session_data:(NSDictionary *)session_data;

// 取出会话接口返回的原生数据
- (NSDictionary *)unarchive_session_data;
// 生成数据模型
- (HZSessionInitManager *)initWithDictionary:(NSDictionary *)dictionary;

// 存储会话错误信息
- (void)archiveError:(NSString *)errorString;
// 取出会话错误信息
- (NSString *)unarchiveErrorString;

// 发起获取会话信息请求
- (void)sessionInitWithURLString:(NSString *)urlString callBack:(SessionCallBack)callBack;

@end
