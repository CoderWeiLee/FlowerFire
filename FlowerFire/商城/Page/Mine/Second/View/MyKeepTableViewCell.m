//
//  MyKeepTableViewCell.m
//  531Mall
//
//  Created by 王涛 on 2020/5/19.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "MyKeepTableViewCell.h" 

@interface MyKeepTableViewCell ()
{
    UIView      *_bacView;
    UIImageView *_shopImage;
    UILabel     *_price,*_shopName;
    UILabel     *_stock;
}
@end

@implementation MyKeepTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self createUI];
        [self layoutSubview];
    }
    return self;
}

- (void)createUI{
    _bacView = [UIView new];
    _bacView.layer.shadowColor = rgba(153, 174, 233, 0.2).CGColor;
    _bacView.layer.shadowOffset = CGSizeMake(0,5);
    _bacView.layer.shadowOpacity = 1;
    _bacView.layer.shadowRadius = 9;
    _bacView.layer.cornerRadius = 5;
    _bacView.backgroundColor = KWhiteColor;
    [self addSubview:_bacView];
    
    _shopImage = [[UIImageView alloc] init];
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
    [_bacView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(16);
        make.right.mas_equalTo(self.mas_right).offset(-16);
        make.top.mas_equalTo(self.mas_top).offset(16);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-10);
    }];
    
    CGFloat imageWidth = (ScreenWidth - 16*2)/4;
    [_shopImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_bacView.mas_top).offset(7.5);
        make.left.mas_equalTo(_bacView.mas_left).offset(10);
        make.size.mas_equalTo(CGSizeMake(imageWidth, imageWidth));
    }];
    
    [_shopName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_shopImage.mas_top).offset(13);
        make.left.mas_equalTo(_shopImage.mas_right).offset(6.5);
        make.right.mas_equalTo(_bacView.mas_right).offset(-OverAllLeft_OR_RightSpace);
        make.width.mas_equalTo(ScreenWidth - 16 * 2 - 10 - OverAllLeft_OR_RightSpace - imageWidth - 6.5);
    }];
    
    [_price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_shopName.mas_bottom).offset(13);
        make.left.mas_equalTo(_shopName.mas_left);
        make.right.mas_equalTo(_bacView.mas_right).offset(-OverAllLeft_OR_RightSpace);
    }];
    
    [_stock mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_price.mas_bottom).offset(9.5);
        make.left.mas_equalTo(_shopName.mas_left);
        make.right.mas_equalTo(_bacView.mas_right).offset(-OverAllLeft_OR_RightSpace);
        make.bottom.mas_equalTo(_bacView.mas_bottom).offset(-21);
    }];
     
}

- (void)setCellData:(MyKeepModel *)model{
    [_shopImage sd_setImageWithURL:[NSURL URLWithString:model.main_img]];
    _shopName.text = model.name; 
    [[UniversalViewMethod sharedInstance] priceAddqCouponStr:_price priceStr:model.second_price CouponStr:model.three_price];
    _stock.text = NSStringFormat(@"库存:%@",model.total_stock);
}
 

@end
