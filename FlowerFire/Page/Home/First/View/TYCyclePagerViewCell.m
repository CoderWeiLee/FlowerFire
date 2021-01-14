//
//  TYCyclePagerViewCell.m
//  FireCoin
//
//  Created by 王涛 on 2019/7/16.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "TYCyclePagerViewCell.h"

@interface TYCyclePagerViewCell () 
@end

@implementation TYCyclePagerViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.bannerImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"banner1"]];
        self.bannerImage.contentMode = UIViewContentModeScaleAspectFill;
        self.bannerImage.clipsToBounds = YES;
        self.bannerImage.layer.cornerRadius = 5;
        self.bannerImage.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        [self addSubview:self.bannerImage];
        [self.bannerImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self); 
        }];
    }
    return self;
}
 


@end
