//
//  YDKeyChain.h
//  YDSDK
//
//  Created by yd on 2017/8/15.
//  Copyright © 2017年 yd. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXTERN NSString * const kYDKeyChainKey;

@interface YDKeyChain : NSObject

//查询
+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service;
//保存
+ (void)addKeychainData:(id)data forKey:(NSString *)key;
//获取
+ (id)getKeychainDataForKey:(NSString *)key;
//删除
+ (void)deleteKeychainDataForKey:(NSString *)key;


@end
