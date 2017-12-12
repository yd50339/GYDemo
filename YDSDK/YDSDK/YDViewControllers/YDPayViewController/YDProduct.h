//
//  YDProduct.h
//  YDSDK
//
//  Created by yd on 2017/10/13.
//  Copyright © 2017年 yd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDProduct : NSObject
//商品数量
@property(nonatomic , copy)NSString *  number;
//商品名称
@property(nonatomic , copy)NSString *  name;
//商品价格
@property(nonatomic , copy)NSString *  price;

@end
