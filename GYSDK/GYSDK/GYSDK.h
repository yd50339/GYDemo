//
//  GYSDK.h
//  GYSDK
//
//  Created by yd on 2017/7/31.
//  Copyright © 2017年 yd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ResponseObj)(NSDictionary * resObj);

@interface GYSDK : NSObject

//注册app
+ (void)registerApp;

//登录状态
+ (BOOL)isLogin;

//登录
+ (void)gyLogin;

//登录  返回登录信息
+ (void)gyLogin:(ResponseObj)resObj;

//支付
+ (void)gyPay;

+ (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation;

+ (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<NSString*, id> *)options;



@end
