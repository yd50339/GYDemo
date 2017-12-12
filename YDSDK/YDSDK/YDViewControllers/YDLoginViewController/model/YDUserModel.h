//
//  YDUserModel.h
//  YDSDK
//
//  Created by yd on 2017/9/8.
//  Copyright © 2017年 yd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDUserModel : NSObject

@property(nonatomic , copy)NSString *  userName;
@property(nonatomic , copy)NSString *  phone;
@property(nonatomic , copy)NSString *  email;
@property(nonatomic , copy)NSString *  password;
@property(nonatomic , copy)NSString *  secPassword;
@property(nonatomic , copy)NSString *  clientcode;

@end
