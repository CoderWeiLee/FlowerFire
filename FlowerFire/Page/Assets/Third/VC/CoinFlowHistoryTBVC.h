//
//  CoinFlowHistoryTBVC.h
//  FireCoin
//
//  Created by 王涛 on 2019/8/2.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    CoinFlowHistoryTypeDeposit,  //充币历史记录
    CoinFlowHistoryTypeWithdraw, //提币历史记录
} CoinFlowHistoryType;

@interface CoinFlowHistoryTBVC : BaseTableViewController

-(instancetype)initWithCoinFlowHistoryType:(CoinFlowHistoryType )type
                                    CoinId:(NSString *)coinId
                                    Symbol:(NSString *)symbol;

@end

NS_ASSUME_NONNULL_END
