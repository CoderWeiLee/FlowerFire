//
//  FinancialRecordCell.h
//  FireCoin
//
//  Created by 王涛 on 2019/6/22.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "FinanceRecordModel.h"
#import "CoinAccountChildVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface FinancialRecordCell : BaseTableViewCell

-(void)setCellData:(FinanceRecordModel *)model
   CoinAccountType:(CoinAccountType )coinAccountType;

/**
  
 @param dic 充值或提币流水记录的数据
 */
-(void)setCoinFlowData:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
