//
//  SettingUpdateFormCell.m
//  FlowerFire
//
//  Created by 王涛 on 2020/5/5.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "SettingUpdateFormCell.h"
#import "LoginTextField.h"

@interface SettingUpdateFormCell ()
{
    LoginTextField *_loginTextField;
}
@end

@implementation SettingUpdateFormCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self createUI];
        [self layoutSubview];
    }
    return self;
}

- (void)createUI{
    _loginTextField= [[LoginTextField alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, 0, ScreenWidth - 2*OverAllLeft_OR_RightSpace, 50) titleStr:@"changeLoginPwdTip3" placeholderStr:@"changeLoginPwdTip4"];
    _loginTextField.title.font = [UIFont boldSystemFontOfSize:15];
    _loginTextField.rightButton.titleLabel.font = tFont(15);
    self.loginInputView =  _loginTextField.loginInputView;
    self.title = _loginTextField.title;
    self.rightButton = _loginTextField.rightButton;
    [self addSubview:_loginTextField];
}

- (void)layoutSubview{
    self.title.width = ScreenWidth - 2 * OverAllLeft_OR_RightSpace;
    self.loginInputView.width = self.title.width;
}

- (void)setCellData:(NSDictionary *)dic{
    self.title.text = LocalizationKey(dic[@"title"]);
    self.loginInputView.placeholder = LocalizationKey(dic[@"details"]);
    
    if([[dic allKeys] containsObject:@"rightBtnImage"]){
        [self.rightButton setImage:[UIImage imageNamed:@"icon-test-2"] forState:UIControlStateNormal]; //闭眼
        [self.rightButton setImage:[UIImage imageNamed:@"icon-test"] forState:UIControlStateSelected]; //睁眼
        _loginTextField.rightView.width = 30;
        _loginTextField.rightButton.width = 30; 
        
    }else if([[dic allKeys] containsObject:@"rightBtnTitle"]){
        [self.rightButton setTitle:LocalizationKey(dic[@"rightBtnTitle"]) forState:UIControlStateNormal];
        _loginTextField.rightView.width = 130;
        [_loginTextField.rightButton setTitleColor:MainBlueColor forState:UIControlStateNormal];
        self.rightButton.backgroundColor = [UIColor whiteColor];
        _loginTextField.rightButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        _loginTextField.rightButton.width = 130;
    }else if([[dic allKeys] containsObject:@"customNormalImage"]){
        [self.rightButton setImage:[UIImage imageNamed:dic[@"customNormalImage"]] forState:UIControlStateNormal]; //闭眼 //睁眼
        _loginTextField.rightButton.width = 50;
        _loginTextField.rightView.width = 50;
        
    }else{
        _loginTextField.rightView.width = 30;
        _loginTextField.rightButton.width = 30;
     //   [_loginTextField.rightButton sizeToFit];
    }
    if([[dic allKeys] containsObject:@"isSafeInput"]){
        self.loginInputView.secureTextEntry = YES;
    }else{
        self.loginInputView.secureTextEntry = NO;
    }
     
    switch ([dic[@"keyBoardType"] integerValue]) {
        case 1:
            self.loginInputView.keyboardType = UIKeyboardTypeEmailAddress;
            break;
        case 2:
            self.loginInputView.keyboardType = UIKeyboardTypeNumberPad;
            break;
        default:
            self.loginInputView.keyboardType = UIKeyboardTypeDefault;
            break;
    }
    
}

@end
