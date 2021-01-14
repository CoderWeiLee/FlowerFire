//
//  FFMinerHeaderModel.h
//  FlowerFire
//
//  Created by 王涛 on 2020/8/27.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "WTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FFMinerHeaderModel : WTBaseModel

/// 今日新增会员
@property(nonatomic, copy)NSString *day_user_count;
/// 今日新增设备
@property(nonatomic, copy)NSString *day_equipment_count;
/// 累计新增会员
@property(nonatomic, copy)NSString *all_user_count;
/// 累计新增设备
@property(nonatomic, copy)NSString *all_equipment_count;
/// 有效设备总数
@property(nonatomic, copy)NSString *effective_equipment_count;
 
@end

NS_ASSUME_NONNULL_END
