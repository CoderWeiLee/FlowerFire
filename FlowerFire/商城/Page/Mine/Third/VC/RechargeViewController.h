//
//  RechargeViewController.h
//  531Mall
//
//  Created by 王涛 on 2020/5/20.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, WalletChooseAccountType) {
    WalletChooseAccountTypeAliPay = 0,
    WalletChooseAccountTypeWeChat,

};

@interface RechargeViewController : BaseViewController

@property(nonatomic, strong)UITextField *numTextField;
@property(nonatomic, strong)NSString    *balanceNumStr;
@property(nonatomic, strong)NSString    *bankName;
@property(nonatomic, strong)UIButton    *submitButton;
@property(nonatomic, strong)UILabel     *titleLabel;
@property(nonatomic, strong)UIView      *whitBac;
@property(nonatomic, strong)UIButton    *chooseAccountButton;

@property(nonatomic, assign)WalletChooseAccountType  withrdawChooseAccountType;

-(void)WalletSubmitClick:(UIButton *)button;
-(void)chooseAccountClick:(UIButton *)button;
@end

NS_ASSUME_NONNULL_END
