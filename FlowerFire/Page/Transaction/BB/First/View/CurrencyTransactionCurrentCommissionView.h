//
//  CurrencyTransactionCurrentCommissionView.h
//  FireCoin
//
//  Created by 王涛 on 2019/6/4.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "BaseUIView.h"
#import "CurrencyTransactionModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol CurrencyTransactionCurrentCommissionViewDelegate <NSObject>

-(void)getCommissonData;

@end

@interface CurrencyTransactionCurrentCommissionView : BaseUIView

@property(nonatomic, strong) NSMutableArray<CurrencyTransactionModel *> *dataArray;

@property(nonatomic, assign) NSInteger   pageIndex,allPages;
@property (assign,nonatomic) BOOL        isRefresh;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, weak) id<CurrencyTransactionCurrentCommissionViewDelegate> delegate;
@property(nonatomic, copy) backRefreshBlock backRefreshBlock;
@property(nonatomic, assign)int fromScale;      //交易对钱精确度(小数点后几位)
@property(nonatomic, assign)int toScale;        //交易对后精确度
@property(nonatomic, assign)int priceScale;     //价格精确度

- (void)downFreshloadData;
- (void)upFreshLoadMoreData;
- (void)setMjFresh;
@end

NS_ASSUME_NONNULL_END
