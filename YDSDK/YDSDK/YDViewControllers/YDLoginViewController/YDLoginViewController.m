//
//  YDLoginViewController.m
//  YDSDK
//
//  Created by yd on 2017/7/31.
//  Copyright © 2017年 yd. All rights reserved.
//

#import "YDLoginViewController.h"
#import "YDRegisterViewController.h"
#import "YDForgetViewController.h"
#import "YDSDK.h"



@interface YDLoginViewController ()
<UITextFieldDelegate,
YDTextfieldViewDelegate>

@property(nonatomic , strong)YDTextfieldView * userTextView;
@property(nonatomic , strong)YDTextfieldView * passwordTextView;
@property(nonatomic , strong)YDUserModel * userModel;
@property(nonatomic , strong)UIButton * loginBtn;
@property(nonatomic , assign)BOOL isRequesting;


@end

@implementation YDLoginViewController

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
    bgImageView.image = [YDImage imagesFromCustomBundle:@"yd_navBar"];
    bgImageView.frame = CGRectMake(0, CGRectGetWidth(self.view.frame) - bgImageView.image.size.width,CGRectGetWidth(self.view.frame) , bgImageView.image.size.height);
    [self.view addSubview:bgImageView];
    
    
    UIImageView * logoBgView = [[UIImageView alloc]init];
    logoBgView.image = [YDImage imagesFromCustomBundle:@"yd_logoBg"];
    CGRect logoBgRect = bgImageView.frame;
    logoBgRect.size.width = logoBgView.image.size.width;
    logoBgRect.size.height = logoBgView.image.size.height;
    logoBgRect.origin.x = (CGRectGetWidth(self.view.frame) - CGRectGetWidth(logoBgRect)) * 0.5;
    logoBgRect.origin.y = CGRectGetMaxY(bgImageView.frame) - CGRectGetHeight(logoBgRect) * 0.5 - 10;
    logoBgView.frame = logoBgRect;
    [self.view addSubview:logoBgView];
    
    
    UIImageView * logoImageView = [[UIImageView alloc]init];
    logoImageView.image = [YDImage imagesFromCustomBundle:@"yd_logo"];
    CGRect logoRect = CGRectZero;
    logoRect.size.width = logoImageView.image.size.width;
    logoRect.size.height = logoImageView.image.size.height;
    logoRect.origin.x = (CGRectGetWidth(logoBgView.frame) - CGRectGetWidth(logoRect)) * 0.5;
    logoRect.origin.y = (CGRectGetHeight(logoBgView.frame) - CGRectGetHeight(logoRect)) * 0.5;
    logoImageView.frame = logoRect;
    [logoBgView addSubview:logoImageView];
    
    
    self.userTextView = [[YDTextfieldView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(logoBgView.frame) + 44, CGRectGetWidth(self.view.frame), 40)];
    [self.userTextView  setPlaceholder:@"请输入手机号码" imageNamed:@"yd_user"];
    self.userTextView .delegate = self;
    [self.view addSubview:self.userTextView ];
    
    self.passwordTextView = [[YDTextfieldView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.userTextView.frame) + 20, CGRectGetWidth(self.view.frame), 40)];
    [self.passwordTextView setPlaceholder:@"请输入密码" imageNamed:@"yd_password"];
    self.passwordTextView.textField.secureTextEntry = YES;
    self.passwordTextView.delegate = self;
    [self.view addSubview:self.passwordTextView];
    
    
    UIImage * loginImage = [YDImage imagesFromCustomBundle:@"yd_button"];
    CGRect loginRect = CGRectZero;
    loginRect.size.width = loginImage.size.width;
    loginRect.size.height = loginImage.size.height;
    loginRect.origin.x = (CGRectGetWidth(self.view.frame) - CGRectGetWidth(loginRect)) * 0.5;
    loginRect.origin.y = CGRectGetMaxY(self.passwordTextView.frame) + 40;
    self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.loginBtn.frame = loginRect;
    [self.loginBtn addTarget:self action:@selector(confirmBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.loginBtn setBackgroundImage:loginImage forState:UIControlStateNormal];
    [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginBtn setTitleEdgeInsets:UIEdgeInsetsMake(-8, 0, 0, 0)];
    [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.loginBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.loginBtn];
    
    UIButton * registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect rect = self.loginBtn.frame;
    rect.origin.y = CGRectGetMaxY(rect);
    rect.origin.x = 44;
    rect.size.width = 44;
    rect.size.height = 44;
    registerBtn.frame = rect;
    [registerBtn addTarget:self action:@selector(registerBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    NSDictionary * registerAtt = @{NSFontAttributeName:[UIFont systemFontOfSize:15],
                                   NSForegroundColorAttributeName:[UIColor grayColor]};
    NSMutableAttributedString * registerTitle = [[NSMutableAttributedString alloc]initWithString:@"注册"
                                                                                      attributes:registerAtt];
    [registerBtn setAttributedTitle:registerTitle forState:UIControlStateNormal];
    registerBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:registerBtn];
    
    
    UIButton * forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect forgetRect = self.loginBtn.frame;
    forgetRect.origin.y = CGRectGetMaxY(forgetRect);
    forgetRect.size.width = 80;
    forgetRect.origin.x = CGRectGetWidth(self.view.frame) - 46 - 80;
    forgetRect.size.height = 44;
    forgetBtn.frame = forgetRect;
    [forgetBtn addTarget:self action:@selector(forgetBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    NSDictionary * forgetAtt = @{NSFontAttributeName:[UIFont systemFontOfSize:15],
                                 NSForegroundColorAttributeName:[UIColor grayColor]};
    NSMutableAttributedString * forgetTitle = [[NSMutableAttributedString alloc]initWithString:@"忘记密码"
                                                                                    attributes:forgetAtt];
    [forgetBtn setAttributedTitle:forgetTitle forState:UIControlStateNormal];
    forgetBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:forgetBtn];

    UIImage * backImage = [YDImage imagesFromCustomBundle:@"yd_back"];
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
    self.userModel = [[YDUserModel alloc]init];
    
    //注册键盘弹出通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    //注册键盘隐藏通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)keyboardWillShow:(NSNotification *)note
{
//    NSDictionary *info = [note userInfo];
//    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    //目标视图UITextField
    int y =  210;
    if(y > 0)
    {
        self.view.frame = CGRectMake(0, -y, self.view.frame.size.width, self.view.frame.size.height);
    }
}

//键盘隐藏后将视图恢复到原始状态
-(void)keyboardWillHide:(NSNotification *)note
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

#pragma mark - Login Request

- (void)requestLogin:(YDUserModel *)userModel
{
    if (self.isRequesting)
    {
        return;
    }
    self.isRequesting = YES;
    [self startLoading];

    NSString * bundleId =   [[NSBundle mainBundle]bundleIdentifier];
    NSDictionary * dict = @{@"username":userModel.userName? : @"",
                            @"password":userModel.password ? : @"",
                            @"games":@[@{@"gamename":@"",
                                         @"gamepackage":bundleId ? :@"",
                                         @"remark":@""
                                         }],
                            @"type":@"1"};
    
    __weak typeof(self) wself = self;
    [[YDNetwork network]requestwithParam:dict
                                    path:@"user/login"
                                  method:@"POST"
                                response:^(NSDictionary * resObj)
     {
         NSLog(@"登录：%@",resObj);
         wself.isRequesting = NO;
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString * status = [resObj stringForKey:@"status"];
             if ([status isEqualToString:@"0200"])
             {
                 NSMutableDictionary * loginDict = [NSMutableDictionary dictionary];
                 NSString * token = [resObj stringForKey:@"token"];
                 [loginDict setObject:token forKey:@"token"];
                 NSString * userId = [resObj stringForKey:@"userid"];
                 [loginDict setObject:userId forKey:@"userId"];
                 NSString * gameId = [resObj stringForKey:@"gameid"];
                 [loginDict setObject:gameId forKey:@"gameId"];
                 //[YDKeyChain addKeychainData:token forKey:kYDKeyChainKey];
                 [[NSUserDefaults standardUserDefaults] setObject:loginDict forKey:bundleId];
                 [[NSUserDefaults standardUserDefaults] synchronize];
                 
                 [wself dismissViewControllerAnimated:YES completion:nil];
             }
             else
             {
                 [[[YDTipView alloc]initWithMsg:@"用户名或密码错误"] showAnimation];
             }
             [wself stopLoading];
         });
         if (wself.result)
         {
             wself.result(resObj);
         }
         
     }];
    

    
}

- (BOOL)checkLogin
{
    
    if (([YDRegular validateEmail:self.userTextView.textField.text] ||
        [YDRegular validateMobile:self.userTextView.textField.text]) &&
        [YDRegular validatePassword:self.passwordTextView.textField.text])
    {
        self.userModel.userName = self.userTextView.textField.text;
        NSString * password = self.passwordTextView.textField.text;
        self.userModel.password = password;
        return YES;
    }
    else
    {
        [[[YDTipView alloc]initWithMsg:@"用户名或密码错误"] showAnimation];
        return NO;
    }
 
}


#pragma  mark -  ButtonOnClick
- (void)confirmBtnOnClick
{
    if ([self checkLogin])
    {
        [self.view endEditing:YES];
        [self requestLogin:self.userModel];
    }
    
}

- (void)backButtonOnClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (void)registerBtnOnClick
{
    YDRegisterViewController * registerVc = [[YDRegisterViewController alloc]init];
    [self.navigationController pushViewController:registerVc animated:YES];
}

- (void)forgetBtnOnClick
{
    YDForgetViewController * forgetVc = [[YDForgetViewController alloc]init];
    [self.navigationController pushViewController:forgetVc animated:YES];

}

#pragma mark - Delegate

- (void)textFieldDidEndEditing:(UITextField *)textField
                 textFieldView:(YDTextfieldView *)view
{
   
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)aTextfield
                textFieldView:(YDTextfieldView *)view
{
    return YES;
    
}

@end
