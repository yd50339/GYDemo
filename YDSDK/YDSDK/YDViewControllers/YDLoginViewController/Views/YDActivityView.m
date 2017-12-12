//
//  YDActivityView.m
//  YDSDK
//
//  Created by yd on 2017/8/3.
//  Copyright © 2017年 yd. All rights reserved.
//

#import "YDActivityView.h"

@interface YDActivityView()

@end
@implementation YDActivityView

- (id)initWithFrame:(CGRect)frame
{
    if (self)
    {
        self = [super initWithFrame:frame];
    }
    
    [self createActivity];
    return self;

}

- (void)createActivity
{
    CGRect rect = self.frame;
    rect.size.width = 100;
    rect.size.height = 80;
    rect.origin.x = (CGRectGetWidth(self.frame) - CGRectGetWidth(rect)) * 0.5;
    rect.origin.y = (CGRectGetWidth(self.frame) - CGRectGetHeight(rect)) * 0.5 + rect.origin.y;
    UIView * bgView = [[UIView alloc]initWithFrame:rect];
    bgView.backgroundColor = [UIColor colorWithRed:30/255.0 green:30/255.0 blue:30/255.0 alpha:0.8];
    bgView.layer.cornerRadius = CGRectGetHeight(bgView.frame) * 0.2;
    [self addSubview:bgView];
    
    
    CGRect activityRect = bgView.frame;
    activityRect.size.width = 37;
    activityRect.size.height = 37;
    activityRect.origin.x = (CGRectGetWidth(bgView.frame) - CGRectGetWidth(activityRect)) * 0.5;
    activityRect.origin.y = (CGRectGetHeight(bgView.frame) - CGRectGetHeight(activityRect)) * 0.5;
    self.backgroundColor = [UIColor clearColor];
    self.activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activity.frame = activityRect;
    [bgView addSubview:self.activity];
    self.activity.hidesWhenStopped = YES;
    
}

- (void)stopAnimating
{
    self.hidden = YES;
    [self.activity stopAnimating];
}

- (void)startAnimating
{
    self.hidden = NO;
    [self.activity startAnimating];
}

@end
