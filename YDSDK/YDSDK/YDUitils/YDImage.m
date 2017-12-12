//
//  YDImage.m
//  YDSDK
//
//  Created by yd on 2017/8/3.
//  Copyright © 2017年 yd. All rights reserved.
//

#import "YDImage.h"
@implementation YDImage

+ (UIImage *)imagesFromCustomBundle:(NSString *)imgName
{
    NSBundle * myBundle =[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"YDSDK" ofType:@"bundle"]];
    NSString * imgStr = [NSString stringWithFormat:@"%@",imgName];
    NSString * imgPath = [[myBundle resourcePath] stringByAppendingPathComponent:imgStr];
    UIImage * image = [UIImage imageWithContentsOfFile:imgPath];
    return image;
}

@end
