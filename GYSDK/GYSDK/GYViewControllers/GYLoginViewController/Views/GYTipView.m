//
//  GYTipView.m
//  GYSDK
//
//  Created by yd on 2017/8/3.
//  Copyright © 2017年 yd. All rights reserved.
//

#import "GYTipView.h"

@implementation GYTipView

- (id)initWithMsg:(NSString *)message
{
    if (self)
    {
        self = [super init];
        self.frame = [UIScreen mainScreen].bounds;
        [self loadView:message];
    }
    
    return self;
}

- (void)loadView:(NSString *)message
{
    CGFloat width = [self calculateRowWidth:message];
    CGRect rect = CGRectZero;
    rect.size.width  = width + 30;
    rect.size.height = 40;
    UILabel * label = [[UILabel alloc]initWithFrame:rect];
    label.backgroundColor = [UIColor colorWithRed:56/255.0 green:56/255.0 blue:56/255.0 alpha:0.8];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = message;
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor whiteColor];
    label.layer.cornerRadius = CGRectGetHeight(rect) * 0.5;
    label.layer.masksToBounds = YES;
    label.center = self.center;
    [self addSubview:label];

    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
   
}

- (CGFloat)calculateRowWidth:(NSString *)string
{
    NSDictionary * dic = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    CGRect rect = [string boundingRectWithSize:CGSizeMake(0, 40) options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.width;
}

- (void)showAnimation
{
    [self showAnimation:nil];
}

- (void)showAnimation:(Completion)completion
{
    [UIView animateWithDuration:1 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:2 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            if (completion)
            {
                completion(YES);
            }
            [self removeFromSuperview];
        }];
    }];

}

@end
