//
//  RegisteredTableViewCell.m
//  FlowerFire
//
//  Created by 王涛 on 2020/5/14.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "RegisteredTableViewCell.h"

@interface RegisteredTableViewCell ()
{
    
}
@end

@implementation RegisteredTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self createUI];
        [self layoutSubview];
    }
    return self;
}

- (void)createUI{
    _textField = [[RegisteredTextField alloc] initWithFrame:CGRectMake(LoginModuleLeftSpace, 0, ScreenWidth - 2 * LoginModuleLeftSpace, 50) titleStr:@"1" placeholderStr:@"1"];
    _textField.rightButton.titleLabel.font = tFont(15);
    [self addSubview:_textField];
}

- (void)layoutSubview{
    
}

- (void)setCellData:(NSDictionary *)dic{
    _textField.loginInputView.placeholder = LocalizationKey(dic[@"details"]);
    _textField.loginInputView.text = dic[@"title"];
    
   if([[dic allKeys] containsObject:@"rightBtnTitle"]){
        [_textField.rightButton setTitle:LocalizationKey(dic[@"rightBtnTitle"]) forState:UIControlStateNormal];
        _textField.rightView.width = 130;
        [_textField.rightButton theme_setTitleColor:THEME_TEXT_COLOR forState:UIControlStateNormal]; 
        _textField.rightButton.width = 130;
    }
    
}

@end
