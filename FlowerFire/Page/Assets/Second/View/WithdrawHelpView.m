//
//  WithdrawHelpView.m
//  FireCoin
//
//  Created by 王涛 on 2019/8/1.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "WithdrawHelpView.h"

@implementation WithdrawHelpView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.title = [UILabel new];
        self.title.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        self.layer.masksToBounds = YES;
        self.title.theme_textColor = THEME_TEXT_COLOR;
        self.title.font = tFont(14);
        [self addSubview:self.title];
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).offset(OverAllLeft_OR_RightSpace);
            make.left.mas_equalTo(self.mas_left).offset(OverAllLeft_OR_RightSpace);
        }];
        
        self.inputTextField = [UITextField new];
        self.inputTextField.theme_textColor = THEME_TEXT_COLOR;
        self.inputTextField.text = @"";
        self.inputTextField.font = tFont(16);
        [self addSubview:self.inputTextField];
         
        self.inputTextField.theme_attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],SDThemeForegroundColorAttributeName:THEME_TEXT_PLACEHOLDERCOLOR}];
        
      //  [self.inputTextField setValue:THEME_TEXT_PLACEHOLDERCOLOR forKeyPath:@"_placeholderLabel.theme_textColor"];
        [self.inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.title.mas_bottom).offset(10);
            make.left.mas_equalTo(self.title.mas_left);
            make.right.mas_equalTo(self.mas_right);
            make.size.mas_equalTo(CGSizeMake(ScreenWidth - OverAllLeft_OR_RightSpace, 45));
        }];
        
        CGFloat rightViewWidth = 130;
        
        UIView *rightView = [UIView new];//[[UIView alloc] initWithFrame:CGRectMake((ScreenWidth - OverAllLeft_OR_RightSpace * 2) - rightViewWidth, 0, rightViewWidth, 45)];
        rightView.backgroundColor = self.backgroundColor;
        self.inputTextField.rightView = rightView;
        self.inputTextField.rightViewMode = UITextFieldViewModeAlways;
        [self.inputTextField addSubview:rightView];
        [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.inputTextField.mas_right);
            make.centerY.mas_equalTo(self.inputTextField.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(rightViewWidth, 45));
        }];
        
        self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.leftBtn.titleLabel.font = tFont(16);
        self.leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.leftBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.leftBtn setTitleColor:ContractDarkBlueColor forState:UIControlStateNormal];
        [rightView addSubview:self.leftBtn];
        [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(rightView.mas_left).offset(OverAllLeft_OR_RightSpace);
            make.centerY.mas_equalTo(rightView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake((rightViewWidth - OverAllLeft_OR_RightSpace * 2)/2, 30));
        }];
        
        self.line = [UIView new];
        self.line.theme_backgroundColor = THEME_LINE_INPUTBORDERCOLOR;
        [rightView addSubview:self.line];
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(rightView.mas_centerX);
            make.centerY.mas_equalTo(rightView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(1, 25));
        }];
        
        self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rightBtn.titleLabel.font = tFont(16);
        self.rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        self.rightBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.rightBtn theme_setTitleColor:THEME_TEXT_COLOR forState:UIControlStateNormal];
        [rightView addSubview:self.rightBtn];
        [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(rightView.mas_right).offset(-OverAllLeft_OR_RightSpace);
            make.centerY.mas_equalTo(rightView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake((rightViewWidth - OverAllLeft_OR_RightSpace * 2)/2, 30));
        }];
          
        UIView *line1 = [UIView new];
        line1.theme_backgroundColor = THEME_LINE_INPUTBORDERCOLOR;
        [self.inputTextField addSubview:line1];
        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.inputTextField.mas_left);
            make.bottom.mas_equalTo(self.inputTextField.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(ScreenWidth - OverAllLeft_OR_RightSpace, 1));
        }];
        
        self.bottomLabel = [UILabel new];
        self.bottomLabel.textColor = ContractDarkBlueColor;
        self.bottomLabel.font = tFont(14);
        self.bottomLabel.text = @"";
        self.bottomLabel.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        self.layer.masksToBounds = YES;
        [self addSubview:self.bottomLabel];
        [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.inputTextField.mas_bottom).offset(5);
            make.left.mas_equalTo(self.inputTextField.mas_left);
        }];
    }
    return self;
}

@end
