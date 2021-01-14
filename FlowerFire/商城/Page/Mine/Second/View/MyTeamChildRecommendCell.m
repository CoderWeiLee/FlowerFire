//
//  MyTeamChildRecommendCell.m
//  531Mall
//
//  Created by 王涛 on 2020/5/21.
//  Copyright © 2020 Celery. All rights reserved.
//  推荐结构cell

#import "MyTeamChildRecommendCell.h"

@interface MyTeamChildRecommendCell ()
{
    UILabel *_userId,*_time;
    UILabel *_price;
    
}
@end

@implementation MyTeamChildRecommendCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self createUI];
        [self layoutSubview];
    }
    return self;
}

- (void)setCellData:(RecommendedStructureDownusersModel *)model{
    _userId.text = model.username;
    _time.text = model.pay_date;
    _price.text = NSStringFormat(@"¥%@",model.moth_pv);
}

- (void)createUI{
    self.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    self.layer.shadowColor = [UIColor colorWithRed:153/255.0 green:174/255.0 blue:223/255.0 alpha:0.2].CGColor;
    self.layer.shadowOffset = CGSizeMake(0,5);
    self.layer.shadowOpacity = 1;
    self.layer.shadowRadius = 9;
    self.layer.cornerRadius = 5;
    
    _userId = [UILabel new];
    _userId.text = @"--";
    _userId.textColor = rgba(51, 51, 51, 1);
    _userId.font = tFont(15);
    [self addSubview:_userId];
    
    _time = [UILabel new];
    _time.text = @"--";
    _time.textColor = rgba(153, 153, 153, 1);
    _time.font = tFont(12);
    [self addSubview:_time];
    
    _price = [UILabel new];
    _price.text = @"--";
    _price.textColor = MainColor;
    _price.font = tFont(23);
    [self addSubview:_price];
}

- (void)layoutSubview{
    [_userId mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(8.5);
        make.left.mas_equalTo(self.mas_left).offset(8.5);
        make.height.mas_equalTo(20).priorityHigh();
    }];
    
    [_time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(8.5);
        make.top.mas_equalTo(_userId.mas_bottom).offset(8.5 + 7.5).priorityHigh();
        make.height.mas_equalTo(20).priorityHigh();
        make.bottom.mas_equalTo(self.mas_bottom).offset(-8.5 -1) ;
    }];
    
    [_price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY) ;
    }];
}

- (void)setFrame:(CGRect)frame{
    frame.origin.y += OverAllLeft_OR_RightSpace;
    frame.size.height -= OverAllLeft_OR_RightSpace;
    frame.origin.x += OverAllLeft_OR_RightSpace;
    frame.size.width -= OverAllLeft_OR_RightSpace * 2;
    [super setFrame:frame];
}

@end
