//
//  LWNewsModel.m
//  FlowerFire
//
//  Created by 李伟 on 2021/1/20.
//  Copyright © 2021 Celery. All rights reserved.
//

#import "LWNewsModel.h"
#import <MJExtension/MJExtension.h>
@implementation LWNewsModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID": @"id"};
}
@end
