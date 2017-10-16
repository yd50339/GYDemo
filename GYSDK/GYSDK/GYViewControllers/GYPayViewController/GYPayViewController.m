//
//  GYPayViewController.m
//  GYSDK
//
//  Created by yd on 2017/8/3.
//  Copyright © 2017年 yd. All rights reserved.
//

#import "GYPayViewController.h"
#import "GYPayTableViewCell.h"
#import "GYAlipay.h"
#import "GYWXPay.h"
#import "GYProduct.h"

@interface GYPayViewController ()
<UITableViewDataSource,
UITableViewDelegate>
@property(nonatomic , strong)NSArray * dataArray;
@property(nonatomic , strong)NSMutableArray * storeArray;
@property(nonatomic , strong)UILabel * nameLabel;
@property(nonatomic , strong)UITableView * payTableView;
@property(nonatomic , strong)UIImageView * closeImageView;
@property(nonatomic , strong)UILabel * prizeLabel;
@property(nonatomic , strong)UILabel * totalLabel;
@property(nonatomic , strong)UILabel * timeLabel;
@property(nonatomic , strong)NSTimer * timer;
@property(nonatomic , assign)long  secondsCountDown;
@end

@implementation GYPayViewController


- (void)loadView
{
    self.view = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
    self.navigationItem.title = @"收银台";
    
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, 74, CGRectGetWidth(self.view.frame), 43)];
    topView.backgroundColor = [UIColor whiteColor];
    topView.layer.borderWidth = 1;
    topView.layer.borderColor = [UIColor colorWithRed:231/255.0 green:230/255.0 blue:230/255.0 alpha:1].CGColor;
    [self.view addSubview:topView];
    
    UILabel * zfbLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, (CGRectGetHeight(topView.frame) - 40) * 0.5, 120, 40)];
    zfbLabel.text = @"支付金额";
    zfbLabel.textColor = [UIColor grayColor];
    [topView addSubview:zfbLabel];
    
    CGRect prizeRect = topView.frame;
    prizeRect.size.width = 120;
    prizeRect.size.height = 40;
    prizeRect.origin.y = CGRectGetMinY(zfbLabel.frame);
    prizeRect.origin.x = CGRectGetWidth(topView.frame) - CGRectGetWidth(prizeRect) - 15;
    self.prizeLabel = [[UILabel alloc]initWithFrame:prizeRect];
    self.prizeLabel.text = @"¥0";
    self.prizeLabel.font =  [UIFont fontWithName:@"HiraginoSansGB-W3" size:17.f];
    self.prizeLabel.textAlignment = NSTextAlignmentRight;
    self.prizeLabel.textColor = [UIColor colorWithRed:255/255.0 green:39/255.0 blue:66/255.0 alpha:1];
    [topView addSubview:self.prizeLabel];
    
    CGRect headRect = CGRectZero;
    headRect.size.height = 43;
    headRect.size.width = CGRectGetWidth(self.view.frame);
    UIView * headView = [[UIView alloc]initWithFrame:headRect];
    headView.layer.borderWidth = 1;
    headView.layer.borderColor = [UIColor colorWithRed:231/255.0 green:230/255.0 blue:230/255.0 alpha:1].CGColor;
    headView.backgroundColor = [UIColor whiteColor];
    
    CGRect typeRect = headRect;
    typeRect.size.width = 80;
    typeRect.size.height = 40;
    typeRect.origin.x = 15;
    typeRect.origin.y = (CGRectGetHeight(headView.frame) - CGRectGetHeight(typeRect)) * 0.5;
    UILabel * typeLabel = [[UILabel alloc]initWithFrame:typeRect];
    typeLabel.text = @"支付方式";
    typeLabel.textColor = [UIColor grayColor];
    [headView addSubview:typeLabel];
    
    CGRect nameRect = headRect;
    nameRect.size.width =  80;
    nameRect.size.height = 40;
    nameRect.origin.x = CGRectGetMaxX(typeLabel.frame) + 25;
    nameRect.origin.y = (CGRectGetHeight(headView.frame) - CGRectGetHeight(nameRect)) * 0.5;
    self.nameLabel = [[UILabel alloc]initWithFrame:nameRect];
    self.nameLabel.text = @"支付宝";
    self.nameLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    [headView addSubview:self.nameLabel];
    
    
    UIImage * image = [GYImage imagesFromCustomBundle:@"gy_switch"];
    CGRect closeRect = CGRectZero;
    closeRect.size.width = image.size.width;
    closeRect.size.height = image.size.height;
    closeRect.origin.x = CGRectGetWidth(headView.frame) - CGRectGetWidth(closeRect) - 15;
    closeRect.origin.y = (CGRectGetHeight(headView.frame) - CGRectGetHeight(closeRect)) * 0.5;
    self.closeImageView = [[UIImageView alloc]initWithFrame:closeRect];
    self.closeImageView.image = image;
    self.closeImageView.layer.transform = CATransform3DRotate(CATransform3DIdentity, M_PI, 0, 0, 1);
    [headView addSubview:self.closeImageView];
    CGRect closeBtnRect = closeRect;
    closeBtnRect.size.width = 50;
    closeBtnRect.size.height = CGRectGetHeight(headView.frame);
    closeBtnRect.origin.y = 0;
    closeBtnRect.origin.x = CGRectGetMaxX(headView.frame) - CGRectGetWidth(closeBtnRect);
    UIButton * closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = closeBtnRect;
    [closeBtn addTarget:self action:@selector(closeBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:closeBtn];

    
    CGRect tableRect = self.view.frame;
    tableRect.size.height = CGRectGetHeight(self.view.frame) - CGRectGetMaxY(topView.frame) - 10 - 60;
    tableRect.origin.y = CGRectGetMaxY(topView.frame) + 10;
    self.payTableView =  [[UITableView alloc]initWithFrame:tableRect style:UITableViewStylePlain];
    self.payTableView.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];;
    self.payTableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    self.payTableView.tableHeaderView = headView;
    self.payTableView.delegate = self;
    self.payTableView.dataSource = self;
    [self.view addSubview:self.payTableView];
    
    
    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.payTableView.frame), CGRectGetWidth(self.view.frame), 60)];
    bottomView.backgroundColor = [UIColor whiteColor];
    bottomView.layer.borderWidth = 1;
    bottomView.layer.borderColor = [UIColor colorWithRed:231/255.0 green:230/255.0 blue:230/255.0 alpha:1].CGColor;
    [self.view addSubview:bottomView];
    
    
    
    NSMutableAttributedString * totalString = [[NSMutableAttributedString alloc]initWithString:@"总计: "];
    NSMutableAttributedString * prizeString = [[NSMutableAttributedString alloc]initWithString:@"¥0"
                                                                                    attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor colorWithRed:255/255.0 green:39/255.0 blue:66/255.0 alpha:1]}];
     [totalString appendAttributedString:prizeString];
    
    CGRect totalRect = bottomView.frame;
    totalRect.size.width = 160;
    totalRect.size.height = 40;
    totalRect.origin.x = 15;
    totalRect.origin.y = (CGRectGetHeight(bottomView.frame) - CGRectGetHeight(totalRect)) * 0.5;
    self.totalLabel = [[UILabel alloc]initWithFrame:totalRect];
    self.totalLabel.attributedText = totalString;
    [bottomView addSubview:self.totalLabel];
    

    CGRect payBtnRect = CGRectZero;
    payBtnRect.size.width = 135;
    payBtnRect.size.height = 39;
    payBtnRect.origin.x = CGRectGetWidth(bottomView.frame) - CGRectGetWidth(payBtnRect) - 15;
    payBtnRect.origin.y = (CGRectGetHeight(bottomView.frame) - CGRectGetHeight(payBtnRect)) * 0.5;
    UIButton * payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    payButton.frame = payBtnRect;
    payButton.layer.cornerRadius = CGRectGetHeight(payButton.frame) * 0.2;
    [payButton addTarget:self action:@selector(payButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
    payButton.backgroundColor = [UIColor redColor];
    [bottomView addSubview:payButton];
    
    
    CGRect payLabRect = payBtnRect;
    payLabRect.origin.x = CGRectGetMinX(payBtnRect) + 10;
    payLabRect.size.width = 40;
    payLabRect.size.height = 40;
    UILabel * payLabel = [[UILabel alloc]initWithFrame:payLabRect];
    payLabel.text = @"支付";
    payLabel.textColor = [UIColor whiteColor];
    payLabel.font = [UIFont systemFontOfSize:18];
    [bottomView addSubview:payLabel];
    
    UIImage * timeImage = [GYImage imagesFromCustomBundle:@"gy_cutDown"];
    UIImageView * timeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(payLabRect), (CGRectGetHeight(bottomView.frame) - 18.5) * 0.5, 18.5, 18.5)];
    timeImageView.image = timeImage;
    [bottomView addSubview:timeImageView];
    
    CGRect timeLabRect = payLabRect;
    timeLabRect.origin.x = CGRectGetMaxX(timeImageView.frame) + 5;
    timeLabRect.size.width = 50;
    self.timeLabel = [[UILabel alloc]initWithFrame:timeLabRect];
    self.timeLabel.text = @"30:00";
    self.timeLabel.textColor = [UIColor whiteColor];
    self.timeLabel.font = [UIFont systemFontOfSize:18];
    [bottomView addSubview:self.timeLabel];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSIndexPath * selIndex = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.payTableView selectRowAtIndexPath:selIndex animated:YES scrollPosition:UITableViewScrollPositionTop];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    NSString * price = [self.productInfo stringForKey:@"price"];
    self.prizeLabel.text = [NSString stringWithFormat:@"¥%@",price];
    
    
    NSMutableAttributedString * totalString = [[NSMutableAttributedString alloc]initWithString:@"总计: "];
    NSMutableAttributedString * prizeString = [[NSMutableAttributedString alloc]initWithString:self.prizeLabel.text
                                                                                    attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor colorWithRed:255/255.0 green:39/255.0 blue:66/255.0 alpha:1]}];
    [totalString appendAttributedString:prizeString];
    self.totalLabel.attributedText = totalString;
    
    self.dataArray = @[@{@"type":@"支付宝",
                         @"icon":@"gy_zfb"},
                       @{@"type":@"微信",
                         @"icon":@"gy_weixin"}];
    self.storeArray = [NSMutableArray arrayWithArray:self.dataArray];
    self.secondsCountDown = 60 * 30;
    [self countTime];

}

