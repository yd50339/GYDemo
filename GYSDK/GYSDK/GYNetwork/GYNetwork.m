//
//  Request.m
//  MyProject
//
//  Created by yd on 2017/7/21.
//  Copyright © 2017年 yd. All rights reserved.
//

#import "GYNetwork.h"
#import "GYRequestApi.h"

@interface GYNetwork()

@end


@implementation GYNetwork


+ (GYNetwork *)network
{
    GYNetwork * request = [[GYNetwork alloc]init];
    return request;
}


- (void)requestwithParam:(NSDictionary *)param
                  method:(NSString *)method
                response:(ResponseHandle)res
{

    NSString * config = @"http://39.108.116.166:8888/GYTechnology/";
    NSString * urlStr  = [config stringByAppendingString:method];
    GYRequestApi * reqApi =  [[GYRequestApi alloc]init];
    NSString * httpMethod = @"POST";
    NSMutableURLRequest * request = [reqApi requestWithMethod:httpMethod URLString:urlStr parameters:param error:nil];
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
