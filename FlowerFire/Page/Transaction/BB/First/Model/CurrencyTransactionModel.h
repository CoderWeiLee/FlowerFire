//
//  CurrencyTransactionModel.h
//  FireCoin
//
//  Created by 王涛 on 2019/6/15.
//  Copyright © 2019 王涛. All rights reserved.
//  币币交易委托单model

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CurrencyTransactionModel : NSObject

@property(nonatomic, copy) NSString *tradeId;            //委托单Id
@property(nonatomic, copy) NSString *order_sn;
@property(nonatomic, copy) NSString *price;              //金额
@property(nonatomic, copy) NSString *amount;             //数量
@property(nonatomic, copy) NSString *surplus;            //剩余可交易数量
@property(nonatomic, copy) NSString *trade_amount;       //已交易数量
@property(nonatomic, copy) NSString *addtime;            //发布时间
@property(nonatomic, assign) int    order_status;       //委托单状态
@property(nonatomic, copy) NSString *order_type;         //0买 1卖
@property(nonatomic, copy) NSString *price_type;         //委托单交易方式
@property(nonatomic, copy) NSString *order_status_name;  //"挂售中" 委托单状态字符串输出
@property(nonatomic, copy) NSString *order_type_name;    //买入。类型字符串输出
@property(nonatomic, copy) NSString *price_type_name;    //限价  委托单交易方式字符串输出
@property(nonatomic, copy) NSString *total_amount;       //成交总额
@property(nonatomic, copy) NSString *from_symbol;        //左边币名
@property(nonatomic, copy) NSString *to_symbol;          //右边币名
@property(nonatomic, copy) NSString *deal_price;         //成交均价
@property(nonatomic, copy) NSString *finishtime;         //结束时间
@property(nonatomic, copy) NSString *fee_amount;         //手续费
@property(nonatomic, copy) NSString *deal_amount;        // 成交量
@end

NS_ASSUME_NONNULL_END
