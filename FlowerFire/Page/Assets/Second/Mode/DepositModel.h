//
//  DepositModel.h
//  FireCoin
//
//  Created by 王涛 on 2019/8/1.
//  Copyright © 2019 王涛. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 充币地址等
 */
@interface DepositModel : NSObject

/**
 货币标识
 */
@property(nonatomic, copy)NSString *symbol;

/**
 地址
 */
@property(nonatomic, copy)NSString *address;

/**
 标签
 */
@property(nonatomic, copy)NSString *tag;

/**
 充值最小金额
 */
@property(nonatomic, copy)NSString *reharge_min;

/**
 网络确认数
 */
@property(nonatomic, copy)NSString *reharge_confirm;

/**
 币id
 */
@property(nonatomic, copy)NSString  *coin_id;
@end

NS_ASSUME_NONNULL_END
