//
//  SendVerificationCodeModalVC.h
//  FireCoin
//
//  Created by 王涛 on 2019/7/5.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^dissmissVCBlock)(void);
typedef void(^getGoogleCodeBlock)(NSString *code);


typedef enum : NSUInteger {
    SendVerificationCodeWhereJumpResetPwd = 0, //从充值密码页面跳转过来的
    SendVerificationCodeWhereJumpWithdraw, //从提币页面跳转过来的
    SendVerificationCodeWhereJumpWithdrawSD, //从提币SD页面跳转过来的
    SendVerificationCodeWhereJumpAddWithdrawAddress, //从添加提币地址页面跳转过来的
    SendVerificationCodeWhereJumpAddPayAccount, //从添加收款账户
    SendVerificationCodeWhereJumpDeletePayAccount, //从删除收款账户
    SendVerificationCodeWhereJumpBindGoogleCode, //从绑定谷歌验证码进来
    SendVerificationCodeWhereJumpSwitchGoogleCode, //从开关谷歌验证码进来
    SendVerificationCodeWhereJumpLogin, //从绑定谷歌验证后登录页面过来
} SendVerificationCodeWhereJump;

@interface SendVerificationCodeModalVC : BaseViewController

@property(nonatomic, copy)backRefreshBlock backRefreshBlock;
@property(nonatomic, copy)dissmissVCBlock  dissmissVCBlock;
@property(nonatomic, copy)getGoogleCodeBlock  getGoogleCodeBlock;

/**
 新密码串
 */
@property(nonatomic, strong)NSString *freshPwdStr;
/**
 输入框文本
 */
@property(nonatomic, strong)UITextField *textField;

@property(nonatomic, assign)SendVerificationCodeWhereJump sendVerificationCodeWhereJump;

/**
 提币用的网络参数
 */
@property(nonatomic, strong)NSMutableDictionary *withdrawNetDic;

/**
 添加提币地址用的网络参数
 */
@property(nonatomic, strong)NSMutableDictionary *addWithdrawAddressNetDic;


/// 网络请求的字典
@property(nonatomic, strong)NSMutableDictionary *sendCodeNetDic;



@end

NS_ASSUME_NONNULL_END
