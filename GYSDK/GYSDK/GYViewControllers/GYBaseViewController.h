//
//  GYBaseViewController.h
//  GYSDK
//
//  Created by yd on 2017/8/9.
//  Copyright © 2017年 yd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYTextfieldView.h"
#import "GYImage.h"
#import "GYTipView.h"
#import "GYActivityView.h"
#import "GYRegular.h"
#import "GYNetwork.h"
#import "NSDictionary+Utils.h"
#import "GYKeyChain.h"
#import "GYEncrypto.h"
@class GYActivityView;
@interface GYBaseViewController : UIViewController

@property(nonatomic , strong)GYActivityView * activityView;
- (void)startLoading;
- (void)stopLoading;

@end
