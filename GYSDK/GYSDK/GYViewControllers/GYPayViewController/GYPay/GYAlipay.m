//
//  GYAlipay.m
//  GYSDK
//
//  Created by yd on 2017/8/7.
//  Copyright © 2017年 yd. All rights reserved.
//

#import "GYAlipay.h"
#import "GYOrder.h"
#import "AlipaySDK.h"
//#import "RSADataSigner.h"
@implementation GYAlipay


+ (void)doAlipayPay
{
    NSString * appID = @"2017082308340631";
    NSString * rsaPrivateKey =
    @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAMfKThajoMybmDcqTScB5n6S8iyhb3HBtu/fib/XxkwZsEOkqGBcHAmiGxX/cNY5/CO97ofc++TO1h5Cwaj6r4Mu1ZtCx5PFZ84dWk86gpjtz9Ccd4F04kZdUtyoZBKKY5TqhYBtihwCdq8qWzgr9ASWfJFxw2mKLiPtpoeVynnZAgMBAAECgYEAxUA3WKK0X04/OjfJdHmr18u8zdOU8/sNYkaQ+ZdPcFLsc9xdYMWP6PLjSxSnktos1hzvI7RJ/d04CShfizX1kQ+z/Xu7TTNh3dz/rUF8jMUr3t+u0Cp3spsoL0TItuPwsOBxCJzRVd1xwMVjZzSg8jJzPzDdTCkk5fyWM+hXqwECQQDutFnqMzEGeZQKZoHFC0sh15iegUfk4QsWf79sWXuz9QQjrRTG+Yz/JUqaCO36urusM51IPdKk4sjfx6wODfxLAkEA1kQljor7P+JB7ZzozSqGAOurKLNwqc01H/oRaKOMR3ZVNBmWY50E024jxp6Vjh8M05nJOd458L+FdjXFgZ0D6wJAF1jYeomrP+DgU+wWwTkLjjHSIZ6vc3l3Zin0hRpzePR8BSlGoPeDjOkO1OYOsLlW5c7ekVRKqAnub8TN1UoU5QJAfri/HZbFEftW0plCdlT3/ANlrySxNTvQd6EGOsS/amRp7+5SK4fqGsHBFu8jtHJYu6zwffEYg3JCFK+oqAedEQJAUg8SddLT5aNz/wFUUZVsLWRym/JiTjhRwOLELhxA8QGFUfPSos99HlLM2JBdx6IwlXTGv5jMhcc5Z0fUh3tQ3w==";
    NSString * rsa2PrivateKey = @"";
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    GYOrder* order = [GYOrder new];
    
    // NOTE: app_id设置
    order.app_id = appID;
    
    // NOTE: 支付接口名称
    order.method = @"alipay.trade.app.pay";
    
    // NOTE: 参数编码格式
    order.charset = @"utf-8";
    
    // NOTE: 当前时间点
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    order.timestamp = [formatter stringFromDate:[NSDate date]];
    
    // NOTE: 支付版本
    order.version = @"1.0";
    
    // NOTE: sign_type 根据商户设置的私钥来决定
    order.sign_type = (rsa2PrivateKey.length > 1)?@"RSA2":@"RSA";
    
    // NOTE: 商品数据
    order.biz_content = [BizContent new];
    order.biz_content.body = @"我是测试数据";
    order.biz_content.subject = @"1";
    order.biz_content.out_trade_no = [self generateTradeNO]; //订单ID（由商家自行制定）
    order.biz_content.timeout_express = @"30m"; //超时时间设置
    order.biz_content.total_amount = [NSString stringWithFormat:@"%.2f", 0.01]; //商品价格
    
    //将商品信息拼接成字符串
    NSString *orderInfo = [order orderInfoEncoded:NO];
    NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
    NSLog(@"orderSpec = %@",orderInfo);
    
    // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
    //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
    NSString *signedString = nil;
//    RSADataSigner* signer = [[RSADataSigner alloc] initWithPrivateKey:((rsa2PrivateKey.length > 1)?rsa2PrivateKey:rsaPrivateKey)];
//    if ((rsa2PrivateKey.length > 1)) {
//        signedString = [signer signString:orderInfo withRSA2:YES];
//    } else {
//        signedString = [signer signString:orderInfo withRSA2:NO];
//    }

//    // NOTE: 如果加签成功，则继续执行支付
    if (signedString != nil)
    {
//        //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
        NSString *appScheme = @"alisdkdemo";
//
//        // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
                                 orderInfoEncoded, signedString];
//
        // NOTE: 调用支付结果开始支付
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
        }];
    }



}


+ (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}



+ (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    if ([url.host isEqualToString:@"safepay"])
    {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }
    return YES;
}

// NOTE: 9.0以后使用新API接口
+ (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"])
    {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }
    return YES;
}




@end
