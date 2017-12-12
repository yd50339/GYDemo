//
//  YDWXPay.m
//  YDSDK
//
//  Created by yd on 2017/8/7.
//  Copyright © 2017年 yd. All rights reserved.
//

#import "YDWXPay.h"
#import "WXApiObject.h"
#import "WXApi.h"
#import "WechatAuthSDK.h"
#import "WXApiManager.h"
#import "NSDictionary+YDUtils.h"

@interface YDWXPay()<WXApiDelegate>

@end
@implementation YDWXPay


+ (void)wxRegister:(NSString *)appId
{
    [WXApi registerApp:appId];
}

+ (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}

+ (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}


+ (NSString *)jumpToBizPay:(NSDictionary *)params
{
//    time_t now;
//    time(&now);
    NSString * package = @"Sign=WXPay";
    
    NSString *ts = [params stringForKey:@"timestamp"];

    
    //调起微信支付
    PayReq* req             = [[PayReq alloc] init];
    req.openID              = @"wx1b60b28c4f8d8908";
    req.partnerId           = [params stringForKey:@"partnerid"];
    req.prepayId            = [params stringForKey:@"prepayid"];
    req.nonceStr            = [params stringForKey:@"noncestr"];
    req.timeStamp           = (UInt32) ts.intValue;
    req.package             = package;
    req.sign                = [params stringForKey:@"sign"];
    
//    NSString * msg = [NSString stringWithFormat:@"appid=%@\npartnerid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",req.openID,req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign];
//    UIAlertView * alert  = [[UIAlertView alloc]initWithTitle:@"11" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil   , nil];
//    [alert show];
 NSLog(@"appid=%@\npartnerid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",req.openID,req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
    
     [WXApi sendReq:req];
    //日志输出
 
    return @"";

}


@end
