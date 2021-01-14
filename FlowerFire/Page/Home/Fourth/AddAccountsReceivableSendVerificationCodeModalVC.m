//
//  AddAccountsReceivableSendVerificationCodeModalVC.m
//  FireCoin
//
//  Created by 王涛 on 2019/7/13.
//  Copyright © 2019 王涛. All rights reserved.
//  添加收款账户的发送验证码控制器

#import "AddAccountsReceivableSendVerificationCodeModalVC.h"

@interface AddAccountsReceivableSendVerificationCodeModalVC ()

@end

@implementation AddAccountsReceivableSendVerificationCodeModalVC

- (void)viewDidLoad {
    [super viewDidLoad];
     
}

#pragma Override Parent Class
-(void)submitClick{
    if([HelpManager isBlankString:[WTUserInfo shareUserInfo].email]){
        printAlert(LocalizationKey(@"BindingPhoneTip2"), 1.f);
        return;
    }
  
    switch (self.sendVerificationCodeType) {
        case SendVerificationCodeTypeAddAcounts:
        {
            self.netDic[@"smscode"] = self.textField.text;
            if(self.netDic.count == 6){
                [self.afnetWork jsonPostDict:@"/api/account/addPay" JsonDict:self.netDic Tag:@"1"];
            }
        }
            break;
        case SendVerificationCodeTypeDeleteAcounts:
        {
            self.netDic[@"smscode"] = self.textField.text;
            if(self.netDic.count == 2){
                [self.afnetWork jsonPostDict:@"/api/account/delPay" JsonDict:self.netDic Tag:@"1"];
            }
        }
            break;
        default:
            break;
    }
}

@end
