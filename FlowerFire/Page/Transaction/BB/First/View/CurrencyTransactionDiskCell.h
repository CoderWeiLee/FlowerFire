//
//  CurrencyTransactionDiskCell.h
//  FireCoin
//
//  Created by 王涛 on 2019/6/4.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface CurrencyTransactionDiskCell : BaseTableViewCell

@property(nonatomic, strong) UILabel *priceLabel,*amountLabel;


/**
 设置cell数据
 
 @param dic 数据源
 @param isBuy 是否买盘
 @param priceScale 价格小数位数
 @param amountScale 数量小数位数
 */
-(void)setCellData:(NSDictionary *)dic
             isBuy:(BOOL)isBuy
     priceScale:(int)priceScale
    amountScale:(int)amountScale;

@end

NS_ASSUME_NONNULL_END
