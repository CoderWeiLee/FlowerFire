//
//  FFBuyRecordHidtoryRecordModel.h
//  FlowerFire
//
//  Created by 王涛 on 2020/8/29.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "WTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FFBuyRecordHidtoryRecordModel : WTBaseModel

/// 变动后的金额
@property(nonatomic, copy)NSString *after;
/// 变动前的金额
@property(nonatomic, copy)NSString *before;
/// 创建时间
@property(nonatomic, copy)NSString *createtime;
///  变动金额
@property(nonatomic, copy)NSString *money;
/// 货币
@property(nonatomic, copy)NSString *symbol;
/// 类型:120=持有收益,121=推广收益,122=认购,123=认购赠送,124=前台认购,125=销毁,6=转账转出,5=转账转入,0=后台调整,1=充值,2=提现,3=提现退还,20=激活用户
@property(nonatomic, copy)NSString *type; 
@property(nonatomic, copy)NSString *memo;
 
   
 
@end

NS_ASSUME_NONNULL_END
