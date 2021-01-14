//
//  CurrencyTransactionTitleView.h
//  FireCoin
//
//  Created by 王涛 on 2019/6/4.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "BaseUIView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CurrencyTransactionTitleViewDelegate <NSObject>

-(void)didTransactionPairClick:(UIButton *)btn;
-(void)jumpKLineClick:(UIButton *)btn;

@end

@interface CurrencyTransactionTitleView : BaseUIView

/**
 切换交易对按钮
 */
@property(nonatomic, strong) UIButton *switchTransactionPairBtn;
@property(nonatomic, weak)  id<CurrencyTransactionTitleViewDelegate> delegate;
@property(nonatomic, assign) double  changeNum;
@end

NS_ASSUME_NONNULL_END
