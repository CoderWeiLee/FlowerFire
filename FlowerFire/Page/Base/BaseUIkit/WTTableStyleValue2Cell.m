//
//  WTTableStyleValue2Cell.m
//  FilmCrowdfunding
//
//  Created by mac on 2019/11/18.
//  Copyright © 2019 Celery. All rights reserved.
//

#import "WTTableStyleValue2Cell.h"

@implementation WTTableStyleValue2Cell

 - (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
     self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
     if(self){
         self.selectionStyle = UITableViewCellSelectionStyleNone;
         [self createUI];
         [self layoutSubview];
     }
     return self;
 }

 - (void)createUI{  
     self.topLabel = [WTLabel new];
     self.topLabel.font = tFont(15);
     self.topLabel.textColor = KBlackColor;
     [self.contentView addSubview:self.topLabel];
     
     self.bottomLabel = [WTLabel new];
     self.bottomLabel.font = tFont(15);
     self.bottomLabel.textColor = [UIColor grayColor];
     [self.contentView addSubview:self.bottomLabel];
     
     self.line = [UIView new];
     self.line.theme_backgroundColor = THEME_LINE_TABLEVIEW_SEPARATOR_COLOR;
     [self.contentView addSubview:self.line];
 }

 - (void)layoutSubview{
     [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.mas_equalTo(self.contentView.mas_left).offset(OverAllLeft_OR_RightSpace);
         make.top.mas_equalTo(self.contentView.mas_top).offset(12.5);
         
     }];
     
     [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.mas_equalTo(self.topLabel.mas_left);
         make.top.mas_equalTo(self.topLabel.mas_bottom).offset(2);
         make.height.mas_equalTo(15);
         make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-12.5);
     }];
     
     [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
         make.bottom.mas_equalTo(self.contentView.mas_bottom);
         make.left.mas_equalTo(self.topLabel.mas_left);
         make.right.mas_equalTo(self.contentView.mas_right).offset(-2 *OverAllLeft_OR_RightSpace);
         make.height.mas_equalTo(1);
     }];
     
     if(self.isHiddenSplitLine){
         self.line.hidden = YES;
     }else{
         self.line.hidden = NO;
     }
     
 }
 


@end
