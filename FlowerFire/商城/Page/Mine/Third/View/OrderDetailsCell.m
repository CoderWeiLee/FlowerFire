//
//  OrderDetailsCell.m
//  531Mall
//
//  Created by 王涛 on 2020/6/5.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "OrderDetailsCell.h"

@implementation OrderDetailsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
        [self layoutSubview];
    }
    return self;
}
 

- (void)createUI{
    self.leftLabel = [UILabel new];
    self.leftLabel.text = @"--";
    self.leftLabel.font = tFont(13);
    self.leftLabel.textColor = rgba(153, 153, 153, 1);
    [self addSubview:self.leftLabel];
    
    self.rightLabel = [UILabel new];
    self.rightLabel.text = @"--";
    self.rightLabel.numberOfLines = 0;
    self.rightLabel.font = tFont(13);
    self.rightLabel.textColor = rgba(51, 51, 51, 1);
    [self addSubview:self.rightLabel];
}

- (void)layoutSubview{
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(OverAllLeft_OR_RightSpace*2);
        make.top.mas_equalTo(self.mas_top).offset(2);
        make.width.mas_equalTo(60);
    }];
    
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftLabel.mas_right);
        make.top.mas_equalTo(self.leftLabel.mas_top);
        make.right.mas_equalTo(self.mas_right).offset(-OverAllLeft_OR_RightSpace*2);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-15);
    }];
}

@end
