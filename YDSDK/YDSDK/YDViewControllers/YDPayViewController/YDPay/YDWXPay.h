//
//  YDWXPay.h
//  YDSDK
//
//  Created by yd on 2017/8/7.
//  Copyright © 2017年 yd. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;
@interface YDWXPay : NSObject

+ (void)wxRegister:(NSString *)appId;
+ (NSString *)jumpToBizPay:(NSDictionary *)params;
+ (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url;
+ (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation;

@end
