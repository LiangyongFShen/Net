//
//  ViewController.m
//  Net
//
//  Created by 汉子MacBook－Pro on 16/5/16.
//  Copyright © 2016年 汉子MacBook－Pro. All rights reserved.
//

#import "ViewController.h"
#import "HZHTTPRequestManager.h"
#import "HZUploadFileManager.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"1.mp4" ofType:nil];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *dic = [fileManager attributesOfItemAtPath:filePath error:nil];
    NSLog(@"%@",dic);
    
    HZUploadFileManager *manager = [[HZUploadFileManager alloc] init];
    [manager step_1_get_part_size_info_withURLString:@"v1_0/upload/file_part_size" filePath:filePath device_type:@"ios" sCallBack:^(id sResponse) {
        NSLog(@"%@",sResponse);
    } eCallBack:^(NSError *e, id eResponse) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
