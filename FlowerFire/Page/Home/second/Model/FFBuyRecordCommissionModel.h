//
//  FFBuyRecordCommisionModel.h
//  FlowerFire
//
//  Created by 王涛 on 2020/8/29.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "WTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FFBuyRecordCommissionModel : WTBaseModel

@property(nonatomic, copy)NSString *addtime;
@property(nonatomic, copy)NSString *amount;
@property(nonatomic, copy)NSString *deal_amount;
@property(nonatomic, copy)NSString *deal_price;
@property(nonatomic, copy)NSString *fee;
@property(nonatomic, copy)NSString *fee_amount;
@property(nonatomic, copy)NSString *finishtime;
@property(nonatomic, copy)NSString *from_coin;
@property(nonatomic, copy)NSString *from_symbol;
@property(nonatomic, copy)NSString *market_id;
@property(nonatomic, copy)NSString *order_sn;
@property(nonatomic, copy)NSString *order_status;
@property(nonatomic, copy)NSString *order_status_name;
@property(nonatomic, copy)NSString *order_type;
@property(nonatomic, copy)NSString *order_type_name;
@property(nonatomic, copy)NSString *price;
@property(nonatomic, copy)NSString *price_type;
@property(nonatomic, copy)NSString *price_type_name;
@property(nonatomic, copy)NSString *surplus;
@property(nonatomic, copy)NSString *to_coin;
@property(nonatomic, copy)NSString *to_symbol;
@property(nonatomic, copy)NSString *total_amount;
@property(nonatomic, copy)NSString *trade_amount;
@property(nonatomic, copy)NSString *user_id;
  
@end

NS_ASSUME_NONNULL_END
