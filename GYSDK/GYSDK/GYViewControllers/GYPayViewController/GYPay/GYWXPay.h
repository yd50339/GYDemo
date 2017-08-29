//
//  GYWXPay.h
//  GYSDK
//
//  Created by yd on 2017/8/7.
//  Copyright © 2017年 yd. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;
@interface GYWXPay : NSObject

+ (void)wxRegister;
+ (NSString *)jumpToBizPay;
+ (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url;
+ (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation;

@end
