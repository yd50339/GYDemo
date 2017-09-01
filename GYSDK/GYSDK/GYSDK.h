//
//  GYSDK.h
//  GYSDK
//
//  Created by yd on 2017/7/31.
//  Copyright © 2017年 yd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GYSDK : NSObject

+ (void)goToLogin;
+ (BOOL)isLogin;
+ (void)goToPay;

+ (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation;

+ (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<NSString*, id> *)options;


+ (void)registerSdk;

@end
