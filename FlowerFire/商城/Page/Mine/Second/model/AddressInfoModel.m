//
//  AddressInfoModel.m
//  531Mall
//
//  Created by 王涛 on 2020/6/3.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "AddressInfoModel.h"

@implementation AddressInfoModel

+ (NSDictionary *)modelCustomPropertyMapper {
    // 将personId映射到key为id的数据字段
    return @{@"AddressId":@"id"};
    
}

@end
