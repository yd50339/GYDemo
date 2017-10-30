//
//  GYPasswordViewController.m
//  GYSDK
//
//  Created by yd on 2017/8/2.
//  Copyright © 2017年 yd. All rights reserved.
//

#import "GYPasswordViewController.h"
@interface GYPasswordViewController ()
<GYTextfieldViewDelegate>
@property(nonatomic , strong)GYTextfieldView * firstPsd;
@property(nonatomic , strong)GYTextfieldView * secondPsd;
@property(nonatomic , strong)GYUserModel * userModel;
@property(nonatomic , strong)UIButton * confirmBtn;
@property(nonatomic , assign)BOOL isRequesting;

@end

@implementation GYPasswordViewController


- (void)loadView
{
    self.view = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"忘记密码";
    
    self.firstPsd = [[GYTextfieldView alloc]initWithFrame:CGRectMake(0, 120, CGRectGetWidth(self.view.frame), 40)];
    self.firstPsd.delegate = self;
    [self.firstPsd setPlaceholder:@"请输入新密码" imageNamed:@"gy_password"];
    self.firstPsd.textField.secureTextEntry = YES;
    [self.view addSubview:self.firstPsd];
    
    
    self.secondPsd = [[GYTextfieldView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.firstPsd.frame) + 20, CGRectGetWidth(self.view.frame), 40)];
    self.secondPsd.delegate = self;
    [self.secondPsd setPlaceholder:@"请再次输入新密码" imageNamed:@"gy_password"];
    self.secondPsd.textField.secureTextEntry = YES;
    [self.view addSubview:self.secondPsd];
    
    
    UIImage * confirmImage = [GYImage imagesFromCustomBundle:@"gy_button"];
    CGRect confirmRect = CGRectZero;
    confirmRect.size.width = confirmImage.size.width;
    confirmRect.size.height = confirmImage.size.height;
    confirmRect.origin.x = (CGRectGetWidth(self.view.frame) - CGRectGetWidth(confirmRect)) * 0.5;
    confirmRect.origin.y = CGRectGetMaxY(self.secondPsd.frame) + 40;
    self.confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.confirmBtn.frame = confirmRect;
    [self.confirmBtn addTarget:self action:@selector(confirmBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.confirmBtn setBackgroundImage:confirmImage forState:UIControlStateNormal];
    [self.confirmBtn setTitle:@"保存" forState:UIControlStateNormal];
    [self.confirmBtn setTitleEdgeInsets:UIEdgeInsetsMake(-8, 0, 0, 0)];
    [self.confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.confirmBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.confirmBtn];

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.userModel = [[GYUserModel alloc]init];
    
}


- (void)showResultView
{
    UIView * bgView = [[UIView alloc]initWithFrame:self.view.frame];
    bgView.backgroundColor = [UIColor colorWithRed:130/255.0 green:130/255.0 blue:130/255.0 alpha:0.8];
    [self.view addSubview:bgView];
    
    UIView * contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 250, 150)];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.center = bgView.center;
    contentView.layer.cornerRadius = CGRectGetHeight(contentView.frame) * 0.1;
    [bgView addSubview:contentView];
    
    UIImage * image = [GYImage imagesFromCustomBundle:@"gy_confirm"];
    UIImageView * circusImageView = [[UIImageView alloc]initWithFrame:CGRectMake((CGRectGetWidth(contentView.frame) - image.size.width) * 0.5, 26, image.size.width, image.size.height)];
    circusImageView.image = image;
    [contentView addSubview:circusImageView];
    
    
    CGRect rect = CGRectZero;
    rect.size.width = 140;
    rect.size.height = 40;
    rect.origin.x = (CGRectGetWidth(contentView.frame) - CGRectGetWidth(rect)) * 0.5;
    rect.origin.y = CGRectGetMaxY(circusImageView.frame) + 5;
    UILabel * label = [[UILabel alloc]initWithFrame:rect];
    label.textColor = [UIColor colorWithRed:45/255.0 green:45/255.0 blue:45/255.0 alpha:1];
    label.text = @"密码修改成功";
    label.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:label];

}

- (BOOL)checkChangePsd
{
    if ([GYRegular validatePassword:self.firstPsd.textField.text] &&
        [GYRegular validatePassword:self.secondPsd.textField.text] &&
        [self.firstPsd.textField.text isEqualToString:self.secondPsd.textField.text])
    {
        NSString * firstPassword = self.firstPsd.textField.text;
        NSString * secondPassword = self.secondPsd.textField.text;
        
        self.userModel.phone = self.phoneNum;
        self.userModel.password = firstPassword;
        self.userModel.secPassword = secondPassword;

        return YES;
    }
    if (![GYRegular validatePassword:self.firstPsd.textField.text] ||
        ![GYRegular validatePassword:self.secondPsd.textField.text])
    {
        [[[GYTipView alloc]initWithMsg:@"密码至少为8位以上数字字母"] showAnimation];
    }
    else if (![self.firstPsd.textField.text isEqualToString:self.secondPsd.textField.text])
    {
        [[[GYTipView alloc]initWithMsg:@"请确认两次密码相同"] showAnimation];

    }
    return NO;

}

#pragma mark - ButtonOnClick

- (void)confirmBtnOnClick
{
    if ([self checkChangePsd])
    {
       [self changePsdRequest:self.userModel];
    }
}


#pragma mark -  Register Request

- (void)changePsdRequest:(GYUserModel *)userModel
{
    if (self.isRequesting)
    {
        return;
    }
    self.isRequesting = YES;
    [self startLoading];
    NSDictionary * param = @{@"username":userModel.phone ? :@"",
                             @"password": userModel.password ? :@"",
                             @"confirmpass":userModel.secPassword ? :@""};
    __weak typeof (self)wself = self;
    [[GYNetwork network]requestwithParam:param
                                    path:@"user/forgetpasstwo"
                                  method:@"PUT"
                                response:^(NSDictionary *resObj)
     {
         NSLog(@"修改密码：%@",resObj);
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString * status = [resObj stringForKey:@"status"];
             if ([status isEqualToString:@"0200"])
             {
                 [wself showResultView];
                 [wself performSelector:@selector(goBack) withObject:nil afterDelay:1];
             }
             else
             {
                 [[[GYTipView alloc]initWithMsg:@"密码修改失败"] showAnimation];
             }
             wself.isRequesting = NO;
             [wself stopLoading];
             
         });

     }];
}

- (void)goBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Delegate

- (void)textFieldDidEndEditing:(UITextField *)textField
                 textFieldView:(GYTextfieldView *)view
{
    
//    if (view == self.firstPsd)
//    {
//        if (![GYRegular validatePassword:textField.text])
//        {
//            [[[GYTipView alloc]initWithMsg:@"密码格式不正确"] showAnimation];
//        }
//        
//    }
//    
//    if (view == self.secondPsd)
//    {
//        if (![GYRegular validatePassword:textField.text])
//        {
//            [[[GYTipView alloc]initWithMsg:@"密码格式不正确"] showAnimation];
//        }
//        
//    }

}

- (BOOL)textFieldShouldReturn:(UITextField *)aTextfield
                textFieldView:(GYTextfieldView *)view
{
    return YES;
    
}



@end
