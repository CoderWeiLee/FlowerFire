//
//  CoinFlowHistoryDetailsTBVC.h
//  FireCoin
//
//  Created by 王涛 on 2019/8/2.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "FinancialRecordDetailTBVC.h" 
#import "CoinFlowHistoryTBVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface CoinFlowHistoryDetailsTBVC : FinancialRecordDetailTBVC

/**
 CoinFlowHistoryTypeDeposit,  //充币历史记录
 CoinFlowHistoryTypeWithdraw, //提币历史记录
 */
@property(nonatomic, assign) CoinFlowHistoryType coinFlowHistoryType;
@property(nonatomic, strong) NSDictionary       *coinFlowHistoryDataSource; 
@end

NS_ASSUME_NONNULL_END
