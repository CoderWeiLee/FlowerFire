//
//  CurrencyOrderDetailTBVC.h
//  FireCoin
//
//  Created by 王涛 on 2019/6/17.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CurrencyOrderDetailTBVC : BaseTableViewController

/**
 委托单id
 */
@property(nonatomic, strong)NSString *trade_id;

@end

NS_ASSUME_NONNULL_END
