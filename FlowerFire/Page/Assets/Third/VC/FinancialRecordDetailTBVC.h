//
//  FinancialRecordDetailTBVC.h
//  FireCoin
//
//  Created by 王涛 on 2019/6/24.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "BaseTableViewController.h"
#import "FinanceRecordModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FinancialRecordDetailTBVC : BaseTableViewController


@property(nonatomic, strong)FinanceRecordModel  *model;
@property(nonatomic, strong)NSString            *coinName;
@property(nonatomic, strong)UILabel             *money;
@end

NS_ASSUME_NONNULL_END
