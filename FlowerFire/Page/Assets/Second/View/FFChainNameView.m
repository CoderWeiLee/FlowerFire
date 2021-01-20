//
//  FFChainNameView.m
//  FlowerFire
//
//  Created by 王涛 on 2020/9/15.
//  Copyright © 2020 Celery. All rights reserved.
//  链名称

#import "FFChainNameView.h"

@interface FFChainNameView ()
{
    WTLabel  *_topTip;
    WTButton *_chainName;
}
@end

@implementation FFChainNameView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
        [self layoutSubview];
    }
    return self;
}

- (void)createUI{
    _topTip = [[WTLabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20) Text:LocalizationKey(@"578Tip172") Font:tFont(14) textColor:KBlackColor parentView:self];
    
    _chainName = [[WTButton alloc] initWithFrame:CGRectMake(_topTip.left, _topTip.bottom + 5, 80, 30) titleStr:@"TRC20" titleFont:tFont(14) titleColor:MainBlueColor parentView:self];
    _chainName.layer.cornerRadius = 3;
    _chainName.layer.borderWidth = 1;
    _chainName.layer.borderColor = MainBlueColor.CGColor;
    
    
}

- (void)layoutSubview{
    
}

@end
