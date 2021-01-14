//
//  FinancialRecordTBVC.h
//  FireCoin
//
//  Created by 王涛 on 2019/6/22.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "BaseTableViewController.h"
#import "CoinAccountChildVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface FinancialRecordTBVC : BaseTableViewController

/**
 头部数据
 */
@property(nonatomic, strong) NSDictionary    *headerData;
@property(nonatomic, assign) CoinAccountType  coinAccountType;
@end

NS_ASSUME_NONNULL_END
