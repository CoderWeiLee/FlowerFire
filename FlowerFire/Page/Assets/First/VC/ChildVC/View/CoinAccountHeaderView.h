//
//  CoinAccountHeaderView.h
//  FireCoin
//
//  Created by 赵馨 on 2019/5/27.
//  Copyright © 2019 王涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoinAccountChildVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface CoinAccountHeaderView : UIView

@property(nonatomic, strong)WTButton *goBuyButton;
@property(nonatomic, strong)WTLabel  *time;

-(void)setHeaderData:(CoinAccountType )coinAccountType SumAssets:(NSString *)SumAssets CNYStr:(NSString *)CNYStr;
@end

NS_ASSUME_NONNULL_END
