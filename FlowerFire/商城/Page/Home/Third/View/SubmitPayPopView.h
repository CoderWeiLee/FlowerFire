//
//  SubmitPayPopView.h
//  531Mall
//
//  Created by 王涛 on 2020/5/23.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "BaseUIView.h"
#import <CRBoxInputView.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SubmitPayPopViewDelegate <NSObject>

//-(void)InputPwd:(UIButton *)btn;

@end

@interface SubmitPayPopView : BaseUIView

@property(nonatomic, copy)dispatch_block_t closePopViewBlock;

@property(nonatomic, strong)UIButton        *choosePayMethodButton;
@property(nonatomic, strong)UILabel         *price; 
@property(nonatomic, strong)CRBoxInputView  *pwdInputView;
@property(nonatomic, weak)id<SubmitPayPopViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
