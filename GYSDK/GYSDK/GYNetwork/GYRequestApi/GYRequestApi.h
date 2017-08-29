//
//  RequestApi.h
//  MyProject
//
//  Created by yd on 2017/7/20.
//  Copyright © 2017年 yd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYRequestApi : NSObject


- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                 URLString:(NSString *)URLString
                                parameters:(NSDictionary *)parameters
                                     error:(NSError * __autoreleasing *)error;

@end
