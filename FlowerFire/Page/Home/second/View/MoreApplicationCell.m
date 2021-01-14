//
//  MoreApplicationCell.m
//  FlowerFire
//
//  Created by 王涛 on 2020/5/27.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "MoreApplicationCell.h"

@interface MoreApplicationCell ()

@end

@implementation MoreApplicationCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = rgba(244, 249, 252, 1);
        self.layer.cornerRadius = 3;
        self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"充币"]];
        [self addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(self.mas_top).offset(15);
            make.size.mas_equalTo(CGSizeMake(((ScreenWidth - 15 * 2 - 10 * 3)/4)/2 - 10,((ScreenWidth - 15 * 2 - 10 * 3)/4)/2 - 10));
        }];
        
        self.title = [UILabel new];
        self.title.text = @"--";
        self.title.textColor = [UIColor grayColor];
        self.title.font = tFont(13);
        [self addSubview:self.title];
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(self.imageView.mas_bottom).offset(10);
        }];
    }
    return self;
}

@end
