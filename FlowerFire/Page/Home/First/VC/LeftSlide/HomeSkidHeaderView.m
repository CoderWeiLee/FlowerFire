//
//  HomeSkidHederView.m
//  FlowerFire
//
//  Created by 王涛 on 2020/5/4.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "HomeSkidHeaderView.h"

@interface HomeSkidHeaderView ()
{
    UILabel *_titleLabel,*_detailsLabel;
}
@end

@implementation HomeSkidHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
        [self layoutSubview];
        
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpLogin)]];
    }
    return self;
}

- (void)createUI{
    self.backgroundColor = SkidBackgrouondColor;
    
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont boldSystemFontOfSize:25];
    _titleLabel.text = [WTUserInfo shareUserInfo].username ? [WTUserInfo shareUserInfo].username : LocalizationKey(@"homeSkidTip1");
    _titleLabel.textColor = KWhiteColor;
    [self addSubview:_titleLabel];
    
    _detailsLabel = [UILabel new];
    _detailsLabel.font = tFont(15);
    _detailsLabel.text = [WTUserInfo shareUserInfo].user_id ? [WTUserInfo shareUserInfo].user_id : LocalizationKey(@"homeSkidTip2");
    _detailsLabel.textColor = KWhiteColor;
    [self addSubview:_detailsLabel];
    
    
}

- (void)layoutSubview{
    _titleLabel.frame = CGRectMake(OverAllLeft_OR_RightSpace, SafeIS_IPHONE_X , self.bounds.size.width - 30, 25);
    _detailsLabel.frame = CGRectMake(OverAllLeft_OR_RightSpace, _titleLabel.ly_maxY+10, self.bounds.size.width - 30, 20);
    
    _titleLabel.adjustsFontSizeToFitWidth = YES;
    _detailsLabel.adjustsFontSizeToFitWidth = YES;
}

-(void)jumpLogin{
    if(![WTUserInfo isLogIn]){
        [[WTPageRouterManager sharedInstance] jumpLoginViewController:[self viewController] isModalMode:YES whatProject:1];
    }
}

-(void)exitLogin{
    [self removeAllSubviews];
    [self createUI];
    [self layoutSubview];
           
}

@end
