//
//  HomeMainCell.m
//  531Mall
//
//  Created by 王涛 on 2020/5/18.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "HomeMainCell.h"

@interface HomeMainCell ()
{
    UIImageView *_shopImage;
    UILabel     *_price,*_shopName;
}
@end

@implementation HomeMainCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self createUI];
        [self layoutSubview];
    }
    return self;
}

- (void)createUI{
    self.layer.shadowColor = rgba(153, 174, 233, 0.2).CGColor;
    self.layer.shadowOffset = CGSizeMake(0,5);
    self.layer.shadowOpacity = 1;
    self.layer.shadowRadius = 9;
    self.layer.cornerRadius = 5;
     
    self.backgroundColor = KWhiteColor;
    
    _shopImage = [[UIImageView alloc] init];
    _shopImage.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_shopImage];
    
    _price = [UILabel new];
    _price.textColor = MainColor;
    _price.text = @"¥--";
    _price.font = tFont(15);
    _price.numberOfLines = 0;
    _price.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_price];
    
    _shopName = [UILabel new];
    _shopName.text = @"--";
    _shopName.numberOfLines = 0;
    _shopName.font = tFont(13);
    _shopName.textColor = rgba(51, 51, 51, 1);
    _shopName.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_shopName];
}

- (void)layoutSubview{
    CGFloat imageWidth = (ScreenWidth - 16*2)/2 - 8 - 16 * 2  ; // (ScreenWidth - 16*2 - 14) /2 - 16 * 2;
    [_shopImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(10);
        make.left.mas_equalTo(self.mas_left).offset(16).priorityHigh();
        make.right.mas_equalTo(self.mas_right).offset(-16).priorityHigh();
        make.size.mas_equalTo(CGSizeMake(imageWidth, imageWidth));
        
    }];
    
    [_price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_shopImage.mas_bottom).offset(9.5);
        make.left.mas_equalTo(_shopImage.mas_left);
        make.right.mas_equalTo(_shopImage.mas_right);
    }];
    
    [_shopName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_price.mas_bottom).offset(8);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-13.5);
        make.left.mas_equalTo(_shopImage.mas_left);
        make.right.mas_equalTo(_shopImage.mas_right);
    }];
}

- (void)setCellData:(GoodsInfoModel *)model{
    [_shopImage sd_setImageWithURL:[NSURL URLWithString:model.main_img] placeholderImage:_shopImage.image];
     
    [[UniversalViewMethod sharedInstance] priceAddqCouponStr:_price priceStr:model.second_price CouponStr:model.three_price];
    
    _shopName.text = model.name;
}

@end
