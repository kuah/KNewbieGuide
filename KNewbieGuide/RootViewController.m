//
//  RootViewController.m
//  KNewbieGuide
//
//  Created by 陈世翰 on 2018/1/9.
//  Copyright © 2018年 Kuah. All rights reserved.
//

#import "RootViewController.h"
#import "KNewbieGuide.h"
#import "FirstView.h"
#import "SecondView.h"
@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    [KNewbieGuide removeNewbieForKeys:@[@"new"]];
    [KNewbieGuide showInDebugMode:@"new"];
    //    [KNewbieGuide show:@"new" withImageName:@"登录_填写手机号",@"个人中心_展商中心_重置授权码",nil];
    [KNewbieGuide show:@"new" withView:[FirstView new],[SecondView new],nil];
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
