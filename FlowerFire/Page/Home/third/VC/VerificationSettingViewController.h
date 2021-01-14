//
//  VerificationSettingViewController.h
//  FlowerFire
//
//  Created by 王涛 on 2020/5/13.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, VerificationSettingType) {
    VerificationSettingTypeTransaction = 0,//交易免密设置
    VerificationSettingTypePay ,//支付验证设置
    VerificationSettingTypeLogin , //登录验证设置
};

@interface VerificationSettingViewController : BaseTableViewController

@property(nonatomic, assign)VerificationSettingType verificationSettingType;
@end

NS_ASSUME_NONNULL_END
