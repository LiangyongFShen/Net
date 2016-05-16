//
//  HZSessionInitManager.m
//  HZHttpRequest
//
//  Created by 汉子MacBook－Pro on 16/5/13.
//  Copyright © 2016年 汉子MacBook－Pro. All rights reserved.
//

#import "HZSessionInitManager.h"

@implementation HZSessionInitManager

// 存储会话接口返回的数据
- (void)archive_session_data:(NSDictionary *)session_data {
    NSString *session_id_name = [session_data objectForKey:@"session_id_name"];
    NSString *session_card_name = [session_data objectForKey:@"session_card_name"];
    NSString *session_key_name = [session_data objectForKey:@"session_key_name"];
    NSString *session_sign_name = [session_data objectForKey:@"session_sign_name"];
    NSString *session_prefix = [session_data objectForKey:@"session_prefix"];
    NSString *session_id = [session_data objectForKey:@"session_id"];
    NSString *session_card = [session_data objectForKey:@"session_card"];
    NSString *session_key = [session_data objectForKey:@"session_key"];
    NSString *session_sign = [session_data objectForKey:@"session_sign"];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    [user setObject:session_id forKey:@"session_id"];
    [user setObject:session_id_name forKey:@"session_id_name"];
    [user setObject:session_card forKey:@"session_card"];
    [user setObject:session_card_name forKey:@"session_card_name"];
    [user setObject:session_key forKey:@"session_key"];
    [user setObject:session_key_name forKey:@"session_key_name"];
    [user setObject:session_sign forKey:@"session_sign"];
    [user setObject:session_sign_name forKey:@"session_sign_name"];
    [user setObject:session_prefix forKey:@"session_prefix"];
    
    [user synchronize];
}

// 取出会话接口返回的原生数据
- (NSDictionary *)unarchive_session_data {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    NSString *session_id = [user objectForKey:@"session_id"];
    session_id = session_id != nil ? session_id : @"";
    
    NSString *session_id_name = [user objectForKey:@"session_id_name"];
    session_id_name = session_id_name != nil ? session_id_name : @"";
    
    NSString *session_card = [user objectForKey:@"session_card"];
    session_card = session_card != nil ? session_card : @"";
    
    NSString *session_card_name = [user objectForKey:@"session_card_name"];
    session_card_name = session_card_name != nil ? session_card_name : @"";
    
    NSString *session_key = [user objectForKey:@"session_key"];
    session_key = session_key != nil ? session_key : @"";
    
    NSString *session_key_name = [user objectForKey:@"session_key_name"];
    session_key_name = session_key_name != nil ? session_key_name : @"";
    
    NSString *session_prefix = [user objectForKey:@"session_prefix"];
    session_prefix = session_prefix != nil ? session_prefix : @"";
    
    NSString *session_sign = [user objectForKey:@"session_sign"];
    session_sign = session_sign != nil ? session_sign : @"";
    
    NSString *session_sign_name = [user objectForKey:@"session_sign_name"];
    session_sign_name = session_sign_name != nil ? session_sign_name : @"";
    
    [user synchronize];
    
    return @{
             @"session_id":session_id,
             @"session_id_name":session_id_name,
             @"session_card":session_card,
             @"session_card_name":session_card_name,
             @"session_key":session_key,
             @"session_key_name":session_key_name,
             @"session_sign":session_sign,
             @"session_sign_name":session_sign_name,
             @"session_prefix":session_prefix
             };
}

// 生成数据模型
- (HZSessionInitManager *)initWithDictionary:(NSDictionary *)dictionary {
    return [[HZSessionInitManager alloc] initWithDictionary:dictionary error:nil];
}

// 存储会话错误信息
- (void)archiveError:(NSString *)errorString {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:errorString forKey:@"sessionInitError"];
    [user synchronize];
}

// 取出会话错误信息
- (NSString *)unarchiveErrorString {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *str = [user objectForKey:@"sessionInitError"];
    [user synchronize];
    return str;
}

- (void)sessionInitWithURLString:(NSString *)urlString callBack:(SessionCallBack)callBack {
    HZHTTPRequestManager *sessionInitRequest = [[HZHTTPRequestManager alloc] init];
    [sessionInitRequest sessionInitWithURL:urlString success:^(id response) {
        if([response[@"type"] isEqualToString:@"update"]){
            NSLog(@"%@",response[@"session_data"]);
            [[HZSessionInitManager new] archive_session_data:response[@"session_data"]];
        }else if ([response[@"type"] isEqualToString:@"ok"]) {
            // 不用更新会话
        }
        callBack(YES);
    } error:^(NSError *error, NSData *data) {
        NSData *errorData = error.userInfo[@"com.alamofire.serialization.response.error.data"];
        NSString *str = [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding];
        NSLog(@"session/init错误:%@",str);
        if (str) {
            [[HZSessionInitManager new] archiveError:str];
        }
        callBack(NO);
    }];
}
@end
