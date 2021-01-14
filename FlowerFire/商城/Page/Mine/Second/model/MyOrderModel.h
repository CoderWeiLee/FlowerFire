//
//  MyOrderModel.h
//  531Mall
//
//  Created by 王涛 on 2020/6/4.
//  Copyright © 2020 Celery. All rights reserved.
//。我的订单

#import "WTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyOrderGoodInfoModel : WTBaseModel
 
@property(nonatomic, copy)NSString *good_amount;
@property(nonatomic, copy)NSString *good_img;
@property(nonatomic, copy)NSString *good_name;
@property(nonatomic, copy)NSString *price;
@property(nonatomic, copy)NSString *three_price;

@end
 
    

@interface MyOrderModel : WTBaseModel

/// 实际支付总金额
@property(nonatomic, copy)NSString *actual_total_money;
@property(nonatomic, copy)NSString *back_time;
@property(nonatomic, copy)NSString *close_time;
@property(nonatomic, copy)NSString *created_time;
@property(nonatomic, copy)NSString *deliver_money;
@property(nonatomic, copy)NSString *deliver_type;
/// 发货时间
@property(nonatomic, copy)NSString *delivery_time;
/// 商品总额
@property(nonatomic, copy)NSString *goods_money;
/// 订单id
@property(nonatomic, copy)NSString *orderID;
@property(nonatomic, copy)NSString *is_pay;
/// 订单编号
@property(nonatomic, copy)NSString *order_no;
@property(nonatomic, copy)NSString *order_type;
@property(nonatomic, copy)NSString *order_unique;
/// 支付时间
@property(nonatomic, copy)NSString *pay_time;
@property(nonatomic, copy)NSString *pay_type;
/// 详细地址
@property(nonatomic, copy)NSString *receipt_address;
@property(nonatomic, copy)NSString *receipt_area_ids;
@property(nonatomic, copy)NSString *receipt_mobile;
@property(nonatomic, copy)NSString *receipt_time;
@property(nonatomic, copy)NSString *receipt_username;
@property(nonatomic, copy)NSString *remark;
@property(nonatomic, copy)NSString *state;
@property(nonatomic, copy)NSString *state_info;
@property(nonatomic, copy)NSString *updated_time;
@property(nonatomic, copy)NSString *user_id;
@property(nonatomic, strong)NSArray<MyOrderGoodInfoModel *> *good_info;

@end

NS_ASSUME_NONNULL_END
