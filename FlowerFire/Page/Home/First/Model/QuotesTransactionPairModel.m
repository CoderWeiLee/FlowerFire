//
//  QuotesTransactionPairModel.m
//  FireCoin
//
//  Created by 王涛 on 2019/6/12.
//  Copyright © 2019 王涛. All rights reserved.
//  交易对详情

#import "QuotesTransactionPairModel.h"

@implementation QuotesTransactionPairModel

+ (NSDictionary *)modelCustomPropertyMapper {
    // 将personId映射到key为id的数据字段
    return @{@"New_price":@"new_price"};
    
}

@end
