//
//  GYCusNavigationController.m
//  GYSDK
//
//  Created by yd on 2017/10/17.
//  Copyright © 2017年 yd. All rights reserved.
//

#import "GYCusNavigationController.h"

@interface GYCusNavigationController ()

@end

@implementation GYCusNavigationController

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
