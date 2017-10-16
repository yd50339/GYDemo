//
//  GYTextView.h
//  GYSDK
//
//  Created by yd on 2017/8/2.
//  Copyright © 2017年 yd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GYTextfieldView;

@protocol GYTextfieldViewDelegate <NSObject>

@optional

- (void)textFieldDidBeginEditing:(UITextField *)textField
                   textFieldView:(GYTextfieldView *)view;
- (void)textFieldDidEndEditing:(UITextField *)textField
                 textFieldView:(GYTextfieldView *)view;
- (BOOL)textFieldShouldReturn:(UITextField *)aTextfield
                textFieldView:(GYTextfieldView *)view;

- (void)sendVerificationCode :(GYTextfieldView *)view;

@end

@interface GYTextfieldView : UIView

@property(nonatomic , assign)BOOL isMessage;

- (void)setPlaceholder:(NSString *)placeholder imageNamed:(NSString *)imgString;

@property(nonatomic , assign)id<GYTextfieldViewDelegate>delegate;

@property(nonatomic , strong)UITextField * textField;

@property(nonatomic , strong)UILabel * coutTimeLabel;

@end
