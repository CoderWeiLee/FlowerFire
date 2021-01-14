//
//  CurrencyTransactionTakeProfitStopLossView.h
//  FireCoin
//
//  Created by 王涛 on 2019/6/4.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "BaseUIView.h"
#import "CurrencyTransactionLimitPriceView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CurrencyTransactionTakeProfitStopLossView : CurrencyTransactionLimitPriceView

/**
 触发价
 */ 
@property(nonatomic, strong) UITextField *TriggerPriceTF;

/**
 触发价的CNY
 */
@property(nonatomic, strong) UILabel *TriggerCNYLabel;
@end

NS_ASSUME_NONNULL_END
