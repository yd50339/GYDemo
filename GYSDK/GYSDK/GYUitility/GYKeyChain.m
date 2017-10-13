//
//  GYKeyChain.m
//  GYSDK
//
//  Created by yd on 2017/8/15.
//  Copyright © 2017年 yd. All rights reserved.
//

#import "GYKeyChain.h"
@implementation GYKeyChain

NSString * const kGYKeyChainKey = @"com.gy.keychain";

//查询
+ (NSMutableDictionary *)getKeychainQuery:(NSString *)key
{
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (id)kSecClassGenericPassword,(id)kSecClass,
            key, (id)kSecAttrService,
            key, (id)kSecAttrAccount,
            (id)kSecAttrAccessibleAfterFirstUnlock,(id)kSecAttrAccessible,
            nil];
}

//保存
+ (void)addKeychainData:(id)data forKey:(NSString *)key
{
    //获取查询字典
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:key];
    //在删除之前先删除旧数据
    SecItemDelete((CFDictionaryRef)keychainQuery);
    //添加新的数据到字典
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:key];
    //将数据字典添加到钥匙串
    SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
}


//获取
+ (id)getKeychainDataForKey:(NSString *)key
{
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:key];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", key, e);
        } @finally {
        }
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}


//删除
+ (void)deleteKeychainDataForKey:(NSString *)key
{
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:key];
    SecItemDelete((CFDictionaryRef)keychainQuery);
}


@end
