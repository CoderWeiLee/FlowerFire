//
//  FFSaveMnemonicCell.m
//  FlowerFire
//
//  Created by 王涛 on 2020/8/25.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "FFSaveMnemonicCell.h"

@implementation FFSaveMnemonicCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.title = [[WTLabel alloc] initWithFrame:self.bounds];
        self.title.font = tFont(15);
        self.title.textAlignment = NSTextAlignmentCenter;
        self.title.textColor = KBlackColor;
        [self.contentView addSubview:self.title];
    }
    return self;
}

@end
