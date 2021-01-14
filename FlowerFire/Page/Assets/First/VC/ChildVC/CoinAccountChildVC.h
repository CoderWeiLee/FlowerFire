//
//  CoinAccountChildVC.h
//  FireCoin
//
//  Created by 赵馨 on 2019/5/27.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    CoinAccountTypeBB,   ///币币
    CoinAccountTypeHY,   //合约
    CoinAccountTypeFB,   //法币
} CoinAccountType;

typedef void(^setAssetsHeaderDataBlock)(NSString *data,NSString *CNYStr);

@interface CoinAccountChildVC : BaseViewController

@property(nonatomic, assign) CoinAccountType          coinAccountType;
@property(nonatomic, copy)   setAssetsHeaderDataBlock setAssetsHeaderDataBlock;
@end

NS_ASSUME_NONNULL_END
