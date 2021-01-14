//
//  InputPwdPopView.h
//  531Mall
//
//  Created by 王涛 on 2020/6/8.
//  Copyright © 2020 Celery. All rights reserved.
//。 输入密码弹窗

#import "BaseUIView.h"
#import <CRBoxInputView.h>

NS_ASSUME_NONNULL_BEGIN

@interface InputPwdPopView : BaseUIView

@property(nonatomic, strong)CRBoxInputView *pwdInputView;

@property(nonatomic, copy)dispatch_block_t closePopViewBlock;

@end

NS_ASSUME_NONNULL_END
