//
//  MemberLevelInfoModel.m
//  531Mall
//
//  Created by 王涛 on 2020/6/8.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "MemberLevelInfoModel.h"

@implementation MemberLevelRankNodeModel
@end
 
@implementation MemberLevelRankInfosModel
@end
 
@implementation MemberLevelInfoModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value使用[YYEatModel class]或YYEatModel.class或@"YYEatModel"没有区别
    return @{@"rankinfos" : [MemberLevelRankInfosModel class],
             @"nowrank"  : [MemberLevelRankInfosModel class],
             @"ranknode" : [MemberLevelRankNodeModel class]
    };
}

@end
