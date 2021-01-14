//
//  ChooseCoinListModel.h
//  FireCoin
//
//  Created by 王涛 on 2019/8/1.
//  Copyright © 2019 王涛. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 能够提币和充币的币列表
 */
@interface ChooseCoinListModel : NSObject

/**
 是否开启充值 0=禁用，1-开启
 */
@property(nonatomic, assign) NSInteger is_recharge;

/**
 是否开启提币 0=禁用，1-开启
 */
@property(nonatomic, assign) NSInteger is_withdraw;

/**
 最小充值金额
 */
@property(nonatomic, assign) double reharge_min;

/**
 充值到账需要的网络确认数
 */
@property(nonatomic, assign) NSInteger reharge_confirm;

/**
 最小提现值金额
 */
@property(nonatomic, assign) double withdraw_min;

/**
 最大提现值金额
 */
@property(nonatomic, assign) double withdraw_max;

/**
 提现手续费比例%
 */
@property(nonatomic, assign) double withdraw_fee;

/**
 币名
 */
@property(nonatomic, copy) NSString *symbol;

/**
 币id
 */
@property(nonatomic, copy) NSString *coin_id;

@end

NS_ASSUME_NONNULL_END
