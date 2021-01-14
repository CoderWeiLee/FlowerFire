//
//  KLineTradeCell.h
//  FireCoin
//
//  Created by 王涛 on 2019/6/6.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface KLineTradeCell : BaseTableViewCell

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *buyType;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *amountLabel;

-(void)setCellData:(NSDictionary *)dic
     priceScale:(int)priceScale
    fromScale:(int)fromScale;

-(void)setCellData:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
