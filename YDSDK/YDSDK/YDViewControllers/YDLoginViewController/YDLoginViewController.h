//
//  YDLoginViewController.h
//  YDSDK
//
//  Created by yd on 2017/7/31.
//  Copyright © 2017年 yd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDBaseViewController.h"
@interface YDLoginViewController : YDBaseViewController

typedef void(^Result)(NSDictionary * dict);
@property(nonatomic , copy)Result result;

@end
