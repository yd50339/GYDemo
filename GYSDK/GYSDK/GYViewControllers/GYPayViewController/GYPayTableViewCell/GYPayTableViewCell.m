//
//  GYPayTableViewCell.m
//  GYSDK
//
//  Created by yd on 2017/8/4.
//  Copyright © 2017年 yd. All rights reserved.
//

#import "GYPayTableViewCell.h"
#import "GYImage.h"

@interface GYPayTableViewCell()

@property(nonatomic , strong)UIImageView * iconImageView;
@property(nonatomic , strong)UILabel * nameLabel;
@property(nonatomic , strong)UIImageView * circusImageView;
@property(nonatomic , strong)UIImageView * selectedImageView;

@end

@implementation GYPayTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)createCustomCell
{

    CGRect rect = self.frame;
    rect.size.width = [UIScreen mainScreen].bounds.size.width;
    self.frame = rect;
    

    CGRect iconRect = CGRectZero;
    iconRect.size.width = 22.5;
    iconRect.size.height = 22.5;
    iconRect.origin.x = 15;
    iconRect.origin.y = (CGRectGetHeight(self.frame) - CGRectGetHeight(iconRect)) * 0.5;
    self.iconImageView = [[UIImageView alloc]init];
    self.iconImageView.frame = iconRect;
    [self addSubview:self.iconImageView];
    
    
    CGRect nameRect = iconRect;
    nameRect.size.width = 100;
    nameRect.size.height = 40;
    nameRect.origin.x = CGRectGetMaxX(iconRect) + 15;
    nameRect.origin.y = (CGRectGetHeight(self.frame) - CGRectGetHeight(nameRect)) * 0.5;
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.frame = nameRect;
    [self addSubview:self.nameLabel];
    
    CGRect circusRect = iconRect;
    circusRect.size.width = 24;
    circusRect.size.height = 24;
    circusRect.origin.x = CGRectGetWidth(self.frame) - 15 - CGRectGetWidth(circusRect);
    circusRect.origin.y = (CGRectGetHeight(self.frame) - CGRectGetHeight(circusRect)) * 0.5;
    self.circusImageView = [[UIImageView alloc]init];
    self.circusImageView.frame = circusRect;
    self.circusImageView.image = [GYImage imagesFromCustomBundle:@"gy_circus"];
    [self addSubview:self.circusImageView];
    
    
    CGRect selectedRect = iconRect;
    selectedRect.origin.x = 0;
    selectedRect.origin.y = 0;
    selectedRect.size.width = 23;
    selectedRect.size.height = 23;
    self.selectedImageView = [[UIImageView alloc]init];
    self.selectedImageView.frame = selectedRect;
    [self.circusImageView addSubview:self.selectedImageView];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.frame), CGRectGetWidth(self.frame), 1)];
    lineView.backgroundColor = [UIColor colorWithRed:231/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    [self addSubview:lineView];


}


- (void)setcell:(NSDictionary *)dict
{
    [self createCustomCell];
    if (dict)
    {
        self.iconImageView.image = [GYImage imagesFromCustomBundle:dict[@"icon"]];
        self.nameLabel.text = dict[@"type"];
    }


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected)
    {
        self.selectedImageView.image = [GYImage imagesFromCustomBundle:@"gy_selected"];
    }
    else
    {
        self.selectedImageView.image = nil;
    }


}

@end
