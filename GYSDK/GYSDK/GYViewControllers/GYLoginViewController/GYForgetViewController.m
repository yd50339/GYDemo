//
//  GYForgetViewController.m
//  GYSDK
//
//  Created by yd on 2017/8/1.
//  Copyright © 2017年 yd. All rights reserved.
//

#import "GYForgetViewController.h"
#import "GYPasswordViewController.h"
@interface GYForgetViewController ()
<UITextFieldDelegate,
GYTextfieldViewDelegate>
@property(nonatomic ,strong)GYTextfieldView * accountTextView;
@property(nonatomic ,strong)GYTextfieldView * verifyCodeView;
@property(nonatomic , strong)NSMutableDictionary * paramDict;
@property(nonatomic , strong)GYUserModel * userModel;
@property(nonatomic , strong)UIButton * confirmBtn;
@property(nonatomic , assign)BOOL isRequesting;


@end

@implementation GYForgetViewController

- (void)loadView
{
    self.view = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"忘记密码";
    
    self.accountTextView = [[GYTextfieldView alloc]initWithFrame:CGRectMake(0, 120, CGRectGetWidth(self.view.frame), 40)];
    self.accountTextView.delegate = self;
    [self.accountTextView setPlaceholder:@"请输入手机号码" imageNamed:@"gy_user"];
    [self.view addSubview:self.accountTextView];
    
    
    self.verifyCodeView = [[GYTextfieldView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.accountTextView.frame) + 20, CGRectGetWidth(self.view.frame), 40)];
    self.verifyCodeView.delegate = self;
    [self.verifyCodeView setPlaceholder:@"请输入验证码" imageNamed:@"gy_password"];
    self.verifyCodeView.isMessage = YES;
    [self.view addSubview:self.verifyCodeView];

    
    UIImage * confirmImage = [GYImage imagesFromCustomBundle:@"gy_button"];
    CGRect confirmRect = CGRectZero;
    confirmRect.size.width = confirmImage.size.width;
    confirmRect.size.height = confirmImage.size.height;
    confirmRect.origin.x = (CGRectGetWidth(self.view.frame) - CGRectGetWidth(confirmRect)) * 0.5;
    confirmRect.origin.y = CGRectGetMaxY(self.verifyCodeView.frame) + 40;
    self.confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.confirmBtn.frame = confirmRect;
    [self.confirmBtn addTarget:self action:@selector(confirmBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.confirmBtn setBackgroundImage:confirmImage forState:UIControlStateNormal];
    [self.confirmBtn setTitle:@"下一步" forState:UIControlStateNormal];
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

- (BOOL)checkForget
{
    if (([GYRegular validateMobile:self.accountTextView.textField.text]
         ||[GYRegular validateEmail:self.accountTextView.textField.text]) &&
        [GYRegular validateVerifyCode:self.verifyCodeView.textField.text])
    {
        self.userModel.phone = self.accountTextView.textField.text;
        self.userModel.clientcode = self.verifyCodeView.textField.text;

        return YES;
    }

    if (![GYRegular validateMobile:self.accountTextView.textField.text])
    {
        [[[GYTipView alloc]initWithMsg:@"手机号不正确"] showAnimation];
    }
    else if (![GYRegular validateVerifyCode:self.verifyCodeView.textField.text])
    {
        [[[GYTipView alloc]initWithMsg:@"验证码错误"] showAnimation];
    }
    
    return NO;

}

#pragma mark - ButtonOnClick

- (void)confirmBtnOnClick
{
    if ([self checkForget])
    {
       [self forgetRequest:self.userModel];
    }
    
}

#pragma mark -  Register Request

- (void)forgetRequest:(GYUserModel *)userModel
{
    if (self.isRequesting)
    {
        return;
    }
    self.isRequesting = YES;
    [self startLoading];

    __weak typeof (self) wself = self;
    
    NSDictionary * param = @{@"username":userModel.phone ? :@"",
                             @"valicode":userModel.clientcode? :@""};
    [[GYNetwork network]requestwithParam:param
                                    path:@"user/forgetpassone"
                                    method:@"PUT"
                                  response:^(NSDictionary *resObj)
     {
         NSLog(@"忘记密码：%@",resObj);
         wself.isRequesting = NO;
         dispatch_async(dispatch_get_main_queue(), ^{
             
             NSString * status = [resObj stringForKey:@"status"];
             if ([status isEqualToString:@"0200"])
             {
                 GYTipView * tipView =  [[GYTipView alloc]initWithMsg:@"验证成功"];
                 [tipView showAnimation:^(BOOL finished) {
                     wself.confirmBtn.userInteractionEnabled = YES;
                     GYPasswordViewController * passwordVc = [[GYPasswordViewController alloc]init];
                     passwordVc.phoneNum = wself.accountTextView.textField.text;
                     [wself.navigationController pushViewController:passwordVc animated:YES];
                 }];

             }
             else
             {
                 [[[GYTipView alloc]initWithMsg:@"验证码不正确"] showAnimation];
             }
             [wself stopLoading];
         });
     }];
}

#pragma mark - Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)aTextfield
                textFieldView:(GYTextfieldView *)view
{
    return YES;
    
}

- (void)sendVerificationCode :(GYTextfieldView *)view
{
    if (![GYRegular validateMobile:self.accountTextView.textField.text])
    {
        [[[GYTipView alloc]initWithMsg:@"手机号不正确"] showAnimation];
        return;
    }
    
    [self.verifyCodeView countTime];
    NSString * path = [NSString stringWithFormat:@"getDomesticCode/send?phone=%@",self.accountTextView.textField.text];
    
    [[GYNetwork network]requestwithParam:@{}
                                    path:path
                                  method:@"GET"
                                response:^(NSDictionary *resObj)
    {
        NSLog(@"%@",resObj);
    }];

}



@end
