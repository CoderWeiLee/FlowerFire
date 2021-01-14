//
//  PayMentBottomView.m
//  FireCoin
//
//  Created by 王涛 on 2019/5/29.
//  Copyright © 2019 王涛. All rights reserved.
//  交易提醒

#import "PayMentBottomView.h"

@implementation PayMentBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = rgba(12, 27, 58, 1);
        self.layer.cornerRadius = 5;
        
        UIButton *remindBtn = [UIButton buttonWithType:UIButtonTypeCustom]; 
        [remindBtn setImage:[UIImage imageNamed:@"pay_warning"] forState:UIControlStateNormal];
        [remindBtn setTitle:LocalizationKey(@"FiatOrderTip48") forState:UIControlStateNormal];
        [remindBtn setTitleColor:MainColor forState:UIControlStateNormal];
        remindBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        
        remindBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self addSubview:remindBtn];
        [remindBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(OverAllLeft_OR_RightSpace);
            make.right.mas_equalTo(self.mas_right).offset(-OverAllLeft_OR_RightSpace);
            make.top.mas_equalTo(self.mas_top).offset(15);
        }];
        [remindBtn sizeToFit];
        
        self.showTitleBtn = remindBtn;
        
        UILabel *tip = [UILabel new];
        tip.text = LocalizationKey(@"FiatOrderTip49");
        tip.numberOfLines = 0;
        tip.textColor = rgba(86, 111, 142, 1);
        tip.font = tFont(15);
        [self addSubview:tip];
        [tip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(remindBtn.mas_left);
            make.top.mas_equalTo(remindBtn.mas_bottom).offset(10);
            make.right.mas_equalTo(self.mas_right).offset(-OverAllLeft_OR_RightSpace);
            make.bottom.mas_equalTo(self.mas_bottom).offset(-20);
        }];
        
        self.showTextLabel = tip;
    }
    return self;
}

@end
