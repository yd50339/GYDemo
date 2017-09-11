//
//  GYLoginViewController.h
//  GYSDK
//
//  Created by yd on 2017/7/31.
//  Copyright © 2017年 yd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYBaseViewController.h"
@interface GYLoginViewController : GYBaseViewController

typedef void(^Result)(NSDictionary * dict);
@property(nonatomic , copy)Result result;

@end
