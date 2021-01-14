//
//  FFVerificationMnemonicCell.m
//  FlowerFire
//
//  Created by 王涛 on 2020/8/25.
//  Copyright © 2020 Celery. All rights reserved.
//  验证Cell

#import "FFVerificationMnemonicCell.h"

@implementation FFVerificationMnemonicCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.title = [[WTLabel alloc] initWithFrame:self.bounds];
        self.title.font = tFont(15);
        self.title.textAlignment = NSTextAlignmentCenter;
        self.title.textColor = KBlackColor;
        self.title.layer.cornerRadius = 15;
        self.title.layer.masksToBounds = YES;
        [self.contentView addSubview:self.title];
        
        self.deleteButton = [[WTButton alloc] initWithFrame:CGRectZero];
        [self.deleteButton setImage:[UIImage imageNamed:@"total_balance_clear_normal"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.deleteButton];
    }
    return self;
}

@end
