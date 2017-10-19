//
//  GYRegisterViewController.m
//  GYSDK
//
//  Created by yd on 2017/8/1.
//  Copyright © 2017年 yd. All rights reserved.
//

#import "GYRegisterViewController.h"
#import "GYTextfieldView.h"
#import "GYImage.h"
@interface GYRegisterViewController ()
<GYTextfieldViewDelegate>
@property(nonatomic , strong)GYTextfieldView * phoneTextView;
@property(nonatomic , strong)GYTextfieldView * verifyCodeView;
@property(nonatomic , strong)GYTextfieldView * passwordTextView;
@property(nonatomic , strong)GYUserModel * userModel;
@property(nonatomic , strong)UIButton * registerBtn;
@end

@implementation GYRegisterViewController


- (void)loadView
{
    self.view = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"注册";
    
    self.phoneTextView = [[GYTextfieldView alloc]initWithFrame:CGRectMake(0, 120, CGRectGetWidth(self.view.frame), 40)];
    [self.phoneTextView setPlaceholder:@"请输入手机号码" imageNamed:@"gy_phone"];
    self.phoneTextView.delegate = self;
    [self.view addSubview:self.phoneTextView];
    
    self.verifyCodeView = [[GYTextfieldView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.phoneTextView.frame) + 20, CGRectGetWidth(self.view.frame), 40)];
    [self.verifyCodeView setPlaceholder:@"请输入验证码" imageNamed:@"gy_password"];
    self.verifyCodeView.isMessage = YES;
    self.verifyCodeView.delegate = self;
    [self.view addSubview:self.verifyCodeView];
    
    self.passwordTextView = [[GYTextfieldView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.verifyCodeView.frame) + 20, CGRectGetWidth(self.view.frame), 40)];
    [self.passwordTextView setPlaceholder:@"请输入密码" imageNamed:@"gy_password"];
    self.passwordTextView.delegate = self;
    self.passwordTextView.textField.secureTextEntry = YES;
    [self.view addSubview:self.passwordTextView];
    
    
    UIImage * confirmImage = [GYImage imagesFromCustomBundle:@"gy_button"];
    CGRect confirmRect = CGRectZero;
    confirmRect.size.width = confirmImage.size.width;
    confirmRect.size.height = confirmImage.size.height;
    confirmRect.origin.x = (CGRectGetWidth(self.view.frame) - CGRectGetWidth(confirmRect)) * 0.5;
    confirmRect.origin.y = CGRectGetMaxY(self.passwordTextView.frame) + 40;
    self.registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.registerBtn.frame = confirmRect;
    [self.registerBtn addTarget:self action:@selector(registerBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.registerBtn setBackgroundImage:confirmImage forState:UIControlStateNormal];
    [self.registerBtn setTitle:@"立即注册" forState:UIControlStateNormal];
    [self.registerBtn setTitleEdgeInsets:UIEdgeInsetsMake(-8, 0, 0, 0)];
    [self.registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.registerBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.registerBtn];


}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.userModel = [[GYUserModel alloc]init];

}

- (BOOL)checkRegister
{
    
    if ([GYRegular validateMobile:self.phoneTextView.textField.text]&&
        [GYRegular validateVerifyCode:self.verifyCodeView.textField.text]&&
        [GYRegular validatePassword:self.passwordTextView.textField.text])
    {
        self.userModel.phone = self.phoneTextView.textField.text;
        self.userModel.clientcode = self.verifyCodeView.textField.text;
        self.userModel.password = self.passwordTextView.textField.text;

        return YES;
    }
    
    if (![GYRegular validateMobile:self.phoneTextView.textField.text])
    {
        [[[GYTipView alloc]initWithMsg:@"手机号不正确"] showAnimation];
    }
    else if(![GYRegular validateVerifyCode:self.verifyCodeView.textField.text])
    {
        [[[GYTipView alloc]initWithMsg:@"验证码错误"] showAnimation];
    }
    else if(![GYRegular validatePassword:self.passwordTextView.textField.text])
    {
        [[[GYTipView alloc]initWithMsg:@"密码至少为8位以上数字字母"] showAnimation];
    }
    return NO;
}

#pragma mark - ButtonOnClick
- (void)registerBtnOnClick
{
    if ([self checkRegister])
    {
        [self requestRegister:self.userModel];
    }

}

#pragma mark -  Register Request

- (void)requestRegister:(GYUserModel *)userModel
{
    self.registerBtn.userInteractionEnabled = NO;
    [self startLoading];
    
    NSDictionary * parma = @{@"username":userModel.phone ?  : @"",
                             @"password":userModel.password ? : @"",
                             @"valicode":userModel.clientcode ? : @"",
                             @"type":@"1"
                             };
    __weak typeof(self) wself = self;
    [[GYNetwork network]requestwithParam:parma
                                    path:@"user/register"
                                        method:@"POST"
                                      response:^(NSDictionary *resObj)
     {
         NSLog(@"注册：%@",resObj);
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString * status = [resObj stringForKey:@"status"];
             if ([status isEqualToString:@"0200"])
             {
                 GYTipView * tipView =  [[GYTipView alloc]initWithMsg:@"注册成功"];
                 [tipView showAnimation:^(BOOL finished)
                 {
                     [wself.navigationController popViewControllerAnimated:YES];
                 }];
             }
             else
             {
                 if ([status isEqualToString:@"0202"])
                 {
                     [[[GYTipView alloc]initWithMsg:@"该用户已经注册"] showAnimation];
                 }
                 else
                 {
                   [[[GYTipView alloc]initWithMsg:@"注册失败"] showAnimation];
                 }
                 wself.registerBtn.userInteractionEnabled = YES;
             }
             [wself stopLoading];

         });
    }];
}

#pragma mark - Delegate

- (void)textFieldDidEndEditing:(UITextField *)textField
                 textFieldView:(GYTextfieldView *)view
{


    
}

- (BOOL)textFieldShouldReturn:(UITextField *)aTextfield
                textFieldView:(GYTextfieldView *)view
{
    return YES;
    
}

- (void)sendVerificationCode :(GYTextfieldView *)view
{
    if (![GYRegular validateMobile:self.phoneTextView.textField.text])
    {
        [[[GYTipView alloc]initWithMsg:@"手机号不正确"] showAnimation];
        return;
    }
    
    [self.verifyCodeView countTime];
    NSString * path = [NSString stringWithFormat:@"getDomesticCode/send?phone=%@",self.phoneTextView.textField.text];

    [[GYNetwork network]requestwithParam:@{}
                                    path:path
                                  method:@"GET"
                                response:^(NSDictionary *resObj)
     {
         NSLog(@"%@",resObj);
     }];
    
}


@end
