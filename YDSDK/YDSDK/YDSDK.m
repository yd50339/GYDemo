//
//  YDSDK.m
//  YDSDK
//
//  Created by yd on 2017/7/31.
//  Copyright © 2017年 yd. All rights reserved.
//

#import "YDSDK.h"
#import "YDLoginViewController.h"
#import "YDPayViewController.h"
#import "YDImage.h"
#import "YDAlipay.h"
#import "YDWXPay.h"
#import "YDCusNavigationController.h"
#import "YDIAPHelper.h"


@implementation YDSDK

+ (void)registerApp:(NSString *)appId
{
    [YDWXPay wxRegister:appId];
}


+ (void)YDLogin:(ResponseObj)resObj
{
    YDLoginViewController * loginVc = [[YDLoginViewController alloc]init];
    loginVc.result = resObj;
    YDCusNavigationController * nav = [[YDCusNavigationController alloc]initWithRootViewController:loginVc];
    [[YDSDK getCurrentVC] presentViewController:nav animated:YES completion:nil];
}

+ (void)logout
{
    [[YDIAPHelper iapHelper] requestProductWithId:@"com.youda.lexiusanzhangpai.gold6"];
    return;
    NSString * bundleId =  [[NSBundle mainBundle]bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:bundleId];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)isLogin
{
    //    NSMutableDictionary * loginDict =  [YDKeyChain getKeychainQuery:kYDKeyChainKey];
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


+ (void)YDPay:(NSDictionary *)productInfo;
{
    if ([YDSDK isLogin])
    {
        YDPayViewController * payVc = [[YDPayViewController alloc]init];
        payVc.productInfo = productInfo;
        YDCusNavigationController * nav = [[YDCusNavigationController alloc]initWithRootViewController:payVc];
        [[YDSDK getCurrentVC] presentViewController:nav animated:YES completion:nil];
    }
    else
    {
        [YDSDK YDLogin:^(NSDictionary *resObj) {
            
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
        return  [YDAlipay application:application
                              openURL:url
                    sourceApplication:sourceApplication
                           annotation:annotation];
    }
    return  [YDWXPay application:application
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
        return  [YDAlipay application:app openURL:url options:options];
        
    }
    return [YDWXPay application:app handleOpenURL:url];
    
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



