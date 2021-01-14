//
//  MyTeamChildTotalDelegateCell.m
//  531Mall
//
//  Created by 王涛 on 2020/5/21.
//  Copyright © 2020 Celery. All rights reserved.
//。总代cell

#import "MyTeamChildTotalDelegateCell.h"

@interface MyTeamChildTotalDelegateCell ()
{
    UILabel *_time,*_price,*_wage;
}
@end

@implementation MyTeamChildTotalDelegateCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self createUI];
        [self layoutSubview];
    }
    return self;
}

- (void)setCellData:(TotalDelegateModel *)model{
    NSString *_sumPriceStr = NSStringFormat(@"当月业绩\n¥%@",model.introducepv);
    NSString *_todayPriceStr = NSStringFormat(@"当月工资\n¥%@",model.val);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 1;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_sumPriceStr attributes:@{NSParagraphStyleAttributeName:paragraphStyle}];
    [attributedString addAttributes:@{NSFontAttributeName:tFont(18)} range:[_sumPriceStr rangeOfString:model.introducepv]];
    _price.attributedText = attributedString;
     
    attributedString = [[NSMutableAttributedString alloc] initWithString:_todayPriceStr attributes:@{NSParagraphStyleAttributeName:paragraphStyle}];
    [attributedString addAttributes:@{NSFontAttributeName:tFont(18)} range:[_todayPriceStr rangeOfString:model.val]];
    [attributedString addAttributes:@{NSForegroundColorAttributeName:MainColor} range:[_todayPriceStr rangeOfString:model.val]];
     
    _wage.attributedText = attributedString;
    
    _time.text = model.calc_date;
}

- (void)createUI{
    self.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    self.layer.shadowColor = [UIColor colorWithRed:153/255.0 green:174/255.0 blue:223/255.0 alpha:0.2].CGColor;
    self.layer.shadowOffset = CGSizeMake(0,5);
    self.layer.shadowOpacity = 1;
    self.layer.shadowRadius = 9;
    self.layer.cornerRadius = 5;
    
    _time = [UILabel new];
    _time.text = @"--";
    _time.textColor = rgba(102, 102, 102, 1);
    _time.font = tFont(12);
    [self addSubview:_time];
    
    _price = [UILabel new];
    _price.text = @"当月业绩";
    _price.textColor = rgba(102, 102, 102, 1);
    _price.font = tFont(11);
    _price.numberOfLines = 0;
    [self addSubview:_price];

    _wage = [UILabel new];
    _wage.text = @"当月工资";
    _wage.textColor = rgba(102, 102, 102, 1);
    _wage.font = tFont(11);
    _wage.numberOfLines = 0;
    [self addSubview:_wage];
     
}

- (void)layoutSubview{
    [_time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(8.5);
        make.top.mas_equalTo(self.mas_top).offset(15.5+OverAllLeft_OR_RightSpace);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-15.5 - OverAllLeft_OR_RightSpace);
        make.height.mas_equalTo(20).priorityHigh();
    }];
    
    [_price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_time.mas_centerY);
        make.centerX.mas_equalTo(self.mas_centerX).offset(-30);
        
    }];

    [_wage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_time.mas_centerY);
        make.right.mas_equalTo(self.mas_right).offset(-8.5);
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
