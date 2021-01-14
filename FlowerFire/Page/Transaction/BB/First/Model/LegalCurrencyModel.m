//
//  LegalCurrencyModel.m
//  FireCoin
//
//  Created by 王涛 on 2019/5/28.
//  Copyright © 2019 王涛. All rights reserved.
//   

#import "LegalCurrencyModel.h"

@implementation owerModel


@end

@implementation LegalCurrencyModel

// 声明自定义类参数类型
+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value使用[YYEatModel class]或YYEatModel.class或@"YYEatModel"没有区别
    return @{@"ower" : [owerModel class],@"pay_list": [payMethodModel class]};
}

+ (NSDictionary *)modelCustomPropertyMapper {
    // 将personId映射到key为id的数据字段
    return @{@"otcId":@"id"};
     
}


@end

