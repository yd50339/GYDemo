//
//  NSDictionary+Utils.h
//  WLTProject
//
//  Created by yd on 13-1-21.
//  Copyright (c) 2013年 yd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (YDUtils)

- (NSString *)stringForKey:(id)key;
- (NSInteger)integerForKey:(id)key;
- (double)doubleForKey:(id)key;
- (NSArray *)arrayForKey:(id)key;
- (NSDictionary *)dictForKey:(id)key;

- (NSString *)stringForKeyPath:(NSString *)keyPath;
- (NSInteger)integerForKeyPath:(NSString *)keyPath;
- (double)doubleForKeyPath:(NSString *)keyPath;
- (NSArray *)arrayForKeyPath:(NSString *)keyPath;
- (NSDictionary *)dictForKeyPath:(NSString *)keyPath;

@end

@interface NSMutableDictionary (YDUtils)


@end
