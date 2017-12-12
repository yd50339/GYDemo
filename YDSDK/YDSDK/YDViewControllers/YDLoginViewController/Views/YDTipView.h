//
//  YDTipView.h
//  YDSDK
//
//  Created by yd on 2017/8/3.
//  Copyright © 2017年 yd. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^Completion)(BOOL finished);

@interface YDTipView : UIView

- (id)initWithMsg:(NSString *)message;

- (void)showAnimation;

- (void)showAnimation:(Completion)completion;

@end
