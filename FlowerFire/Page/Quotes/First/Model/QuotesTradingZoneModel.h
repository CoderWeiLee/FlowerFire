//
//  QuotesTradingZoneModel.h
//  FireCoin
//
//  Created by 王涛 on 2019/6/12.
//  Copyright © 2019 王涛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuotesTransactionPairModel.h"
#import "WTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QuotesTradingZoneModel : WTBaseModel
 
@property(nonatomic, copy)   NSString *coin_id;  //交易区id
@property(nonatomic, copy)   NSString *symbol;   //交易区符号
@property(nonatomic, strong) NSArray<QuotesTransactionPairModel *> *list; //交易区交易对列表

@end

NS_ASSUME_NONNULL_END
