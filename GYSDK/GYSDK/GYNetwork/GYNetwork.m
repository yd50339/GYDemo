//
//  Request.m
//  MyProject
//
//  Created by yd on 2017/7/21.
//  Copyright © 2017年 yd. All rights reserved.
//

#import "GYNetwork.h"
#import "GYRequestApi.h"
#import "GYKeyChain.h"
#import "NSDictionary+Utils.h"
#import "GYSDK.h"
@interface GYNetwork()

@end


@implementation GYNetwork


+ (GYNetwork *)network
{
    GYNetwork * request = [[GYNetwork alloc]init];
    return request;
}


- (void)requestwithParam:(NSDictionary *)param
                    path:(NSString *)path
                  method:(NSString *)method
                response:(ResponseHandle)res
{
//     180.97.83.230
    NSString * config = @"http://192.168.0.166:8080/GYDomestic/";
    NSString * urlStr  = [config stringByAppendingString:path];
    GYRequestApi * reqApi =  [[GYRequestApi alloc]init];
    NSString * httpMethod = method;
    NSMutableURLRequest * request = [reqApi requestWithMethod:httpMethod URLString:urlStr parameters:param error:nil];
    
    NSString * bundleId =   [[NSBundle mainBundle]bundleIdentifier];
    NSMutableDictionary * loginDict =  [[NSUserDefaults standardUserDefaults] objectForKey:bundleId];
    if ([loginDict stringForKey:@"token"].length > 0)
    {
        [request addValue:[loginDict stringForKey:@"token"] forHTTPHeaderField:@"token"];
    }
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithRequest:request
                                        completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                              {
                                  
                                  NSDictionary * resObj = nil;
                                  if (data.length > 0)
                                  {
                                      resObj = [NSJSONSerialization JSONObjectWithData:data
                                                                               options:NSJSONReadingMutableContainers
                                                                                 error:nil];
                                      BOOL isValidToken = [self isValidToken:resObj];
                                      if (isValidToken)
                                      {
                                          if (res)
                                          {
                                              res(resObj);
                                          }
                                      }
                                      else
                                      {
                                          [[GYNetwork network] requestwithParam:param
                                                                           path:path
                                                                         method:method
                                                                       response:^(NSDictionary *resObj)
                                           {
                                               
                                           }];
                                      }
                                  }
                                  
          
                              }];
    
    [task resume];

}


- (BOOL)isValidToken:(NSDictionary *)resObj
{
    NSString * bundleId =   [[NSBundle mainBundle]bundleIdentifier];
    NSMutableDictionary * loginDict =  [[NSUserDefaults standardUserDefaults] objectForKey:bundleId];
    NSString * status = [resObj stringForKey:@"status"];
    status = @"0405";
    if ([status isEqualToString:@"0208"])
    {
        NSString * token = [resObj stringForKey:@"token"];
        if (token.length > 0)
        {
            [loginDict setObject:token forKey:@"token"];
            [[NSUserDefaults standardUserDefaults] setObject:loginDict forKey:bundleId];
            [[NSUserDefaults standardUserDefaults]synchronize];
            return NO;
        }
    }
    if ([status isEqualToString:@"0405"] )
    {
        [GYSDK logout];
        [GYSDK gyLogin:^(NSDictionary *resObj) {
            
        }];
    }
    return YES;
}

@end
