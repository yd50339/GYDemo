//
//  GYImage.m
//  GYSDK
//
//  Created by yd on 2017/8/3.
//  Copyright © 2017年 yd. All rights reserved.
//

#import "GYImage.h"
@implementation GYImage

+ (UIImage *)imagesFromCustomBundle:(NSString *)imgName
{
    NSString * imgStr = [NSString stringWithFormat:@"%@.png",imgName];
    NSBundle * myBundle =[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"GYSDK" ofType:@"bundle"]];
    NSString * imgPath = [[myBundle resourcePath] stringByAppendingPathComponent:imgStr];
    UIImage * image = [UIImage imageWithContentsOfFile:imgPath];
    return image;
}

@end
