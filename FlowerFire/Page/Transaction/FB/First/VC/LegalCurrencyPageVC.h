//
//  LegalCurrencyPageVC.h
//  FireCoin
//
//  Created by 赵馨 on 2019/5/28.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LegalCurrencyPageVC : BaseTableViewController

@property(nonatomic, strong) NSString   *limit_min;//筛选 limit_min 最小金额
@property(nonatomic, strong) NSString   *payMent; //筛选 payMent 收款方式
@property(nonatomic, strong) NSString   *coin_id;
@property(nonatomic, strong) NSString   *coinName;
/**
 我要买 参数用1
 我要卖 参数用0
 */
@property(nonatomic, strong) NSString   *buyOrSell; // 0购买 1出售 
@end

NS_ASSUME_NONNULL_END
