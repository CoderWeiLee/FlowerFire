//
//  TotalDelegateModel.h
//  531Mall
//
//  Created by 王涛 on 2020/6/6.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "WTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TotalDelegateModel : WTBaseModel

/// 当月工资
@property(nonatomic, copy)NSString *val;
/// 时间
@property(nonatomic, copy)NSString *calc_date;
/// 当月业绩
@property(nonatomic, copy)NSString *introducepv;


@end

NS_ASSUME_NONNULL_END
