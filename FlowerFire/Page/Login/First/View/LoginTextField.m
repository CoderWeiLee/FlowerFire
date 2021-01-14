//
//  LoginTextField.m
//  FlowerFire
//
//  Created by 王涛 on 2020/4/30.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "LoginTextField.h"

@interface LoginTextField ()
{
    NSString *_titleStr;
    NSString *_placeholderStr;
   
}

@end

@implementation LoginTextField

- (instancetype)initWithFrame:(CGRect)frame titleStr:(nonnull NSString *)str placeholderStr:(nonnull NSString *)placeholderStr
{
    self = [super initWithFrame:frame];
    if (self) {
        _titleStr = LocalizationKey(str);
        _placeholderStr = LocalizationKey(placeholderStr);
        [self createUI];
        [self layoutSubview];
    }
    return self;
}

- (void)createUI{
    _title = [UILabel new];
    _title.font = tFont(16);
    _title.theme_textColor = THEME_TEXT_COLOR;
    _title.text = _titleStr;
    [self addSubview:_title];
    
    _loginInputView = [UITextField new];
    _loginInputView.placeholder = _placeholderStr;
    _loginInputView.theme_attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSStringFormat(@"%@",_placeholderStr) attributes:@{ SDThemeForegroundColorAttributeName:THEME_TEXT_PLACEHOLDERCOLOR}];
    _loginInputView.font = tFont(15);
    _loginInputView.theme_textColor = THEME_TEXT_COLOR;
    [self addSubview:_loginInputView];
    
    _rightView = [UIView new];
    _loginInputView.rightView = _rightView;
    _loginInputView.rightViewMode = UITextFieldViewModeAlways;

    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_rightView addSubview:_rightButton];
    
    _line = [UIView new];
    _line.theme_backgroundColor = THEME_LINE_TABLEVIEW_SEPARATOR_COLOR;
    [_loginInputView addSubview:_line];
}

- (void)layoutSubview{
    _title.frame = CGRectMake(0, 20, ScreenWidth - 80, 20);
    
    _loginInputView.frame = CGRectMake(0, _title.ly_maxY + 10, ScreenWidth - 80, 40);
    
    _rightView.frame = CGRectMake(0, 0, 30, 30);
    _rightButton.frame = _rightView.bounds;
    _line.frame = CGRectMake(0, _loginInputView.height-1, _loginInputView.ly_width, 1);
    self.height = _loginInputView.ly_maxY;
}

@end
