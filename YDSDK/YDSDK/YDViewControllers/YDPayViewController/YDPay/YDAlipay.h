//
//  YDAlipay.h
//  YDSDK
//
//  Created by yd on 2017/8/7.
//  Copyright © 2017年 yd. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;
@interface YDAlipay : NSObject

typedef void(^ResObj)(NSDictionary * resObj);

+ (void)doAlipayPay:(NSString *)payDataStr  response:(ResObj)resObj;

+ (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation;

+ (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<NSString*, id> *)options;


@end
