//
//  QuotesTradingZoneModel.m
//  FireCoin
//
//  Created by 王涛 on 2019/6/12.
//  Copyright © 2019 王涛. All rights reserved.
//  行情交易区model

#import "QuotesTradingZoneModel.h"

@implementation QuotesTradingZoneModel

// 声明自定义类参数类型
+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value使用[YYEatModel class]或YYEatModel.class或@"YYEatModel"没有区别
    return @{@"list" : [QuotesTransactionPairModel class] };
}

@end
