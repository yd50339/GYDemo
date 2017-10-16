//
//  GYTextView.m
//  GYSDK
//
//  Created by yd on 2017/8/2.
//  Copyright © 2017年 yd. All rights reserved.
//

#import "GYTextfieldView.h"
#import "GYImage.h"
@interface GYTextfieldView()<UITextFieldDelegate>
@property(nonatomic , strong)UIImageView * titleImageView;
@property(nonatomic , strong)UIButton * cleanBtn;
@property(nonatomic , copy)NSString * placeholder;
@property(nonatomic , copy)NSString * titleImageStr;
@end

@implementation GYTextfieldView

- (id)initWithFrame:(CGRect)frame
{
    if (self)
    {
        self = [super initWithFrame:frame];
    }
    return self;
}



- (void)setPlaceholder:(NSString *)placeholder imageNamed:(NSString *)imgString
{
    _placeholder = placeholder;
    _titleImageStr = imgString;
    [self customTextView:placeholder imageNamed:imgString];
}


- (void)setIsMessage:(BOOL)isMessage
{
    _isMessage = isMessage;
    [self getMessageCode];

}

- (void)getMessageCode
{
    
    CGRect rect = self.textField.frame;
    rect.size.width =  120;
    self.textField.frame = rect;

    CGRect cleanRect = self.cleanBtn.frame;
    cleanRect.origin.x = CGRectGetMaxX(rect);
    self.cleanBtn.frame = cleanRect;
    
    UIColor * color = [UIColor colorWithRed:47/255.0 green:82/255.0 blue:212/255.0 alpha:1];
    CGRect messageRect = CGRectZero;
    messageRect.size.width = 100;
    messageRect.size.height = 40;
    messageRect.origin.x = CGRectGetMaxX(cleanRect) + 30;
    messageRect.origin.y = CGRectGetMidY(rect) - CGRectGetHeight(messageRect) * 0.5 - 5;
    UIButton * messageBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [messageBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
//    [messageBtn setTitleColor:color forState:UIControlStateNormal];
    [messageBtn addTarget:self action:@selector(messageBtnOnClick) forControlEvents:UIControlEventTouchDown];
    messageBtn.layer.borderWidth = 1;
    messageBtn.layer.cornerRadius = CGRectGetHeight(rect) * 0.7;
    messageBtn.frame = messageRect;
    messageBtn.layer.borderColor = color.CGColor;
    [self addSubview:messageBtn];

    
    self.coutTimeLabel = [[UILabel alloc]initWithFrame:messageRect];
    self.coutTimeLabel.text = @"发送验证码";
    self.coutTimeLabel.textColor = color;
    self.coutTimeLabel.font = [UIFont systemFontOfSize:15];
    self.coutTimeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.coutTimeLabel];
}

- (void)messageBtnOnClick
{
    if ([self.delegate respondsToSelector:@selector(sendVerificationCode:)])
    {
        [self.delegate sendVerificationCode:self];
    }
}

