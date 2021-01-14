//
//  editDynamicCollectionViewCell.m
//  yanyu
//
//  Created by mac on 2018/12/17.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "AppealCollectionViewCell.h"


@implementation AppealCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self createCell];
    }
    return self;
}

-(void)createCell{
    self.dynamicImage = [UIImageView new];
    self.dynamicImage.image = [UIImage imageNamed:@"content_icon_tianjia-1"];
    self.dynamicImage.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:self.dynamicImage];
    [self.dynamicImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.mas_equalTo(self).offset(0);
 
    }];
    
  //  [self.dynamicImage sd_setImageWithURL:[NSURL URLWithString:@"http://119.23.16.29:8090/img/imgheadpic/2018080113305191.jpg"]  placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    self.deleImage  = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.deleImage addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
    [self.deleImage setImage:[UIImage imageNamed:@"v1_2_13"] forState:UIControlStateNormal];
    [self addSubview:self.deleImage];
    [self.deleImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.dynamicImage.mas_right).offset(0);
        make.top.mas_equalTo(self.dynamicImage.mas_top).offset(0);
        make.size.mas_equalTo(CGSizeMake(20,20));
        //  make.bottom.mas_equalTo(self.mas_bottom).offset(-20);
    }];
    
    
}

-(void)deleteClick{
    [self.delegate delePhoto:self];
}

@end
