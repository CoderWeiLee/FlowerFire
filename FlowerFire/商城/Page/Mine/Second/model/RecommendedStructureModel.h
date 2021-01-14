//
//  RecommendedStructureModel.h
//  531Mall
//
//  Created by 王涛 on 2020/6/6.
//  Copyright © 2020 Celery. All rights reserved.
//  推荐结构

#import "WTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RecommendedStructureUsersModel : WTBaseModel

@property(nonatomic, copy)NSArray  *introduce_down_data;
@property(nonatomic, copy)NSString *introduce_layer;
@property(nonatomic, copy)NSString *pay_date;
@property(nonatomic, copy)NSString *state;
@property(nonatomic, copy)NSString *truename;
@property(nonatomic, copy)NSString *username;
@property(nonatomic, copy)NSString *introduce;
@property(nonatomic, copy)NSString *userID;

@end

@interface RecommendedStructureNetIntrModel : WTBaseModel

@property(nonatomic, copy)NSString *name;
@property(nonatomic, copy)NSString *sheet;
@property(nonatomic, copy)NSString *xnode;

@end

/// 下级会员信息
@interface RecommendedStructureDownusersModel : WTBaseModel

@property(nonatomic, copy)NSString       *userID;
/// 上级id
@property(nonatomic, copy)NSString       *introduce;
@property(nonatomic, copy)NSDictionary   *introduce_down_data;
@property(nonatomic, copy)NSString       *introduce_layer;
@property(nonatomic, copy)NSString       *memberrank;
/// 本月总业绩
@property(nonatomic, copy)NSString       *moth_pv;
@property(nonatomic, copy)NSString       *pay_date;
@property(nonatomic, copy)NSString       *state;
@property(nonatomic, copy)NSString       *truename;
@property(nonatomic, copy)NSString       *username;

@end

@interface RecommendedStructureModel : WTBaseModel

/// 推荐网字段名
@property(nonatomic, copy)NSString *sheet;
/// 显示层数
@property(nonatomic, copy)NSString *chengnums;
/// 第一个会员信息

@property(nonatomic, strong)RecommendedStructureUsersModel   *users;
/// 推荐节点信息
@property(nonatomic, strong)RecommendedStructureNetIntrModel *net_intr;
/// 下级会员信息
@property(nonatomic, strong)NSArray<RecommendedStructureDownusersModel *>  *downusers;

@end

NS_ASSUME_NONNULL_END
