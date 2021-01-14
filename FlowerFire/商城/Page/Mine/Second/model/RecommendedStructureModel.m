//
//  RecommendedStructureModel.m
//  531Mall
//
//  Created by 王涛 on 2020/6/6.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "RecommendedStructureModel.h"

@implementation RecommendedStructureUsersModel

+ (NSDictionary *)modelCustomPropertyMapper {
    // 将personId映射到key为id的数据字段
    return @{@"userID":@"id"};
    
}

@end

@implementation RecommendedStructureNetIntrModel



@end

@implementation RecommendedStructureDownusersModel

+ (NSDictionary *)modelCustomPropertyMapper {
    // 将personId映射到key为id的数据字段
    return @{@"userID":@"id"};
    
}

- (NSString *)pay_date{
    return [HelpManager getTimeStr:_pay_date dataFormat:@"yyyy-MM-dd HH:mm:ss"];
}
 
@end

@implementation RecommendedStructureModel




+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value使用[YYEatModel class]或YYEatModel.class或@"YYEatModel"没有区别
    return @{@"net_intr" : [RecommendedStructureNetIntrModel class],
             @"users" : [RecommendedStructureUsersModel class],
             @"downusers" : [RecommendedStructureDownusersModel class]
    };
}

@end
