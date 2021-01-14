//
//  SubmitOrderSectionFooterView.m
//  531Mall
//
//  Created by 王涛 on 2020/5/23.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "SubmitOrderSectionFooterView.h"

@implementation SubmitOrderSectionFooterView

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
    self.buyNumLabel = [UILabel new];
    self.buyNumLabel.textColor = rgba(88, 88, 88, 1);
    self.buyNumLabel.font = tFont(12);
    [self addSubview:self.buyNumLabel];

}

- (void)layoutSubview{
    [self.buyNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-OverAllLeft_OR_RightSpace);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
}

@end
