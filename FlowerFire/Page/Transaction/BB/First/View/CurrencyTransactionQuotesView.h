//
//  CurrencyTransactionQuotesView.h
//  FireCoin
//
//  Created by 王涛 on 2019/6/4.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "BaseUIView.h"
#import "CurrencyTransactionLimitPriceView.h"
#import "CurrencyTransactionMarketPriceView.h"
#import "CurrencyTransactionTakeProfitStopLossView.h"
#import "QuotesTransactionPairModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CurrencyTransactionQuotesViewDelegate <NSObject>

/**
 查看钱包余额

 @param coidId 币id
 */
-(void)getCCWaltWithCoinId:(NSString *)coidId;
/**
 发布委托单
 */
-(void)releaseCommissionClick:(NSDictionary *)netDic;
@end

typedef enum : NSUInteger {
    CCQuotesTransactionTypeLimitPrice = 0, //限价交易
    CCQuotesTransactionTypeMarketPrice, //市价交易
    CCQuotesTransactionTypeTakeProfitStopLoss,//止盈止损
    
} CCQuotesTransactionType;

@interface CurrencyTransactionQuotesView : BaseUIView

/**
 用leftView的底部获取这个视图的高度
 */
@property(nonatomic, strong)UIView *leftView;

@property(nonatomic, strong) UIButton *chooseBuyBtn,*chooseSaleBtn;
/**
  币币交易类型
 CCQuotesTransactionTypeLimitPrice = 0, //限价交易
 CCQuotesTransactionTypeMarketPrice, //市价交易
 CCQuotesTransactionTypeTakeProfitStopLoss,//止盈止损
 */
@property(nonatomic, assign) CCQuotesTransactionType CCQuotesTransactionType;
@property(nonatomic, strong) CurrencyTransactionLimitPriceView          *limitPriceView;  //限价
@property(nonatomic, strong) CurrencyTransactionMarketPriceView         *marketPriceView; //市价
@property(nonatomic, strong) CurrencyTransactionTakeProfitStopLossView  *takeProfitStopLossView;  //止盈止损
@property(nonatomic, strong) NSDictionary *coinNameDic;
@property(nonatomic, assign) BOOL isSell;//是否卖出状态;
@property(nonatomic, strong) UILabel *nowPrice; //列表上foterview的现价
@property(nonatomic, strong) UILabel *nowCNY;   //列表上foterview的现价
@property(nonatomic, assign) int fromScale;     //交易对钱精确度(小数点后几位)
@property(nonatomic, assign) int toScale;       //交易对后精确度
@property(nonatomic, assign) int priceScale;     //价格精确度
@property(nonatomic, weak)   id<CurrencyTransactionQuotesViewDelegate> delegate;
@property(nonatomic, strong) QuotesTransactionPairModel  *pairModel;

/// 钱包钱数
@property(nonatomic, strong) NSString  *moneyNum;

/**
 买入卖出数组
 */
@property(nonatomic, strong) NSMutableArray *bidcontentArr,*askcontentArr;
@property(nonatomic, strong)UITableView *BuyTableView; //买盘
@property(nonatomic, strong)UITableView *SaleTableView;  //卖盘
-(void)chooseBuyClick:(UIButton *)btn; 
-(void)chooseSaleClick:(UIButton *)btn;
@end

NS_ASSUME_NONNULL_END
