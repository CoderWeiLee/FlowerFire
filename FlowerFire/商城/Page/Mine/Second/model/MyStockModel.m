//
//  MyStockModel.m
//  531Mall
//
//  Created by 王涛 on 2020/6/12.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "MyStockModel.h"

@implementation MyStockSkuInfoModel
 
+ (NSDictionary *)modelCustomPropertyMapper {
    // 将personId映射到key为id的数据字段
    return @{@"skuInfoID":@"id"};
    
}

@end

@implementation MyStockSkuListModel

 + (NSDictionary *)modelCustomPropertyMapper {
     // 将personId映射到key为id的数据字段
     return @{@"skuListID":@"id"};
     
 }

- (NSString *)created_time{
    return [HelpManager getTimeStr:_created_time dataFormat:@"yyyy-MM-dd\nHH:mm:ss"];
}

@end

@implementation MyStockModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value使用[YYEatModel class]或YYEatModel.class或@"YYEatModel"没有区别
    return @{@"sku_info" : [MyStockSkuInfoModel class],
             @"sku_list" : [MyStockSkuListModel class]
    };
}

@end
