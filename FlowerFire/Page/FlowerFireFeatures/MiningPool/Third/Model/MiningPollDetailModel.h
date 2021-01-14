//
//  MiningPollDetailModel.h
//  FlowerFire
//
//  Created by 王涛 on 2020/8/27.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "WTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MiningPollDetailModel : WTBaseModel

/// 最佳持币
@property(nonatomic, copy)NSString *best_power;
/// 最低持币
@property(nonatomic, copy)NSString *lowest_power;
/// 累积总挖出
@property(nonatomic, copy)NSString *total_coins;

/// 当日挖出
@property(nonatomic, copy)NSString *day_coins;
/// 当日持币算力
@property(nonatomic, copy)NSString *hold_power;
/// 当日推广算力
@property(nonatomic, copy)NSString *recommend_power;

 /// 当日用户持币算力
 @property(nonatomic, copy)NSString *hold_rank;
 
@property(nonatomic, copy)NSString *locking_money;
@property(nonatomic, copy)NSString *lock_money;
@property(nonatomic, copy)NSString *today_total;
@property(nonatomic, copy)NSString *lock_total;




@end

NS_ASSUME_NONNULL_END
