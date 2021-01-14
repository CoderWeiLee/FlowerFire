//
//  AddAccountsReceivableSendVerificationCodeModalVC.h
//  FireCoin
//
//  Created by 王涛 on 2019/7/13.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "SendVerificationCodeModalVC.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, SendVerificationCodeType) {
    SendVerificationCodeTypeAddAcounts, //添加收款账户进的
    SendVerificationCodeTypeDeleteAcounts, //删除收款账户进的
    
};

@interface AddAccountsReceivableSendVerificationCodeModalVC : SendVerificationCodeModalVC

@property(nonatomic, strong)NSMutableDictionary *netDic;

/**
 SendVerificationCodeTypeAddAcounts, //添加收款账户进的
 SendVerificationCodeTypeDeleteAcounts, //删除收款账户进的
 */
@property(nonatomic, assign)SendVerificationCodeType sendVerificationCodeType;
@end

NS_ASSUME_NONNULL_END
