//
//  SettingUpdateSubmitButton.m
//  FlowerFire
//
//  Created by 王涛 on 2020/5/5.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "SettingUpdateSubmitButton.h"

@interface SettingUpdateSubmitButton ()
{
    UIView *_bac;
    
}
@end

@implementation SettingUpdateSubmitButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    _bac = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 100)];
    _bac.theme_backgroundColor = THEME_MAIN_BACKGROUNDCOLOR;
    [self addSubview:_bac];
    
    self.submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.submitButton setTitle:LocalizationKey(@"changeLoginPwdTip9") forState:UIControlStateNormal];
    [self.submitButton setBackgroundImage:[UIImage imageWithColor:ButtonDisabledColor] forState:UIControlStateDisabled];
    [self.submitButton setBackgroundImage:[UIImage imageWithColor:MainColor] forState:UIControlStateNormal];
    [self.submitButton theme_setTitleColor:THEME_TEXT_COLOR forState:UIControlStateDisabled];
    [self.submitButton setTitleColor:KWhiteColor forState:UIControlStateNormal];
    self.submitButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    self.submitButton.layer.cornerRadius = 25;
    self.submitButton.clipsToBounds = YES;
    self.submitButton.enabled = NO;
    [_bac addSubview:self.submitButton];
    
    self.submitButton.frame = CGRectMake(40, 50, ScreenWidth - 80, 50);
}

@end
