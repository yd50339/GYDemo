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

@end

@implementation GYForgetViewController

- (void)loadView
{
    self.view = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"忘记密码";
    
    self.accountTextView = [[GYTextfieldView alloc]initWithFrame:CGRectMake(0, 120, CGRectGetWidth(self.view.frame), 40)];
    self.accountTextView.delegate = self;
    [self.accountTextView setPlaceholder:@"请输入邮箱或者手机号" imageNamed:@"gy_user"];
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
    UIButton * confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = confirmRect;
    [confirmBtn addTarget:self action:@selector(confirmBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    [confirmBtn setBackgroundImage:confirmImage forState:UIControlStateNormal];
    [confirmBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [confirmBtn setTitleEdgeInsets:UIEdgeInsetsMake(-8, 0, 0, 0)];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:confirmBtn];


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
    __weak typeof (self) wself = self;
    
    NSDictionary * param = @{@"mobile":userModel.phone ? :@"",
                             @"valicode":userModel.clientcode? :@""};
    [[GYNetwork network]requestwithParam:param
                                    path:@"user/forgetpassone"
                                    method:@"PUT"
                                  response:^(NSDictionary *resObj)
     {
         NSLog(@"忘记密码：%@",resObj);
         dispatch_async(dispatch_get_main_queue(), ^{
             
             NSString * status = [resObj stringForKey:@"status"];
             if ([status isEqualToString:@"0200"])
             {
                 GYTipView * tipView =  [[GYTipView alloc]initWithMsg:@"验证成功"];
                 [tipView showAnimation:^(BOOL finished) {
                     GYPasswordViewController * passwordVc = [[GYPasswordViewController alloc]init];
                     passwordVc.phoneNum = self.accountTextView.textField.text;
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

- (void)textFieldDidEndEditing:(UITextField *)textField
                 textFieldView:(GYTextfieldView *)view
{
//    if (view == self.accountTextView)
//    {
//        if (![GYRegular validateMobile:textField.text])
//        {
//            [[[GYTipView alloc]initWithMsg:@"手机格式不正确"] showAnimation];
//        }
//        
//    }
//
//    if (view == self.checkTextView)
//    {
//        if (![GYRegular validateVerifyCode:textField.text])
//        {
//            [[[GYTipView alloc]initWithMsg:@"验证码错误"] showAnimation];
//        }
//        
//    }

    
}

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
