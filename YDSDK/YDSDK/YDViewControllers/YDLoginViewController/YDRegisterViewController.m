//
//  YDRegisterViewController.m
//  YDSDK
//
//  Created by yd on 2017/8/1.
//  Copyright © 2017年 yd. All rights reserved.
//

#import "YDRegisterViewController.h"
#import "YDTextfieldView.h"
#import "YDImage.h"
@interface YDRegisterViewController ()
<YDTextfieldViewDelegate>
@property(nonatomic , strong)YDTextfieldView * phoneTextView;
@property(nonatomic , strong)YDTextfieldView * verifyCodeView;
@property(nonatomic , strong)YDTextfieldView * passwordTextView;
@property(nonatomic , strong)YDUserModel * userModel;
@property(nonatomic , strong)UIButton * registerBtn;
@property(nonatomic , assign)BOOL isRequesting;
@end

@implementation YDRegisterViewController


- (void)loadView
{
    self.view = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"注册";
    
    self.phoneTextView = [[YDTextfieldView alloc]initWithFrame:CGRectMake(0, 120, CGRectGetWidth(self.view.frame), 40)];
    [self.phoneTextView setPlaceholder:@"请输入手机号码" imageNamed:@"yd_phone"];
    self.phoneTextView.delegate = self;
    [self.view addSubview:self.phoneTextView];
    
    self.verifyCodeView = [[YDTextfieldView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.phoneTextView.frame) + 20, CGRectGetWidth(self.view.frame), 40)];
    [self.verifyCodeView setPlaceholder:@"请输入验证码" imageNamed:@"yd_password"];
    self.verifyCodeView.isMessage = YES;
    self.verifyCodeView.delegate = self;
    [self.view addSubview:self.verifyCodeView];
    
    self.passwordTextView = [[YDTextfieldView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.verifyCodeView.frame) + 20, CGRectGetWidth(self.view.frame), 40)];
    [self.passwordTextView setPlaceholder:@"请输入密码" imageNamed:@"yd_password"];
    self.passwordTextView.delegate = self;
    self.passwordTextView.textField.secureTextEntry = YES;
    [self.view addSubview:self.passwordTextView];
    
    
    UIImage * confirmImage = [YDImage imagesFromCustomBundle:@"yd_button"];
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
    
    self.userModel = [[YDUserModel alloc]init];

}

- (BOOL)checkRegister
{
    
    if ([YDRegular validateMobile:self.phoneTextView.textField.text]&&
        [YDRegular validateVerifyCode:self.verifyCodeView.textField.text]&&
        [YDRegular validatePassword:self.passwordTextView.textField.text])
    {
        self.userModel.phone = self.phoneTextView.textField.text;
        self.userModel.clientcode = self.verifyCodeView.textField.text;
        self.userModel.password = self.passwordTextView.textField.text;

        return YES;
    }
    
    if (![YDRegular validateMobile:self.phoneTextView.textField.text])
    {
        [[[YDTipView alloc]initWithMsg:@"手机号不正确"] showAnimation];
    }
    else if(![YDRegular validateVerifyCode:self.verifyCodeView.textField.text])
    {
        [[[YDTipView alloc]initWithMsg:@"验证码错误"] showAnimation];
    }
    else if(![YDRegular validatePassword:self.passwordTextView.textField.text])
    {
        [[[YDTipView alloc]initWithMsg:@"密码至少为8位以上数字字母"] showAnimation];
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

- (void)requestRegister:(YDUserModel *)userModel
{
    if (self.isRequesting)
    {
        return;
    }
    self.isRequesting = YES;
    [self startLoading];
    NSDictionary * parma = @{@"username":userModel.phone ?  : @"",
                             @"password":userModel.password ? : @"",
                             @"valicode":userModel.clientcode ? : @"",
                             @"type":@"1"
                             };
    __weak typeof(self) wself = self;
    [[YDNetwork network]requestwithParam:parma
                                    path:@"user/register"
                                        method:@"POST"
                                      response:^(NSDictionary *resObj)
     {
         NSLog(@"注册：%@",resObj);
         wself.isRequesting = NO;
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString * status = [resObj stringForKey:@"status"];
             if ([status isEqualToString:@"0200"])
             {
                 YDTipView * tipView =  [[YDTipView alloc]initWithMsg:@"注册成功"];
                 [tipView showAnimation:^(BOOL finished)
                 {
                     [wself stopLoading];
                     [wself.navigationController popViewControllerAnimated:YES];
                 }];
             }
             else
             {
                 if ([status isEqualToString:@"0202"])
                 {
                     [[[YDTipView alloc]initWithMsg:@"该用户已经注册"] showAnimation];
                 }
                 else
                 {
                   [[[YDTipView alloc]initWithMsg:@"注册失败"] showAnimation];
                 }
                 [wself stopLoading];

             }

         });
    }];
}

#pragma mark - Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)aTextfield
                textFieldView:(YDTextfieldView *)view
{
    return YES;
    
}

- (void)sendVerificationCode :(YDTextfieldView *)view
{
    if (![YDRegular validateMobile:self.phoneTextView.textField.text])
    {
        [[[YDTipView alloc]initWithMsg:@"手机号不正确"] showAnimation];
        return;
    }
    
    [self.verifyCodeView countTime];
    NSString * path = [NSString stringWithFormat:@"getDomesticCode/send?phone=%@",self.phoneTextView.textField.text];

    [[YDNetwork network]requestwithParam:@{}
                                    path:path
                                  method:@"GET"
                                response:^(NSDictionary *resObj)
     {
         NSLog(@"%@",resObj);
     }];
    
}


@end
