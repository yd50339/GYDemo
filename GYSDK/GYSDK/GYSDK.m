//
//  GYSDK.m
//  GYSDK
//
//  Created by yd on 2017/7/31.
//  Copyright © 2017年 yd. All rights reserved.
//

#import "GYSDK.h"
#import "GYLoginViewController.h"
#import "GYPayViewController.h"
#import "GYImage.h"
#import "GYAlipay.h"
#import "GYWXPay.h"
#import "GYCusNavigationController.h"


@implementation GYSDK

+ (void)registerApp:(NSString *)gameId
{
    [GYWXPay wxRegister];
}


+ (void)gyLogin:(ResponseObj)resObj
{
    GYLoginViewController * loginVc = [[GYLoginViewController alloc]init];
    loginVc.result = resObj;
    GYCusNavigationController * nav = [[GYCusNavigationController alloc]initWithRootViewController:loginVc];
    [[GYSDK getCurrentVC] presentViewController:nav animated:YES completion:nil];
}

+ (void)logout
{
    NSString * bundleId =   [[NSBundle mainBundle]bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:bundleId];
}

+ (BOOL)isLogin
{
//    NSMutableDictionary * loginDict =  [GYKeyChain getKeychainQuery:kGYKeyChainKey];
    NSString * bundleId =   [[NSBundle mainBundle]bundleIdentifier];
    NSMutableDictionary * loginDict =  [[NSUserDefaults standardUserDefaults] objectForKey:bundleId];
    NSLog(@"%@",loginDict);

    if ([loginDict stringForKey:@"token"].length > 0)
    {
        NSLog(@"已经登录过");
        return YES;
    }
    else
    {
        NSLog(@"未登录或者过期");
        return NO;
    }
    return NO;
    
}


+ (void)gyPay:(NSDictionary *)productInfo;
{
    if ([GYSDK isLogin])
    {
        GYPayViewController * payVc = [[GYPayViewController alloc]init];
        payVc.productInfo = productInfo;
        GYCusNavigationController * nav = [[GYCusNavigationController alloc]initWithRootViewController:payVc];
        [[GYSDK getCurrentVC] presentViewController:nav animated:YES completion:nil];
    }
    else
    {
        [GYSDK gyLogin:^(NSDictionary *resObj) {
            
        }];
    }
    
}

#pragma mark - 应用跳转

+ (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation;
{
    if ([url.host isEqualToString:@"safepay"])
    {
       return  [GYAlipay application:application
                             openURL:url
                   sourceApplication:sourceApplication
                          annotation:annotation];
    }
    return  [GYWXPay application:application
                         openURL:url
               sourceApplication:sourceApplication
                      annotation:annotation];
}

+ (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"])
    {
        return  [GYAlipay application:app openURL:url options:options];

    }
    return [GYWXPay application:app handleOpenURL:url];

}



+ (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}


@end


