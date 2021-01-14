//
//  ReleaseFiledBaseView.h
//  FireCoin
//
//  Created by 王涛 on 2019/5/31.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "BaseUIView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ReleaseFiledBaseView : BaseUIView

/**
 标题文字
 */
@property(nonatomic, strong) UILabel     *titleLabel;
/**
 输入框
 */
@property(nonatomic, strong) UITextField *inputField;

/**
 输入框右侧按钮
 */
@property(nonatomic, strong) UIButton    *rightBtn;
@end

NS_ASSUME_NONNULL_END
