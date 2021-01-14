//
//  SubmitOrderCell.m
//  531Mall
//
//  Created by 王涛 on 2020/5/23.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "SubmitOrderCell.h"

@interface SubmitOrderCell ()
{
    UIImageView *_shopImageView;
    UILabel     *_shopName;
    UILabel     *_price,*_num;
}
@end

@implementation SubmitOrderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self createUI];
        [self layoutSubview];
    }
    return self;
}

- (void)createUI{
    self.layer.cornerRadius = 5;
    self.backgroundColor = KWhiteColor;
    _shopImageView = [[UIImageView alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, OverAllLeft_OR_RightSpace, 65, 65)];
    _shopImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_shopImageView];
    
    _shopName = [UILabel new];
    _shopName.text = @"--";
    _shopName.textColor = rgba(51, 51, 51, 1);
    _shopName.font = tFont(15);
    //_shopName.numberOfLines = 0;
    [self addSubview:_shopName];
    
    _price = [UILabel new];
    _price.text = @"¥";
    _price.textColor = MainColor;
    _price.font = tFont(13);
    [self addSubview:_price];
    
    _num = [UILabel new];
    _num.textColor = rgba(102, 102, 102, 1);
    _num.font = tFont(13);
    _num.text = @"--";
    [self addSubview:_num];
}

- (void)layoutSubview{
    [_shopName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_shopImageView.mas_top).offset(10);
        make.left.mas_equalTo(_shopImageView.mas_right).offset(15);
        make.right.mas_equalTo(self.mas_right).offset(-OverAllLeft_OR_RightSpace);
    }];
    
    [_price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_shopImageView.mas_bottom).offset(-10);
        make.left.mas_equalTo(_shopName.mas_left);
    }];
    
    [_num mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.bottom.mas_equalTo(_price.mas_bottom);
    }];
}

- (void)setCellData:(NSDictionary *)dic{
    [_shopImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"img"]]];
    _shopName.text = dic[@"name"];
    [[UniversalViewMethod sharedInstance] priceAddqCouponStr:_price priceStr:dic[@"second_price"] CouponStr:dic[@"three_price"]];
    _num.text = NSStringFormat(@"X%@",dic[@"amount"]);
}
 

@end
