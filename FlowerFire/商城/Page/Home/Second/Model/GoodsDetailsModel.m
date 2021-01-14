//
//  ShopDetailsModel.m
//  531Mall
//
//  Created by 王涛 on 2020/6/3.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "GoodsDetailsModel.h"

@implementation GoodsDetailsHeavyModel

- (void)setImgs:(NSString *)imgs{
    _imgs = imgs;
    
    self.imgsArray = [imgs componentsSeparatedByString:@","];
}

@end

@implementation GoodsDetailsAttrsModel

- (NSString *)name{
   return [HelpManager isBlankString:_name] ? @"无" : _name;
}

- (NSString *)value{
    return [HelpManager isBlankString:_value] ? @"无" : _value;
}

@end

@implementation GoodsDetailsModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value使用[YYEatModel class]或YYEatModel.class或@"YYEatModel"没有区别
    return @{@"heavy" : [GoodsDetailsHeavyModel class],
             @"attrs" : [GoodsDetailsAttrsModel class]
    };
}


@end
