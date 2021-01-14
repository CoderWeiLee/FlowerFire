//
//  KLineTradeHeaderView.h
//  FireCoin
//
//  Created by 王涛 on 2019/6/6.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "BaseUIView.h"

NS_ASSUME_NONNULL_BEGIN

@interface KLineTradeHeaderView : BaseUIView

@property(nonatomic, strong) UILabel *timeLabel;
@property(nonatomic, strong) UILabel *directionLabel;
@property(nonatomic, strong) UILabel *priceLabel;
@property(nonatomic, strong) UILabel *amountLabel;

-(void)setPriceStr:(NSString *)priceStr amountStr:(NSString *)amountStr;

/**
 设置头部label的数据，因为张和币的设置需要显示不同
 */
-(void)setTradeHeaderLabelStr;

/**
 设置币股的头部数据
 */
-(void)setSecuritiesTradHeaderLabelStr:(NSString *)stockCode;
@end

NS_ASSUME_NONNULL_END