- (void)customTextView:(NSString *)placeholder imageNamed:(NSString *)imgString
{
    UIImage * userImage = [GYImage imagesFromCustomBundle:imgString];
    CGRect userImgRect = CGRectZero;
    userImgRect.size.width = userImage.size.width;
    userImgRect.size.height = userImage.size.height;
    userImgRect.origin.x = 48;
    userImgRect.origin.y = 0;
    self.titleImageView = [[UIImageView alloc]initWithFrame:userImgRect];
    self.titleImageView.image = userImage;
    [self addSubview:self.titleImageView];
    
    
    CGRect userTfRect = CGRectZero;
    userTfRect.size.width = CGRectGetWidth(self.frame) - 82 - CGRectGetWidth(userImgRect) - 8;
    userTfRect.size.height = 30;
    userTfRect.origin.x = CGRectGetMaxX(userImgRect) + 8;
    userTfRect.origin.y = CGRectGetMidY(userImgRect) - CGRectGetHeight(userTfRect) * 0.5 + 1;
    self.textField = [[UITextField alloc]init];
    self.textField.frame = userTfRect;
    self.textField.borderStyle = UITextBorderStyleNone;
    self.textField.font = [UIFont fontWithName:@"Arial" size:18.0f];
    self.textField.textColor = [UIColor grayColor];
    self.textField.textAlignment = NSTextAlignmentLeft;
    self.textField.returnKeyType = UIReturnKeyDone;
    self.textField.delegate = self;
    self.textField.placeholder = placeholder;
    [self addSubview:self.textField];
    
    
    UIImage * userCleanBtnImage = [GYImage imagesFromCustomBundle:@"gy_clean"];
    CGRect userCleanBtnRect = CGRectZero;
    userCleanBtnRect.size.width = userCleanBtnImage.size.width;
    userCleanBtnRect.size.height = userCleanBtnImage.size.height;
    userCleanBtnRect.origin.x = CGRectGetWidth(self.frame) - CGRectGetWidth(userCleanBtnRect) - 50;
    userCleanBtnRect.origin.y = CGRectGetMidY(self.textField.frame) - CGRectGetHeight(userCleanBtnRect) * 0.5;
    self.cleanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cleanBtn.hidden = YES;
    self.cleanBtn.frame = userCleanBtnRect;
    [self.cleanBtn setBackgroundImage:userCleanBtnImage forState:UIControlStateNormal];
    [self.cleanBtn addTarget:self action:@selector(cleanBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.cleanBtn];
    
    
    CGRect userLineRect = userTfRect;
    userLineRect.origin.y = CGRectGetMaxY(userTfRect) + 7;
    userLineRect.size.height = 1;
    userLineRect.size.width = CGRectGetWidth(self.frame) - 50;
    userLineRect.origin.x = 25;
    UIView * userLine = [[UIView alloc] init];
    userLine.frame = userLineRect;
    userLine.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:userLine];
    

}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if (textField == self.textField)
    {
        NSString * edited = [NSString stringWithFormat:@"%@_edited",self.titleImageStr];
        self.titleImageView.image = [GYImage imagesFromCustomBundle:edited];
        self.cleanBtn.hidden = NO;
        self.textField.placeholder = @"";
        
        if ([self.delegate respondsToSelector:@selector(textFieldDidBeginEditing:textFieldView:)])
        {
            [self.delegate textFieldDidBeginEditing:textField textFieldView:self];
        }
        
    }
    
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length == 0 && textField == self.textField)
    {
        self.textField.placeholder = self.placeholder;
        self.titleImageView.image = [GYImage imagesFromCustomBundle:self.titleImageStr];
       
    }
    
    if(textField.text.length > 0)
    {
        if ([self.delegate respondsToSelector:@selector(textFieldDidEndEditing:textFieldView:)])
        {
            [self.delegate textFieldDidEndEditing:textField textFieldView:self];
        }

    }
    self.cleanBtn.hidden = YES;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)aTextfield
{
    [self.textField resignFirstResponder];
    if ([self.delegate respondsToSelector:@selector(textFieldShouldReturn:textFieldView:)])
    {
        [self.delegate textFieldShouldReturn:aTextfield textFieldView:self];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.textField && self.isMessage)
    {
        if (string.length == 0) return YES;
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 6)
        {
            return NO;
        }
    }
    
    return YES;
}

- (void)cleanBtnOnClick
{
    self.textField.text = @"";
}

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
//{
//    
//    if (!self.isUserInteractionEnabled || self.isHidden || self.alpha <= 0.01)
//    {
//        return nil;
//    }
// 
//    for (UIView *subview in [self.subviews reverseObjectEnumerator])
//    {
//        CGPoint convertedPoint = [subview convertPoint:point fromView:self];
//        UIView *hitTestView = [subview hitTest:convertedPoint withEvent:event];
//        if (hitTestView)
//        {
//            return hitTestView;
//        }
//    }
//    return self;
//}



@end
