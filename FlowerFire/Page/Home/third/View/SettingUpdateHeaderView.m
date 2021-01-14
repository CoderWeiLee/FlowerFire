//
//  SettingUpdateHeaderView.m
//  FlowerFire
//
//  Created by 王涛 on 2020/5/5.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "SettingUpdateHeaderView.h"

@interface SettingUpdateHeaderView ()
{
    UILabel *_leftLabel;
    UILabel *_accountNameLabel;
    UILabel *_titleLabel;
    UIView  *_line;
    NSString * _titleStr;
}
@end

@implementation SettingUpdateHeaderView

- (instancetype)initWithFrame:(CGRect)frame changeTitle:(NSString *)title{
    self = [super initWithFrame:frame];
    if(self){
        _titleStr = title;
        [self createUI];
        [self layoutSubview];
    }
    return self;
}

- (void)createUI{
    _leftLabel = [self creatLabel:LocalizationKey(@"changeLoginPwdTip2")];
    _accountNameLabel = [self creatLabel:[WTUserInfo shareUserInfo].username];
    _accountNameLabel.textColor = MainColor;
    _titleLabel = [self creatLabel:_titleStr];
    
    _line = [UIView new];
    _line.theme_backgroundColor = THEME_LINE_TABLEVIEW_SEPARATOR_COLOR;
    [self addSubview:_line];
}

- (void)layoutSubview{
    [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(OverAllLeft_OR_RightSpace);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    [_accountNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_leftLabel.mas_right);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_accountNameLabel.mas_right);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom);
        make.left.mas_equalTo(_leftLabel.mas_left);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth - 2 * OverAllLeft_OR_RightSpace, 1));
    }];
}

-(UILabel *)creatLabel:(NSString *)text{
    UILabel *la = [UILabel new];
    la.text = text;
    la.font = tFont(11);
    la.theme_textColor = THEME_GRAY_TEXTCOLOR;
    [self addSubview:la];
    return la;
}

@end
