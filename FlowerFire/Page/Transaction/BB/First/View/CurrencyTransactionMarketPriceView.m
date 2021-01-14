//
//  CurrencyTransactionMarketPriceView.m
//  FireCoin
//
//  Created by 王涛 on 2019/6/4.
//  Copyright © 2019 王涛. All rights reserved.
//  市价视图

#import "CurrencyTransactionMarketPriceView.h"

@implementation CurrencyTransactionMarketPriceView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.PriceTF.enabled = NO;
        self.PriceTF.text = LocalizationKey(@"Optimal market price");
        self.PriceTF.theme_textColor = @"text_placeholder2" ;
        self.PriceTF.rightView = nil;
        self.PriceTF.theme_backgroundColor = THEME_TRANSFER_BACKGROUNDCOLOR;
        
        [self.CNYPrice setHidden:YES];
        
        [self.TradeNumber setHidden:YES];
    }
    return self;
}


@end
