//
//  YDIAPHelper.h
//  YDSDK
//
//  Created by yd on 2017/10/20.
//  Copyright © 2017年 yd. All rights reserved.
//

#import <Foundation/Foundation.h>
@import StoreKit;


@protocol YDIAPHelperDelegate <NSObject>

@optional

- (void)receiveProduct:(SKProduct *)product;

- (void)successedWithReceipt:(NSData *)transactionReceipt;

- (void)failedPurchaseWithError:(NSString *)errorDescripiton;


@end


@interface YDIAPHelper : NSObject

@property (nonatomic, assign)id<YDIAPHelperDelegate> delegate;


+ (instancetype)iapHelper;

- (BOOL)requestProductWithId:(NSString *)productId;
- (BOOL)purchaseProduct:(SKProduct *)skProduct;
- (BOOL)restorePurchase;
- (void)refreshReceipt;
- (void)finishTransaction;

@end
