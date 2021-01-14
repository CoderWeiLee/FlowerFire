//
//  WTTableStyleValue1Cell.m
//  FilmCrowdfunding
//
//  Created by 王涛 on 2019/11/16.
//  Copyright © 2019 Celery. All rights reserved.
//

#import "WTTableStyleValue1Cell.h"

@implementation WTTableStyleValue1Cell

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
    self.leftLabel = [WTLabel new];
    self.leftLabel.font = tFont(16);
    self.leftLabel.textColor = KBlackColor;
    [self addSubview:self.leftLabel];
    
    self.rightLabel = [WTLabel new];
    self.rightLabel.font = tFont(16);
    self.rightLabel.textColor = [UIColor grayColor];
    [self addSubview:self.rightLabel];
    
    self.line = [UIView new];
    self.line.theme_backgroundColor = THEME_LINE_TABLEVIEW_SEPARATOR_COLOR;
    [self addSubview:self.line];
}

- (void)layoutSubview{
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(OverAllLeft_OR_RightSpace);
        make.top.mas_equalTo(OverAllLeft_OR_RightSpace);
    }];
    
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-OverAllLeft_OR_RightSpace);
        make.centerY.mas_equalTo(self.leftLabel.mas_centerY);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.leftLabel.mas_bottom).offset(OverAllLeft_OR_RightSpace);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.left.mas_equalTo(self.leftLabel.mas_left);
        make.right.mas_equalTo(self.rightLabel.mas_right);
        make.height.mas_equalTo(1);
    }];
    
    if(self.isHiddenSplitLine){
        self.line.hidden = YES;
    }
}



@end
