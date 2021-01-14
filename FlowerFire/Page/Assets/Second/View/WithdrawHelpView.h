//
//  WithdrawHelpView.h
//  FireCoin
//
//  Created by 王涛 on 2019/8/1.
//  Copyright © 2019 王涛. All rights reserved.
//  提币辅助页面

#import "BaseUIView.h"

NS_ASSUME_NONNULL_BEGIN

@interface WithdrawHelpView : BaseUIView

@property(nonatomic, strong) UILabel *title;
@property(nonatomic, strong) UITextField *inputTextField;
@property(nonatomic, strong) UIButton *leftBtn,*rightBtn;
@property(nonatomic, strong) UILabel  *bottomLabel;
@property(nonatomic, strong) UIView  *line;
@end 

NS_ASSUME_NONNULL_END
