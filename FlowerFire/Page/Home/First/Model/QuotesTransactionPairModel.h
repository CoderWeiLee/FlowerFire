//
//  QuotesTransactionPairModel.h
//  FireCoin
//
//  Created by 王涛 on 2019/6/12.
//  Copyright © 2019 王涛. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QuotesTransactionPairModel : NSObject


@property(nonatomic, copy) NSString *market_id;     //交易对id
@property(nonatomic, copy) NSString *from;          //交易对前货币id
@property(nonatomic, copy) NSString *from_symbol;   //用什么币  交易对前货币符号
@property(nonatomic, copy) NSString *to ;           //交易对后货币id
@property(nonatomic, copy) NSString *to_symbol;     //要买的币  交易对后货币符号
@property(nonatomic, copy) NSString *display_name;  //交易对全名
@property(nonatomic, copy) NSString *New_price;     //最新交易价格
@property(nonatomic, copy) NSString *buy_min;       //买入交易最小数量
@property(nonatomic, copy) NSString *buy_max;       //买入交易最大数量 0 为不限制
@property(nonatomic, copy) NSString *sell_min;      //卖出交易最小数量
@property(nonatomic, copy) NSString *sell_max;      //卖出交易最大数量 0 为不限制
@property(nonatomic, copy) NSString *market_min;    //市价模式最小交易数量
@property(nonatomic, copy) NSString *market_max;    //市价模式最大交易数量 0 为不限制
@property(nonatomic, copy) NSString *fee_buy;       //买入手续费比例
@property(nonatomic, copy) NSString *fee_sell;      //卖出手续费比例
@property(nonatomic, assign) int dec;               //小数位
@property(nonatomic, copy) NSString *change;        //涨跌幅
@property(nonatomic, copy) NSString *deal_amount_24h;    //24小时成交量
@property(nonatomic, copy) NSString *high_price;    //最高价
@property(nonatomic, copy) NSString *low_price;    //最低价
@property(nonatomic, assign) int from_dec;          //交易对前小数位
@property(nonatomic, assign) int to_dec;            //交易对后小数位
@property(nonatomic, assign) int sys_dec;           //系统交易精度小数位
@end

NS_ASSUME_NONNULL_END