//倒计时30分钟
- (void)countTime
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(countDownAction)
                                                userInfo:nil repeats:YES];
    [self.timer fire];
}

-(void)countDownAction
{
    self.secondsCountDown -- ;
    NSString * minute = [NSString stringWithFormat:@"%02ld",(self.secondsCountDown % 3600)/60];
    NSString * second = [NSString stringWithFormat:@"%02ld",self.secondsCountDown % 60];
    NSString * formatTime = [NSString stringWithFormat:@"%@:%@",minute,second];
    self.timeLabel.text = [NSString stringWithFormat:@"%@",formatTime];
    if(self.secondsCountDown == 0)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
}

#pragma mark - ButtonOnClick

- (void)closeBtnOnClick:(UIButton *)sender
{
    if (sender.selected)
    {
        self.closeImageView.layer.transform = CATransform3DRotate(CATransform3DIdentity, M_PI, 0, 0, 1);
        self.dataArray = self.storeArray;
    }
    else
    {
        self.closeImageView.layer.transform = CATransform3DIdentity;
        self.dataArray = nil;
    }
    [self.payTableView reloadData];
    sender.selected = !sender.selected;

}

- (void)payButtonOnClick
{
    [self requestCreateOrder];
}

#pragma mark -  Register Request

- (void)requestCreateOrder
{
    GYProduct * product = [[GYProduct alloc]init];
    product.name = [self.productInfo stringForKey:@"name"];
    product.price = [self.productInfo stringForKey:@"price"];
    
    NSDictionary * dict = [[NSUserDefaults standardUserDefaults] objectForKey:kGYKeyChainKey];
    NSString * userId = [dict stringForKey:@"userId"];
    NSDictionary * param = @{@"user":@{@"userid":userId},
                             @"games":@{@"gameid":@"39"},
                             @"ordergoods":@[@{@"orderid":@"",
                                               @"number":@"",
                                               @"title":product.name,
                                               @"price":product.price}],
                             @"payment":product.price};
    
    [[GYNetwork network]requestwithParam:param
                                        path:@"order/create"
                                      method:@"POST"
                                    response:^(NSDictionary *resObj)
         {
             NSLog(@"%@",resObj);
             
             
             [self requestSign:[resObj stringForKey:@"orderid"]];

         }];
    
}


- (void)requestSign:(NSString *)orderId
{
     NSString * price = [self.productInfo stringForKey:@"price"];
    [[GYNetwork network]requestwithParam:@{@"orderid":orderId ? :@""}
                                    path:@"alipay/pay"
                                        method:@"POST"
                                      response:^(NSDictionary *resObj)
     {
         NSLog(@"%@",resObj);
         [GYAlipay doAlipayPay:[resObj stringForKey:@"paydata"]];
     }];
}

#pragma mark - Delegate DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"cell";
    GYPayTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[GYPayTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    [cell setcell:[self.dataArray objectAtIndex:indexPath.item]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.nameLabel.text = self.dataArray[indexPath.item][@"type"];
}


@end
