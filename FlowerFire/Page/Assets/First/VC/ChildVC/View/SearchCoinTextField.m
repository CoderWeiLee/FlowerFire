//
//  SearchCoinTextField.m
//  FireCoin
//
//  Created by 王涛 on 2020/4/8.
//  Copyright © 2020 王涛. All rights reserved.
//

#import "SearchCoinTextField.h"

@implementation SearchCoinTextField

- (instancetype)initWithFrame:(CGRect)frame delegate:(id)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        self.searchTextFieldDelegate = delegate;
        self.theme_textColor = THEME_TEXT_COLOR;
        self.keyboardType = UIKeyboardTypeNamePhonePad;
        self.layer.borderWidth = 1;
        self.layer.theme_borderColor = THEME_LINE_TABLEVIEW_SEPARATOR_COLOR;
        self.theme_attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSStringFormat(@"%@",LocalizationKey(@"Search")) attributes:@{ SDThemeForegroundColorAttributeName:THEME_TEXT_PLACEHOLDERCOLOR,NSFontAttributeName:[UIFont systemFontOfSize:13]
        }];
        [self addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
         
        UIView *leftView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        UIButton *leftView = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftView setImage:[UIImage imageNamed:@"search_symbol_search"] forState:UIControlStateNormal];
        leftView.frame = CGRectMake(10, 7.5, 15, 15);
        [leftView1 addSubview:leftView];
        self.leftView = leftView1;
        self.leftViewMode = UITextFieldViewModeAlways;
          
        UIView *rightView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 25, 20)];
        UIButton *rightView = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightView addTarget:self action:@selector(cleanFieldClick) forControlEvents:UIControlEventTouchUpInside];
        [rightView theme_setImage:@"total_balance_clear_normal" forState:UIControlStateNormal];
        rightView.frame = CGRectMake(0, 0, 20, 20);
        [rightView1 addSubview:rightView];
        self.rightView = rightView1;
        self.rightViewMode = UITextFieldViewModeWhileEditing;
    }
    return self;
}

/// 监听输入框
-(void)changedTextField:(UITextField *)textField{
    if([self.searchTextFieldDelegate respondsToSelector:@selector(changedTextField:)]){
        [self.searchTextFieldDelegate changedTextField:textField];
    }
}

/// 清空输入框
-(void)cleanFieldClick{
    if([self.searchTextFieldDelegate respondsToSelector:@selector(cleanFieldClick)]){
        [self.searchTextFieldDelegate cleanFieldClick];
    }
}

@end
