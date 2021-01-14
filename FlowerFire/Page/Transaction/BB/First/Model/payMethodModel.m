//
//  payMethodModel.m
//  FireCoin
//
//  Created by 王涛 on 2019/6/10.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "payMethodModel.h"

@implementation payMethodModel

+ (NSDictionary *)modelCustomPropertyMapper {
    // 将personId映射到key为id的数据字段
    return @{@"referenceId":@"id"};
    
}

@end
