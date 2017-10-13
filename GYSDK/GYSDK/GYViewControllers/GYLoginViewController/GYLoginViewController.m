//
//  GYLoginViewController.m
//  GYSDK
//
//  Created by yd on 2017/7/31.
//  Copyright © 2017年 yd. All rights reserved.
//

#import "GYLoginViewController.h"
#import "GYRegisterViewController.h"
#import "GYForgetViewController.h"
#import "GYSDK.h"



@interface GYLoginViewController ()
<UITextFieldDelegate,
GYTextfieldViewDelegate>

@property(nonatomic , strong)GYTextfieldView * userTextView;
@property(nonatomic , strong)GYTextfieldView * passwordTextView;
@property(nonatomic , strong)GYUserModel * userModel;

@end

@implementation GYLoginViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}


- (void)loadView
{
    self.view = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor whiteColor];
   
    UIImageView * bgImageView = [[UIImageView alloc]init];
    bgImageView.image = [GYImage imagesFromCustomBundle:@"gy_navBar"];
    bgImageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 220);
    [self.view addSubview:bgImageView];
    
    
    UIImageView * logoBgView = [[UIImageView alloc]init];
    logoBgView.image = [GYImage imagesFromCustomBundle:@"gy_logoBg"];
    CGRect logoBgRect = bgImageView.frame;
    logoBgRect.size.width = logoBgView.image.size.width;
    logoBgRect.size.height = logoBgView.image.size.height;
    logoBgRect.origin.x = (CGRectGetWidth(self.view.frame) - CGRectGetWidth(logoBgRect)) * 0.5;
    logoBgRect.origin.y = 152.5;
    logoBgView.frame = logoBgRect;
    [self.view addSubview:logoBgView];
    
    
    UIImageView * logoImageView = [[UIImageView alloc]init];
    logoImageView.image = [GYImage imagesFromCustomBundle:@"gy_logo"];
    CGRect logoRect = CGRectZero;
    logoRect.size.width = logoImageView.image.size.width;
    logoRect.size.height = logoImageView.image.size.height;
    logoRect.origin.x = (CGRectGetWidth(logoBgView.frame) - CGRectGetWidth(logoRect)) * 0.5;
    logoRect.origin.y = (CGRectGetHeight(logoBgView.frame) - CGRectGetHeight(logoRect)) * 0.5;
    logoImageView.frame = logoRect;
    [logoBgView addSubview:logoImageView];
    
    
    self.userTextView = [[GYTextfieldView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(logoBgView.frame) + 44, CGRectGetWidth(self.view.frame), 40)];
    [self.userTextView  setPlaceholder:@"请输入手机号/邮箱" imageNamed:@"gy_user"];
    self.userTextView .delegate = self;
    [self.view addSubview:self.userTextView ];
    
    self.passwordTextView = [[GYTextfieldView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.userTextView.frame) + 20, CGRectGetWidth(self.view.frame), 40)];
    [self.passwordTextView setPlaceholder:@"请输入密码" imageNamed:@"gy_password"];
    self.passwordTextView.textField.secureTextEntry = YES;
    self.passwordTextView.delegate = self;
    [self.view addSubview:self.passwordTextView];
    
    
    UIImage * loginImage = [GYImage imagesFromCustomBundle:@"gy_button"];
    CGRect loginRect = CGRectZero;
    loginRect.size.width = loginImage.size.width;
    loginRect.size.height = loginImage.size.height;
    loginRect.origin.x = (CGRectGetWidth(self.view.frame) - CGRectGetWidth(loginRect)) * 0.5;
    loginRect.origin.y = CGRectGetMaxY(self.passwordTextView.frame) + 40;
    UIButton * loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = loginRect;
    [loginBtn addTarget:self action:@selector(confirmBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn setBackgroundImage:loginImage forState:UIControlStateNormal];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleEdgeInsets:UIEdgeInsetsMake(-8, 0, 0, 0)];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:loginBtn];
    
    UIButton * registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect rect = loginBtn.frame;
    rect.origin.y = CGRectGetMaxY(rect);
    rect.origin.x = 44;
    rect.size.width = 44;
    rect.size.height = 44;
    registerBtn.frame = rect;
    [registerBtn addTarget:self action:@selector(registerBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    [registerBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    registerBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:registerBtn];
    
    
    UIButton * forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect forgetRect = loginBtn.frame;
    forgetRect.origin.y = CGRectGetMaxY(forgetRect);
    forgetRect.size.width = 80;
    forgetRect.origin.x = CGRectGetWidth(self.view.frame) - 46 - 80;
    forgetRect.size.height = 44;
    forgetBtn.frame = forgetRect;
    [forgetBtn addTarget:self action:@selector(forgetBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    [forgetBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [forgetBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    forgetBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:forgetBtn];

    UIImage * backImage = [GYImage imagesFromCustomBundle:@"gy_back"];
    CGRect  backRect = CGRectZero;
    backRect.size.width = backImage.size.width;
    backRect.size.height = backImage.size.height;
    backRect.origin.x = 20;
    backRect.origin.y = 40;
    UIImageView * backImageView = [[UIImageView alloc]initWithFrame:backRect];
    backImageView.image = backImage;
    [self.view addSubview:backImageView];
    
    CGRect backBtnRect = backRect;
    backBtnRect.size.width = 30;
    backBtnRect.size.height = 40;
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = backBtnRect;
    [backButton addTarget:self action:@selector(backButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];


}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.userModel = [[GYUserModel alloc]init];
}

#pragma mark - Login Request

- (void)requestLogin:(GYUserModel *)userModel
{
    [self startLoading];

    NSDictionary * dict = @{@"username":userModel.userName? : @"",
                            @"password":userModel.password ? : @"",
                            @"games":@[@{@"gamename":@"1",
                                         @"gamepackage":@"111",
                                         @"remark":@"zheshi"
                                         }],
                            @"type":@"1"};
    
    __weak typeof(self) wself = self;
    [[GYNetwork network]requestwithParam:dict
                                    path:@"user/login"
                                  method:@"POST"
                                response:^(NSDictionary * resObj)
     {
         if (resObj)
         {
             NSLog(@"登录：%@",resObj);
             dispatch_async(dispatch_get_main_queue(), ^{
                 NSString * status = [resObj stringForKey:@"status"];
                 if ([status isEqualToString:@"0200"])
                 {
                     NSMutableDictionary * loginDict = [NSMutableDictionary dictionary];
                      NSString * token = [resObj stringForKey:@"token"];
                     [loginDict setObject:token forKey:@"token"];
                     NSString * userId = [resObj stringForKey:@"userid"];
                     [loginDict setObject:userId forKey:@"userId"];
//                     [GYKeyChain addKeychainData:token forKey:kGYKeyChainKey];
                     [[NSUserDefaults standardUserDefaults] setObject:loginDict forKey:kGYKeyChainKey];
                     [[NSUserDefaults standardUserDefaults] synchronize];
                     
                     [wself dismissViewControllerAnimated:YES completion:nil];
                 }
                 else
                 {
                     [[[GYTipView alloc]initWithMsg:@"用户名或密码错误"] showAnimation];
                 }
                 [wself stopLoading];
             });
             if (wself.result)
             {
                wself.result(resObj);
             }
         }
         
         
     }];
    

    
}

- (BOOL)checkLogin
{
    
    if (([GYRegular validateEmail:self.userTextView.textField.text] ||
        [GYRegular validateMobile:self.userTextView.textField.text]) &&
        [GYRegular validatePassword:self.passwordTextView.textField.text])
    {
//        NSString * key = [GYRegular validateEmail:self.userTextView.textField.text] ? @"email" : @"cellphone";
//        if ([key isEqualToString:@"email"])
//        {
//            self.userModel.userName = self.userTextView.textField.text;
//
//        }
//        if ([key isEqualToString:@"cellphone"])
//        {
//            self.userModel.phone = self.userTextView.textField.text;
//        }
        self.userModel.userName = self.userTextView.textField.text;
        NSString * password = self.passwordTextView.textField.text;
        self.userModel.password = password;
        return YES;
    }
    else
    {
        [[[GYTipView alloc]initWithMsg:@"用户名或密码错误"] showAnimation];
        return NO;
    }
 
}


#pragma  mark -  ButtonOnClick
- (void)confirmBtnOnClick
{
    if ([self checkLogin])
    {
        [self requestLogin:self.userModel];

    }
    
}

- (void)backButtonOnClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (void)registerBtnOnClick
{
    GYRegisterViewController * registerVc = [[GYRegisterViewController alloc]init];
    [self.navigationController pushViewController:registerVc animated:YES];
}

- (void)forgetBtnOnClick
{
    GYForgetViewController * forgetVc = [[GYForgetViewController alloc]init];
    [self.navigationController pushViewController:forgetVc animated:YES];

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



@end
