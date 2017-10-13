//
//  ViewController.m
//  GYSDKDemo
//
//  Created by yd on 2017/7/31.
//  Copyright © 2017年 yd. All rights reserved.
//

#import "ViewController.h"
@import GYSDK;

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    UIButton * loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(0, 0, 100, 50);
    loginBtn.center = self.view.center;
    [loginBtn addTarget:self action:@selector(loginBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    loginBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    loginBtn.layer.borderColor = [UIColor blackColor].CGColor;
    loginBtn.layer.borderWidth = 1;
    [self.view addSubview:loginBtn];
    
    
    
    UIButton * payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    payBtn.frame = CGRectMake(CGRectGetMinX(loginBtn.frame), CGRectGetMaxY(loginBtn.frame), 100, 50);
    [payBtn addTarget:self action:@selector(payBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    [payBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [payBtn setTitle:@"支付" forState:UIControlStateNormal];
    payBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    payBtn.layer.borderColor = [UIColor blackColor].CGColor;
    payBtn.layer.borderWidth = 1;
    [self.view addSubview:payBtn];

    
}

- (void)loginBtnOnClick
{
    [GYSDK gyLogin:^(NSDictionary *result) {
        NSLog(@"%@",result);
        
    }];

}

- (void)payBtnOnClick
{
//    [GYSDK gyPay];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}


@end
