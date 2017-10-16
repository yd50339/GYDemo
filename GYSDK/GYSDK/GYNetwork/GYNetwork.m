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

    NSString * config = @"http://192.168.0.115:8080/GYForeign/";
    NSString * urlStr  = [config stringByAppendingString:path];
    GYRequestApi * reqApi =  [[GYRequestApi alloc]init];
    NSString * httpMethod = method;
    NSMutableURLRequest * request = [reqApi requestWithMethod:httpMethod URLString:urlStr parameters:param error:nil];
    
    NSMutableDictionary * loginDict =  [[NSUserDefaults standardUserDefaults] objectForKey:kGYKeyChainKey];
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
                                  }
                                  
                                  if (res)
                                  {
                                      res(resObj);
                                  }
                                  
                                  
                              }];
    
    [task resume];

}

@end
