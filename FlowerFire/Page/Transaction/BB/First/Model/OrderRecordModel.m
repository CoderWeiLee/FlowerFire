//
//  OrderRecordModel.m
//  FireCoin
//
//  Created by 王涛 on 2019/5/30.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "OrderRecordModel.h"

@implementation tradeUserInfoModel


@end

@implementation orderUserInfoModel


@end

@implementation OrderRecordModel

// 声明自定义类参数类型
+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value使用[YYEatModel class]或YYEatModel.class或@"YYEatModel"没有区别
    return @{@"pay_list" : [payMethodModel class],@"ower" : [owerModel class]
             ,@"trade_uinfo":[tradeUserInfoModel class],@"order_uinfo":[orderUserInfoModel class]};
}
 
+ (NSDictionary *)modelCustomPropertyMapper {
    // 将personId映射到key为id的数据字段
    return @{@"otcOrderId":@"id"};
    
}

- (NSString *)symbol{
    if([HelpManager isBlankString:_symbol]){
         return @"";
    }else{
        return _symbol;
    }
}

 


@end
