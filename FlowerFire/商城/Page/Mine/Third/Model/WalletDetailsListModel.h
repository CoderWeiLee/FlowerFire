//
//  WalletDetailsLIstModel.h
//  531Mall
//
//  Created by 王涛 on 2020/6/8.
//  Copyright © 2020 Celery. All rights reserved.
//  钱包明细列表

#import "WTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WalletDetailsListModel : WTBaseModel

/// 钱包名称
@property(nonatomic,copy)NSString *bankname;
/// 时间
@property(nonatomic,copy)NSString *time;
/// 会员编号
@property(nonatomic,copy)NSString *username;
/// 来源
@property(nonatomic,copy)NSString *source;
/// 类型
@property(nonatomic,copy)NSString *type;
/// 金额
@property(nonatomic,copy)NSString *money;
@end

NS_ASSUME_NONNULL_END
