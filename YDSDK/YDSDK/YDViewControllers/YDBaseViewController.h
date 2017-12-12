//
//  YDBaseViewController.h
//  YDSDK
//
//  Created by yd on 2017/8/9.
//  Copyright © 2017年 yd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDTextfieldView.h"
#import "YDImage.h"
#import "YDTipView.h"
#import "YDActivityView.h"
#import "YDRegular.h"
#import "YDNetwork.h"
#import "NSDictionary+YDUtils.h"
#import "YDKeyChain.h"
#import "YDUserModel.h"
@class YDActivityView;
@interface YDBaseViewController : UIViewController

@property(nonatomic , strong)YDActivityView * activityView;
- (void)startLoading;
- (void)stopLoading;

@end
