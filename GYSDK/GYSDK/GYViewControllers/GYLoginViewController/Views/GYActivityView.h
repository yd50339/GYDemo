//
//  GYActivityView.h
//  GYSDK
//
//  Created by yd on 2017/8/3.
//  Copyright © 2017年 yd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYActivityView : UIView

@property(nonatomic , strong)UIActivityIndicatorView * activity;
- (void)stopAnimating;
- (void)startAnimating;
@end
