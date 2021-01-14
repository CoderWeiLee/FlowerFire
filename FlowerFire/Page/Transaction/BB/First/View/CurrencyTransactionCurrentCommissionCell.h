//
//  CurrencyTransactionCurrentCommissionCell.h
//  FireCoin
//
//  Created by 王涛 on 2019/6/4.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "CurrencyTransactionModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^currentCommissionCancelBlock)(UITableViewCell *cell);

@interface CurrencyTransactionCurrentCommissionCell : BaseTableViewCell

@property(nonatomic, copy) currentCommissionCancelBlock cancelBlcok;

-(void)setCellData:(CurrencyTransactionModel *)model
         fromScale:(int )fromScale
           toScale:(int)toScale
        priceScale:(int)priceScale;
 
@end

NS_ASSUME_NONNULL_END
