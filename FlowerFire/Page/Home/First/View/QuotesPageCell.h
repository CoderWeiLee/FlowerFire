//
//  QuotesPageCell.h
//  FireCoin
//
//  Created by 王涛 on 2019/6/1.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "QuotesTransactionPairModel.h" 

NS_ASSUME_NONNULL_BEGIN

@interface QuotesPageCell : BaseTableViewCell

 
-(void)setCellData:(QuotesTransactionPairModel *)model;

@end

NS_ASSUME_NONNULL_END
