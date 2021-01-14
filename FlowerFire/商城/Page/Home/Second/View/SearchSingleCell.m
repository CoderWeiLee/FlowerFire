//
//  SearchSingleCell.m
//  531Mall
//
//  Created by 王涛 on 2020/5/19.
//  Copyright © 2020 Celery. All rights reserved.
//  单列cell
 
#import "SearchSingleCell.h"

@interface SearchSingleCell ()
{
    UIImageView *_shopImage;
    UILabel     *_price,*_shopName;
    UILabel     *_stock;
}
@end

@implementation SearchSingleCell

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
    self.layer.shadowColor = rgba(153, 174, 233, 0.2).CGColor;
    self.layer.shadowOffset = CGSizeMake(0,5);
    self.layer.shadowOpacity = 1;
    self.layer.shadowRadius = 9;
    self.layer.cornerRadius = 5;
     
    self.backgroundColor = KWhiteColor;
    
    _shopImage = [[UIImageView alloc] initWithImage:[UIImage imageWithColor:[UIColor orangeColor]]];
    _shopImage.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_shopImage];
    
    _price = [UILabel new];
    _price.textColor = MainColor;
    _price.text = @"¥--";
    _price.font = tFont(20);
    _price.numberOfLines = 0;
    [self addSubview:_price];
    
    _shopName = [UILabel new];
    _shopName.text = @"--";
    _shopName.numberOfLines = 0;
    _shopName.font = tFont(13);
    _shopName.textColor = rgba(51, 51, 51, 1);
    [self addSubview:_shopName];
    
    _stock = [UILabel new];
    _stock.text = @"库存:--";
    _stock.numberOfLines = 0;
    _stock.font = tFont(12);
    _stock.textColor = rgba(153, 153, 153, 1);
    [self addSubview:_stock];
}

- (void)layoutSubview{
    CGFloat imageWidth = (ScreenWidth - 16*2)/4;
    [_shopImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(7.5);
        make.left.mas_equalTo(self.mas_left).offset(10);
        make.size.mas_equalTo(CGSizeMake(imageWidth, imageWidth));
    }];
    
    [_shopName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_shopImage.mas_top).offset(13);
        make.left.mas_equalTo(_shopImage.mas_right).offset(6.5);
        make.right.mas_equalTo(self.mas_right).offset(-OverAllLeft_OR_RightSpace);
        make.width.mas_equalTo(ScreenWidth - 16 * 2 - 10 - OverAllLeft_OR_RightSpace - imageWidth - 6.5);
    }];
    
    [_price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_shopName.mas_bottom).offset(13);
        make.left.mas_equalTo(_shopName.mas_left);
        make.right.mas_equalTo(self.mas_right).offset(-OverAllLeft_OR_RightSpace);
    }];
    
    [_stock mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_price.mas_bottom).offset(9.5);
        make.left.mas_equalTo(_shopName.mas_left);
        make.right.mas_equalTo(self.mas_right).offset(-OverAllLeft_OR_RightSpace);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-21);
    }];
}

- (void)setCellData:(GoodsInfoModel *)model{
    [_shopImage sd_setImageWithURL:[NSURL URLWithString:model.main_img]]; 
    [[UniversalViewMethod sharedInstance] priceAddqCouponStr:_price priceStr:model.second_price CouponStr:model.three_price];
    _shopName.text = model.name;
    _stock.text = NSStringFormat(@"库存%@",model.total_stock);
}

@end
