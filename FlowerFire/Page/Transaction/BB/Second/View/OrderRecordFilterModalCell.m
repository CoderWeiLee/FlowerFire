//
//  OrderRecordFilterModalCell.m
//  FireCoin
//
//  Created by 王涛 on 2019/6/25.
//  Copyright © 2019 王涛. All rights reserved.
//  订单状态cell

#import "OrderRecordFilterModalCell.h"



@implementation OrderRecordFilterModalCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.button.enabled = NO;
        self.button.titleLabel.font = tFont(15); 
        self.button.theme_backgroundColor = THEME_INPUT_BACKGROUNDCOLOR;
        [self addSubview:self.button];
        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
          //  make.size.mas_equalTo(CGSizeMake((ScreenWidth - 40 - 10*2)/3, 40));
        }];
    }
    return self;
}

@end
