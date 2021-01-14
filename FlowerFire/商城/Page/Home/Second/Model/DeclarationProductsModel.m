//
//  DeclarationProductsModel.m
//  531Mall
//
//  Created by 王涛 on 2020/6/12.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "DeclarationProductsModel.h"

@implementation DeclarationProductsGoodsModel

- (NSString *)amount{
    return NSStringFormat(@"%@盒",_amount);
}

@end

@implementation DeclarationProductsModel

+ (NSDictionary *)modelCustomPropertyMapper {
    // 将personId映射到key为id的数据字段
    return @{@"productsID":@"id"};
    
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"goods" : [DeclarationProductsGoodsModel class],
    };
}

@end
