//
//  JVShopcartBrandModel.m
//  JVShopcart
//
//  Created by AVGD-Jarvi on 17/3/23.
//  Copyright © 2017年 AVGD-Jarvi. All rights reserved.
//

#import "JVShopcartBrandModel.h"

@implementation JVShopcartBrandModel
  

// 声明自定义类参数类型
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"products" : [JVShopcartProductModel class] };
}


@end
