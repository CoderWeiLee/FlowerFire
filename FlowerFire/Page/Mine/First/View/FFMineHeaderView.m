//
//  FFMineHeaderView.m
//  FlowerFire
//
//  Created by 王涛 on 2020/8/22.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "FFMineHeaderView.h"

@interface FFMineHeaderView ()
{
    UIImageView *_bacImageView;
    UIImageView *_userPhoto;
    WTLabel     *_nickName;
    
}
@end

@implementation FFMineHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
        [self layoutSubview];
        [self setHeaderData];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setHeaderData) name:SWITCH_ACCOUNT_SUCCESS_NOTIFICATION object:nil];
    }
    return self;
}

- (void)createUI{
    _bacImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img32"]];
    [self addSubview:_bacImageView];
    
    _userPhoto = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"头像"]];
    [self addSubview:_userPhoto];
    
    _nickName = [[WTLabel alloc] initWithFrame:CGRectZero Text:@"--" Font:tFont(15) textColor:KWhiteColor parentView:self];
    [self addSubview:_nickName];
    
    _code = [[WTLabel alloc] initWithFrame:CGRectZero Text:@"--" Font:tFont(10) textColor:KWhiteColor parentView:self];
    
    _duplicateCodeButton = [[WTButton alloc] initWithFrame:CGRectZero buttonImage:[UIImage imageNamed:@"复制"] parentView:self];
    
}

-(void)setHeaderData{
    [_userPhoto sd_setImageWithURL:[NSURL URLWithString:[WTUserInfo shareUserInfo].avatar] placeholderImage:[UIImage imageNamed:@"头像"]];
    _nickName.text = [WTUserInfo shareUserInfo].username;
    NSLog(@"[WTUserInfo shareUserInfo].address:%@",[WTUserInfo shareUserInfo].address);
    _code.text = [WTUserInfo shareUserInfo].address;
     
    
}

- (void)layoutSubview{
    _bacImageView.frame = CGRectMake(0, 0, ScreenWidth, self.height);
    _userPhoto.frame = CGRectMake(OverAllLeft_OR_RightSpace, Height_NavBar + 20, 50, 50);
    _userPhoto.layer.cornerRadius = _userPhoto.width/2;
    _userPhoto.layer.masksToBounds = YES;
    
    [_nickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_userPhoto.mas_right).offset(10);
        make.bottom.mas_equalTo(_userPhoto.mas_centerY).offset(-5);
        make.right.mas_equalTo(self.mas_right).offset(-OverAllLeft_OR_RightSpace);
    }];
    
    [_code mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_userPhoto.mas_right).offset(10);
        make.top.mas_equalTo(_userPhoto.mas_centerY).offset(5);
    }];
    
    [_duplicateCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_code.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.left.mas_equalTo(_code.mas_right).offset(5);
    }];
}

@end
