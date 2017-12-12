//
//  NSDictionary+Utils.m
//  WLTProject
//
//  Created by yd on 13-1-21.
//  Copyright (c) 2013年 yd. All rights reserved.
//

#import "NSDictionary+YDUtils.h"

@implementation NSDictionary (YDUtils)

- (NSString *)stringForKey:(id)key
{
    id obj = [self objectForKey:key];
    if (obj)
    {
        if ([obj isKindOfClass:[NSString class]])
        {
            return (NSString *)obj;
        }
        else if ([obj isKindOfClass:[NSNumber class]])
        {
            return [(NSNumber *)obj stringValue];
        }
    }
    return @"";
}

- (NSInteger)integerForKey:(id)key
{
    id obj = [self objectForKey:key];
    if (obj)
    {
        if ([obj isKindOfClass:[NSString class]])
        {
            return [(NSString *)obj integerValue];
        }
        else if ([obj isKindOfClass:[NSNumber class]])
        {
            return [(NSNumber *)obj integerValue];
        }
    }
    return 0;
}

- (double)doubleForKey:(id)key
{
    id obj = [self objectForKey:key];
    if (obj)
    {
        if ([obj isKindOfClass:[NSString class]])
        {
            return [(NSString *)obj doubleValue];
        }
        else if ([obj isKindOfClass:[NSNumber class]])
        {
            return [(NSNumber *)obj doubleValue];
        }
    }
    return 0;
}

- (NSArray *)arrayForKey:(id)key
{
    id obj = [self objectForKey:key];
    if (obj && [obj isKindOfClass:[NSArray class]]) {
        return (NSArray *)obj;
    }
    return nil;
}

- (NSDictionary *)dictForKey:(id)key
{
    id obj = [self objectForKey:key];
    if (obj && [obj isKindOfClass:[NSDictionary class]]) {
        return (NSDictionary *)obj;
    }
    return nil;
}


- (NSString *)stringForKeyPath:(NSString *)keyPath
{
    id value = [self valueForKeyPath:keyPath];
    if (value)
    {
        if ([value isKindOfClass:[NSString class]])
        {
            return (NSString *)value;
        }
        else if ([value isKindOfClass:[NSNumber class]])
        {
            return [(NSNumber *)value stringValue];
        }
    }
    return @"";
}

- (NSInteger)integerForKeyPath:(NSString *)keyPath
{
    id value = [self valueForKeyPath:keyPath];
    if (value)
    {
        if ([value isKindOfClass:[NSString class]])
        {
            return [(NSString *)value integerValue];
        }
        else if ([value isKindOfClass:[NSNumber class]])
        {
            return [(NSNumber *)value integerValue];
        }
    }
    
    return 0;
}

- (double)doubleForKeyPath:(NSString *)keyPath
{
    id value = [self valueForKeyPath:keyPath];
    if (value)
    {
        if ([value isKindOfClass:[NSString class]])
        {
            return [(NSString *)value doubleValue];
        }
        else if ([value isKindOfClass:[NSNumber class]])
        {
            return [(NSNumber *)value doubleValue];
        }
    }
    
    return 0;
}


- (NSArray *)arrayForKeyPath:(NSString *)keyPath
{
    id value = [self valueForKeyPath:keyPath];
    if (value && [value isKindOfClass:[NSArray class]]) {
        return (NSArray *)value;
    }
    return nil;
}

- (NSDictionary *)dictForKeyPath:(NSString *)keyPath
{
    id value = [self valueForKeyPath:keyPath];
    if (value && [value isKindOfClass:[NSDictionary class]]) {
        return (NSDictionary *)value;
    }
    return nil;
}

@end

@implementation NSMutableDictionary (YDUtils)

@end
