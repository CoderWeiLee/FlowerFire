//
//  FFRegisteredParamsModel.h
//  FlowerFire
//
//  Created by 王涛 on 2020/8/27.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "WTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FFRegisteredParamsModel : WTBaseModel

/// 用户名
@property(nonatomic, copy)NSString *username;
/// 密码
@property(nonatomic, copy)NSString *password;
/// 助记词(加密后
@property(nonatomic, copy)NSString *mnemonic; 
  
@end

NS_ASSUME_NONNULL_END
