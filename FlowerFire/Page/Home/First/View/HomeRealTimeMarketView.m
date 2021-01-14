//
//  HomeRealTimeMarketView.m
//  FlowerFire
//
//  Created by 王涛 on 2020/4/28.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "HomeRealTimeMarketView.h"

@interface HomeRealTimeMarketView ()
{
    UILabel *_realTimeTip,*_realTimeTip1;
    UILabel *_currentPrice,*_change;
    UIView  *_topLine1,*_topLine2;
}

@end

@implementation HomeRealTimeMarketView

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
    _realTimeTip = [UILabel new];
    _realTimeTip.text = LocalizationKey(@"homeTip3");
    _realTimeTip.textColor = MainColor;
    _realTimeTip.font = [UIFont boldSystemFontOfSize:15];
    [self addSubview:_realTimeTip];
    
    _realTimeTip1 = [UILabel new];
    _realTimeTip1.text = LocalizationKey(@"homeTip4");
    _realTimeTip1.textColor = [UIColor grayColor];
    _realTimeTip1.font = tFont(14);
    [self addSubview:_realTimeTip1];
    
    _currentPrice = [UILabel new];
    _currentPrice.text = NSStringFormat(@"%@ ¥0.0",LocalizationKey(@"mainCurrency"));
    _currentPrice.textColor = KBlackColor;
    _currentPrice.font = [UIFont boldSystemFontOfSize:15];
    [self addSubview:_currentPrice];
    
    _change = [UILabel new];
    _change.text = @"+0.00%";
    _change.textColor = MainColor;
    _change.font = [UIFont boldSystemFontOfSize:15];
    [self addSubview:_change];
    
    _topLine1 = [UIView new];
    _topLine1.theme_backgroundColor = THEME_LINE_TABLEVIEW_SEPARATOR_COLOR;
    [self addSubview:_topLine1];
    
    _topLine2 = [UIView new];
    _topLine2.theme_backgroundColor = THEME_LINE_TABLEVIEW_SEPARATOR_COLOR;
    [self addSubview:_topLine2];
    
}

- (void)layoutSubview{
    _topLine1.frame = CGRectMake(0, 0, ScreenWidth, 5);
    
    [_realTimeTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(OverAllLeft_OR_RightSpace);
    }];
    
    [_realTimeTip1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(_realTimeTip.mas_right);
    }];
    
    [_currentPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
    }];
    
    [_change mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-OverAllLeft_OR_RightSpace);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];

    _topLine2.frame = CGRectMake(0, self.height-5, ScreenWidth, 5);
}

@end
