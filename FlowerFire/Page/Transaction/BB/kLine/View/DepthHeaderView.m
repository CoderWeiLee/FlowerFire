//
//  CurrencyIntroductionCell.m
//  FireCoin
//
//  Created by 王涛 on 2019/6/5.
//  Copyright © 2019 王涛. All rights reserved.
//  币的简介

#import "DepthHeaderView.h"

@implementation DepthHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      //  [self setTheme_backgroundColor:@"bac_cell"];
        [self setUpView];
    }
    return self;
}

-(void)setUpView{
    self.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
    
    UIView *line = [UIView new];
    line.theme_backgroundColor = THEME_LINE_TABLEVIEW_SEPARATOR_COLOR;
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.left.mas_equalTo(self.mas_left);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, 10));
    }];
    
    self.deepthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.deepthBtn setTitle:LocalizationKey(@"Depth") forState:UIControlStateNormal];
    [self.deepthBtn setTitleColor:rgba(110, 134, 163, 1) forState:UIControlStateNormal];
    [self.deepthBtn setTitleColor:MainColor forState:UIControlStateSelected];
    [self addSubview:self.deepthBtn];
    self.deepthBtn.titleLabel.font = tFont(15);
    self.deepthBtn.titleLabel.layer.masksToBounds = YES;
    self.deepthBtn.titleLabel.backgroundColor = self.backgroundColor;
    [self.deepthBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY).offset(5);
        make.width.mas_equalTo(ScreenWidth/3);
        make.left.mas_equalTo(self.mas_left);
        make.height.mas_equalTo(self.mas_height);
    }];
    
    self.line1 = [UIView new];
    self.line1.backgroundColor = MainColor;
    [self addSubview:self.line1];
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom);
        make.width.mas_equalTo(self.deepthBtn.titleLabel.mas_width);
        make.centerX.mas_equalTo(self.deepthBtn.mas_centerX);
        make.height.mas_equalTo(1);
    }];
    
    self.tradeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.tradeBtn setTitle:LocalizationKey(@"Filled") forState:UIControlStateNormal];
    [self.tradeBtn setTitleColor:rgba(110, 134, 163, 1) forState:UIControlStateNormal];
    [self.tradeBtn setTitleColor:MainColor forState:UIControlStateSelected];
    self.tradeBtn.titleLabel.layer.masksToBounds = YES;
    self.tradeBtn.titleLabel.backgroundColor = self.backgroundColor;
    [self addSubview:self.tradeBtn];
    self.tradeBtn.titleLabel.font = tFont(15);
    [self.tradeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY).offset(5);;
        //   make.centerX.mas_equalTo(self.mas_centerX);
        make.width.mas_equalTo(ScreenWidth/3);
        make.left.mas_equalTo(self.deepthBtn.mas_right);
        make.height.mas_equalTo(self.mas_height);
    }];
    
    self.line2 = [UIView new];
    self.line2.hidden = YES;
    self.line2.backgroundColor = MainColor;
    [self addSubview:self.line2];
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom);
        make.width.mas_equalTo(self.tradeBtn.titleLabel.mas_width);
        make.centerX.mas_equalTo(self.tradeBtn.mas_centerX);
        make.height.mas_equalTo(1);
    }];
    
    self.introductionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.introductionBtn.titleLabel.layer.masksToBounds = YES;
    self.introductionBtn.titleLabel.backgroundColor = self.backgroundColor;
    [self.introductionBtn setTitle:LocalizationKey(@"Introduction") forState:UIControlStateNormal];
    [self.introductionBtn setTitleColor:rgba(110, 134, 163, 1) forState:UIControlStateNormal];
    [self.introductionBtn setTitleColor:MainColor forState:UIControlStateSelected];
    [self addSubview:self.introductionBtn];
    self.introductionBtn.titleLabel.font = tFont(15);
    [self.introductionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY).offset(5);
        make.width.mas_equalTo(ScreenWidth/3);
        make.left.mas_equalTo(self.tradeBtn.mas_right);
        make.height.mas_equalTo(self.mas_height);
    }];
    
    self.line3 = [UIView new];
    self.line3.hidden = YES;
    self.line3.backgroundColor = MainColor;
    [self addSubview:self.line3];
    [self.line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom);
        make.width.mas_equalTo(self.introductionBtn.titleLabel.mas_width);
        make.centerX.mas_equalTo(self.introductionBtn.mas_centerX);
        make.height.mas_equalTo(1);
    }];
    
    self.deepthBtn.tag = 0;
    self.tradeBtn.tag = 1;
    self.introductionBtn.tag = 2;
    [self.deepthBtn addTarget:self action:@selector(deepthClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.tradeBtn addTarget:self action:@selector(tradeClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.introductionBtn addTarget:self action:@selector(introductionBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [self deepthClick:self.deepthBtn];
}

//深度点击
-(void)deepthClick:(UIButton *)btn{
    self.deepthBtn.selected = YES;
    self.tradeBtn.selected = NO;
    self.introductionBtn.selected = NO;
    
    self.deepthBtn.userInteractionEnabled = NO;
    self.tradeBtn.userInteractionEnabled = YES;
    self.introductionBtn.userInteractionEnabled = YES;
    
    self.line1.hidden = NO;
    self.line2.hidden = YES;
    self.line3.hidden = YES;
    
    if([self.deleagte respondsToSelector:@selector(didSwitchDeepthClick:)]){
        [self.deleagte didSwitchDeepthClick:btn];
    }
}
//成交量点击
-(void)tradeClick:(UIButton *)btn{
    self.deepthBtn.selected = NO;
    self.tradeBtn.selected = YES;
    self.introductionBtn.selected = NO;
    
    self.deepthBtn.userInteractionEnabled = YES;
    self.tradeBtn.userInteractionEnabled = NO;
    self.introductionBtn.userInteractionEnabled = YES;
    
    self.line1.hidden = YES;
    self.line2.hidden = NO;
    self.line3.hidden = YES;
    
    if([self.deleagte respondsToSelector:@selector(didSwitchDeepthClick:)]){
        [self.deleagte didSwitchDeepthClick:btn];
    }
}
//简介点击
-(void)introductionBtn:(UIButton *)btn{
    self.deepthBtn.selected = NO;
    self.tradeBtn.selected = NO;
    self.introductionBtn.selected = YES;
    
    self.deepthBtn.userInteractionEnabled = YES;
    self.tradeBtn.userInteractionEnabled = YES;
    self.introductionBtn.userInteractionEnabled = NO;
    
    self.line1.hidden = YES;
    self.line2.hidden = YES;
    self.line3.hidden = NO;
    
    if([self.deleagte respondsToSelector:@selector(didSwitchDeepthClick:)]){
        [self.deleagte didSwitchDeepthClick:btn];
    }
}


@end
