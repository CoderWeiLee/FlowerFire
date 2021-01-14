//
//  UserInfoCell.m
//  531Mall
//
//  Created by 王涛 on 2020/5/19.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "UserInfoCell.h"

@implementation UserInfoCell

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
    self.bacView = [UIView new];
    self.bacView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    self.bacView.layer.shadowColor = [UIColor colorWithRed:153/255.0 green:174/255.0 blue:223/255.0 alpha:0.2].CGColor;
    self.bacView.layer.shadowOffset = CGSizeMake(0,5);
    self.bacView.layer.shadowOpacity = 1;
    self.bacView.layer.shadowRadius = 9;
    self.bacView.layer.cornerRadius = 5;
    [self addSubview:self.bacView];
    
    self.leftLabel = [WTLabel new];
    self.leftLabel.font = tFont(13);
    self.leftLabel.textColor = rgba(102, 102, 102, 1);
    [self.bacView addSubview:self.leftLabel];
    
    self.rightLabel = [WTLabel new];
    self.rightLabel.font = tFont(13);
    self.rightLabel.textColor = rgba(51, 51, 51, 1);
    [self.bacView addSubview:self.rightLabel];
     
}

- (void)layoutSubview{
    self.bacView.frame = CGRectMake(15, 0, ScreenWidth - 30, 45);
    
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bacView.mas_left).offset(OverAllLeft_OR_RightSpace);
        make.centerY.mas_equalTo(self.bacView.mas_centerY);
    }];
    
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.bacView.mas_right).offset(-OverAllLeft_OR_RightSpace);
        make.centerY.mas_equalTo(self.leftLabel.mas_centerY);
    }];
     
}

- (void)setFrame:(CGRect)frame{
    frame.origin.y += OverAllLeft_OR_RightSpace;
    frame.size.height -= OverAllLeft_OR_RightSpace;
    [super setFrame:frame];
}


@end
