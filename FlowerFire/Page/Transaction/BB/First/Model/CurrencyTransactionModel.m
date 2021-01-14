//
//  CurrencyTransactionModel.m
//  FireCoin
//
//  Created by 王涛 on 2019/6/15.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "CurrencyTransactionModel.h"

@implementation CurrencyTransactionModel

+ (NSDictionary *)modelCustomPropertyMapper {
    // 将personId映射到key为id的数据字段
    return @{@"tradeId":@"id"};
    
}


@end
