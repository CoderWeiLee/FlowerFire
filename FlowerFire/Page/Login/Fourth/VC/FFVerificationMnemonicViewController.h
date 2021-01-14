//
//  FFVerificationMnemonicViewController.h
//  FlowerFire
//
//  Created by 王涛 on 2020/8/25.
//  Copyright © 2020 Celery. All rights reserved.
//

//1.注册的第一页，将用户名传到获取助记词接口，接口返回加密后的助记词。（需要接口）
//2.注册的第二页，将加密后的助记词解密后显示（解密后应该是以空格相隔的字符串）。（不需要接口）
//3.将加密后的助记词打乱顺序，显示并让用户点击顺序，将用户填写或点击的助记词加密后传到验证助记词接口进行验证。（需要接口）
//4.将用户名、密码、助记词(加密后)、邮箱、邮箱验证码，传到注册会员，成功即注册成功。（需要接口）

#import "BaseViewController.h"
#import "FFRegisteredParamsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FFVerificationMnemonicViewController : BaseViewController

@property(nonatomic, strong)FFRegisteredParamsModel *registeredParamsModel;


@end

NS_ASSUME_NONNULL_END
