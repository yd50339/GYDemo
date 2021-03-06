//
//  Request.h
//  MyProject
//
//  Created by yd on 2017/7/21.
//  Copyright © 2017年 yd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ResponseHandle)(NSDictionary * resObj);

@interface YDNetwork : NSObject

+ (YDNetwork *)network;

- (void)requestwithParam:(NSDictionary *)param
                    path:(NSString *)path
                  method:(NSString *)method
                response:(ResponseHandle)res;

@end
