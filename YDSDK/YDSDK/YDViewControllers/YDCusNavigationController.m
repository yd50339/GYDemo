//
//  YDCusNavigationController.m
//  YDSDK
//
//  Created by yd on 2017/10/17.
//  Copyright © 2017年 yd. All rights reserved.
//

#import "YDCusNavigationController.h"

@interface YDCusNavigationController ()

@end

@implementation YDCusNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldAutorotate
{
    return NO;
    //return [self.viewControllers.lastObject shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return  UIInterfaceOrientationPortrait ;
}

@end
