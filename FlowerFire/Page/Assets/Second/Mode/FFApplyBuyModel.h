//
//  FFApplyBuyModel.h
//  FlowerFire
//
//  Created by 王涛 on 2020/8/31.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "WTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 获取认购时间,最大认购量,以及一个usdt兑换SD的数量,该参数返回2说明一个usdt兑换2个SD,post提交认购
@interface FFApplyBuyModel : WTBaseModel

@property(nonatomic, copy)NSString *end_time;
/// 最大认购量
@property(nonatomic, copy)NSString *max_exchange_amount;
/// 一个usdt兑换percentage个SD
@property(nonatomic, copy)NSString *percentage;
/// 获取认购时间
@property(nonatomic, copy)NSString *start_time;
 
@end

NS_ASSUME_NONNULL_END
