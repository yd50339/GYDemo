//
//  GYBaseViewController.m
//  GYSDK
//
//  Created by yd on 2017/8/9.
//  Copyright © 2017年 yd. All rights reserved.
//

#import "GYBaseViewController.h"
#import "GYActivityView.h"

@interface GYBaseViewController ()

@end

@implementation GYBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    self.activityView = [[GYActivityView alloc]initWithFrame:CGRectMake(0,
                                                                        64,
                                                                        CGRectGetWidth(self.view.frame),
                                                                        CGRectGetHeight(self.view.frame))];
    self.activityView.hidden = YES;
    [self.view addSubview:self.activityView];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                      NSFontAttributeName:[UIFont systemFontOfSize:18.0]}];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    UIBarButtonItem * backButton = [[UIBarButtonItem alloc]initWithImage:[GYImage imagesFromCustomBundle:@"gy_back"]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(backButtonOnClick)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    UIImage * bgImage = [GYImage imagesFromCustomBundle:@"gy_titleBg"];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithPatternImage:bgImage]];

}

- (void)startLoading
{
    [self.activityView startAnimating];
}

- (void)stopLoading
{
    [self.activityView stopAnimating];
}


- (void)backButtonOnClick
{
    NSArray * viewcontrollers = self.navigationController.viewControllers;
    if (viewcontrollers.count > 1)
    {
        if ([viewcontrollers objectAtIndex:viewcontrollers.count - 1] == self)
        {
            //push方式
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else
    {
        //present方式
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    

}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
