//
//  MyTeamRecommendHeaderVIew.m
//  531Mall
//
//  Created by 王涛 on 2020/5/21.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "MyTeamRecommendHeaderView.h"

@interface MyTeamRecommendHeaderView ()
{
  
}
@end

@implementation MyTeamRecommendHeaderView

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
    _firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_firstButton setTitle:@"A1" forState:UIControlStateNormal];
    _firstButton.titleLabel.font = tFont(13);
    _firstButton.layer.cornerRadius = 11;
    _firstButton.layer.masksToBounds = YES;
    _firstButton.backgroundColor = rgba(255, 221, 148, 1);
    [self addSubview:_firstButton];
    
    _arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"矩形 11 拷贝"]];
    [self addSubview:_arrow];
    
    _secondButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_secondButton setTitle:@"B1" forState:UIControlStateNormal];
    _secondButton.titleLabel.font = tFont(13);
    _secondButton.layer.cornerRadius = 11;
    _secondButton.layer.masksToBounds = YES;
    _secondButton.backgroundColor = MainColor;
    [self addSubview:_secondButton];
}

- (void)layoutSubview{
    [_firstButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.mas_left).offset(20);
        make.size.mas_equalTo(CGSizeMake([HelpManager getLabelWidth:13 labelTxt:_firstButton.titleLabel.text].width + 30, 22));
    }];
    
    [_arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_firstButton.mas_right).offset(5);
        make.centerY.mas_equalTo(_firstButton);
        make.size.mas_equalTo(CGSizeMake(11, 11));
    }];
    
    [_secondButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(_arrow.mas_right).offset(5);
        make.size.mas_equalTo(CGSizeMake([HelpManager getLabelWidth:13 labelTxt:_firstButton.titleLabel.text].width + 30, 22));
    }];
    
}

@end
