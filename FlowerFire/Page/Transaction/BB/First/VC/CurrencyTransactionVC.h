//
//  CurrencyTransactionVC.h
//  FireCoin
//
//  Created by 王涛 on 2019/6/4.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "BaseTableViewController.h"
#import "CurrencyTransactionQuotesView.h"
#import "CurrencyTransactionTitleView.h"
NS_ASSUME_NONNULL_BEGIN

@interface CurrencyTransactionVC : BaseTableViewController

@property(nonatomic, strong) CurrencyTransactionQuotesView *quotesView; //中部的行情视图

@property(nonatomic, strong) CurrencyTransactionTitleView  *headerView;  //头部视图

@property(nonatomic, strong) UIScrollView                  *scrollView;
@end

NS_ASSUME_NONNULL_END
