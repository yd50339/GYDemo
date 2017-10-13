//
//  GYAlipay.h
//  GYSDK
//
//  Created by yd on 2017/8/7.
//  Copyright © 2017年 yd. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;
@interface GYAlipay : NSObject

+ (void)doAlipayPay:(NSString *)payDataStr;

+ (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation;

+ (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<NSString*, id> *)options;


@end
