//
//  MyOrderModel.m
//  531Mall
//
//  Created by 王涛 on 2020/6/4.
//  Copyright © 2020 Celery. All rights reserved.
//  

#import "MyOrderModel.h"

@implementation MyOrderGoodInfoModel
 

@end

@implementation MyOrderModel

+ (NSDictionary *)modelCustomPropertyMapper {
    // 将personId映射到key为id的数据字段
    return @{@"orderID":@"id"};
    
}


+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value使用[YYEatModel class]或YYEatModel.class或@"YYEatModel"没有区别
    return @{@"good_info" : [MyOrderGoodInfoModel class]};
}
 

@end
