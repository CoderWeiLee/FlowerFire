//
//  FFMinerListModel.h
//  FlowerFire
//
//  Created by 王涛 on 2020/8/27.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "WTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FFMinerListModel : WTBaseModel

/// 会员编号
@property(nonatomic, copy)NSString *username;
/// 激活时间
@property(nonatomic, copy)NSString *activation_time;
/// SD钱包余额
@property(nonatomic, copy)NSString *money;
/// 下级设备数量
@property(nonatomic, copy)NSString *down_equipment_count;
/// 下级会员数量
@property(nonatomic, copy)NSString *down_user_count;
/// 钱包地址
@property(nonatomic, copy)NSString *address;
/// 团队持币
@property(nonatomic, copy)NSString *team_money;



@end

NS_ASSUME_NONNULL_END
