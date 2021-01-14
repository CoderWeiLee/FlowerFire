//
//  ReleaseFiledBaseView.m
//  FireCoin
//
//  Created by 王涛 on 2019/5/31.
//  Copyright © 2019 王涛. All rights reserved.
//  发布委托单基础视图

#import "ReleaseFiledBaseView.h"

@implementation ReleaseFiledBaseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *xian = [UIView new];
        xian.theme_backgroundColor = THEME_LINE_INPUT_SEPARATORCOLOR;
        [self addSubview:xian];
        [xian mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left);
            make.top.mas_equalTo(self.mas_top);
            make.size.mas_equalTo(CGSizeMake(ScreenWidth, 2));
        }];
        
        [self setTheme_backgroundColor:THEME_CELL_BACKGROUNDCOLOR];
        //self.backgroundColor = navBarColor;
        self.titleLabel = [UILabel new];
        self.titleLabel.textColor = rgba(144, 157, 180, 1);
        self.titleLabel.font = tFont(18);
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(xian.mas_bottom).offset(15);
            make.left.mas_equalTo(self.mas_left).offset(OverAllLeft_OR_RightSpace);
        }];
        
        self.inputField = [UITextField new];
        self.inputField.theme_textColor = THEME_TEXT_COLOR;
        self.inputField.font = tFont(18);
        self.inputField.keyboardType = UIKeyboardTypeDecimalPad;
        self.inputField.theme_backgroundColor = THEME_INPUT_BACKGROUNDCOLOR;
        [self addSubview:self.inputField];
        [self.inputField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLabel.mas_left);
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(10);
            make.size.mas_equalTo(CGSizeMake(ScreenWidth - 30, 50));
        }];
        
        UIView *placeholderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
        self.inputField.leftView = placeholderView;
        self.inputField.leftViewMode = UITextFieldViewModeAlways;
    
        self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.rightBtn theme_setImage:@"under_arrow" forState:UIControlStateNormal];
        self.rightBtn.frame = CGRectMake(0, 0, 50, 50);
        self.inputField.rightView = self.rightBtn;
        self.inputField.rightViewMode = UITextFieldViewModeAlways;
        
       
    }
    return self;
}

@end
