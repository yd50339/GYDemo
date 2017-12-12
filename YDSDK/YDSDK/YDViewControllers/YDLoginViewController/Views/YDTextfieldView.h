//
//  YDTextView.h
//  YDSDK
//
//  Created by yd on 2017/8/2.
//  Copyright © 2017年 yd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YDTextfieldView;

@protocol YDTextfieldViewDelegate <NSObject>

@optional

- (void)textFieldDidBeginEditing:(UITextField *)textField
                   textFieldView:(YDTextfieldView *)view;
- (void)textFieldDidEndEditing:(UITextField *)textField
                 textFieldView:(YDTextfieldView *)view;
- (BOOL)textFieldShouldReturn:(UITextField *)aTextfield
                textFieldView:(YDTextfieldView *)view;

- (void)sendVerificationCode :(YDTextfieldView *)view;

@end

@interface YDTextfieldView : UIView

@property(nonatomic , assign)BOOL isMessage;

@property(nonatomic , assign)id<YDTextfieldViewDelegate>delegate;

@property(nonatomic , strong)UITextField * textField;

@property(nonatomic , strong)UILabel * coutTimeLabel;

- (void)setPlaceholder:(NSString *)placeholder imageNamed:(NSString *)imgString;

- (void)countTime;


@end
