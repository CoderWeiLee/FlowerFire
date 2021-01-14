//
//  RegisteredSetPwdViewController.h
//  FlowerFire
//
//  Created by 王涛 on 2020/5/14.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RegisteredSetPwdViewController : BaseTableViewController

/// 验证码
@property(nonatomic, strong)NSString *captchaStr;
@property(nonatomic, strong)NSString *userNameStr;
@property(nonatomic, strong)NSString *emailStr;


@end

NS_ASSUME_NONNULL_END
