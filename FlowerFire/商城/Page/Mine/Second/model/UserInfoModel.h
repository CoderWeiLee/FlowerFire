//
//  UserInfoModel.h
//  531Mall
//
//  Created by 王涛 on 2020/6/6.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "WTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserInfoModel : WTBaseModel

/// 显示名称
@property(nonatomic, copy)NSString *lable;
/// 值
@property(nonatomic, copy)NSString *value;
/// 数据库存储名称
@property(nonatomic, copy)NSString *variable;
@end

NS_ASSUME_NONNULL_END
