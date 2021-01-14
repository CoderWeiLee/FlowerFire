//
//  WithdrawCoinCell.m
//  FireCoin
//
//  Created by 王涛 on 2019/6/22.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "WithdrawCoinCell.h"

@interface WithdrawCoinCell ()
{
    UILabel *titleLabel;
    UILabel *bottomLabel;

}
@end

@implementation WithdrawCoinCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        
        titleLabel = [UILabel new];
        titleLabel.text = @"币种";
        titleLabel.theme_textColor = THEME_GRAY_TEXTCOLOR;
        titleLabel.font = tFont(15);
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).offset(0);
            make.left.mas_equalTo(self.mas_left).offset(OverAllLeft_OR_RightSpace);
        }];
        
        _textField = [UITextField new];
        _textField.theme_backgroundColor = THEME_INPUT_BACKGROUNDCOLOR;
        _textField.theme_textColor = THEME_TEXT_COLOR;
        _textField.font = tFont(16);
        _textField.placeholder = @"请输入";
        _textField.theme_attributedPlaceholder = [[NSAttributedString alloc] initWithString:LocalizationKey(@"WithdrawTip10") attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],SDThemeForegroundColorAttributeName:THEME_TEXT_PLACEHOLDERCOLOR}];
        
      // [_textField setValue:THEME_TEXT_PLACEHOLDERCOLOR forKeyPath:@"_placeholderLabel.theme_textColor"];
        [self addSubview:_textField];
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(titleLabel.mas_left);
            make.top.mas_equalTo(titleLabel.mas_bottom).offset(10);
            make.size.mas_equalTo(CGSizeMake(ScreenWidth - OverAllLeft_OR_RightSpace *2, 50));
        }];
        [_textField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingDidEnd];
        
        UIView *placeholderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 50)];
        _textField.leftView = placeholderView;
        _textField.leftViewMode = UITextFieldViewModeAlways;
        
        bottomLabel = [UILabel new];
        bottomLabel.text = @"贴士";
        bottomLabel.theme_textColor = THEME_GRAY_TEXTCOLOR;
        bottomLabel.font = tFont(13);
        [self addSubview:bottomLabel];
        [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_textField.mas_bottom).offset(10);
            make.right.mas_equalTo(_textField.mas_right).offset(0);
            make.bottom.mas_equalTo(self.mas_bottom).offset(-15);
        }];
    }
    return self;
}

-(void)setCellData:(NSDictionary *)dic{
    titleLabel.text = dic[@"title"];
    _textField.placeholder = dic[@"placeHolder"];
    bottomLabel.text = dic[@"bottom"];
    if([dic[@"isNumber"] isEqualToString:@"1"]){
        _textField.keyboardType = UIKeyboardTypeNumberPad;
    }else{
        _textField.keyboardType = UIKeyboardTypeDefault;
    }
}

-(void)textChange:(UITextField *)textField{
    [self.textStr setValue:textField.text forKey:self.key];
}
- (void)setTextStr:(id)textStr{
    _textStr = textStr;
    _textField.text = [self.textStr valueForKey:self.key];
}

@end
