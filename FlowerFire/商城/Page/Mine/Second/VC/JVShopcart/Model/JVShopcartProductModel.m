//
//  JVShopcartProductModel.m
//  JVShopcart
//
//  Created by AVGD-Jarvi on 17/3/23.
//  Copyright © 2017年 AVGD-Jarvi. All rights reserved.
//

#import "JVShopcartProductModel.h"

@implementation JVShopcartProductModel


//// 声明自定义类参数类型
//+ (NSDictionary *)modelContainerPropertyGenericClass {
//    return @{@"products" : [JVShopcartProductModel class] };
//}

+ (NSDictionary *)modelCustomPropertyMapper {
    // 将personId映射到key为id的数据字段
    return @{@"cartId":@"id"
             ,@"productPrice":@"second_price"
             ,@"brandName":@"name"
             ,@"productPicUri":@"img"
             ,@"brandId":@"good_id"
             ,@"productStocks":@"total_stock"
             ,@"productQty":@"amount"
             ,@"isSelected":@"is_choose"
             ,
    };
    
}



@end
