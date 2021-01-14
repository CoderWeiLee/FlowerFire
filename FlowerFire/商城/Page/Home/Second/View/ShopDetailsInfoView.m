//
//  ShopDetailsInfoView.m
//  531Mall
//
//  Created by 王涛 on 2020/5/22.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "ShopDetailsInfoView.h"

@interface ShopDetailsInfoView ()
{
    UILabel *_shopName,*_price,*_stockNum;
    UIView  *_line,*_line2;
    UILabel *_formatTip,*_formatLabel1,*_formatLabel2;
    UIImageView *_shopDetailsTipImageView;
}
@end

@implementation ShopDetailsInfoView


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
    _shopName = [UILabel new];
    _shopName.text = @"--";
    _shopName.textColor = rgba(51, 51, 51, 1);
    _shopName.numberOfLines = 0;
    _shopName.font = tFont(15);
    [self addSubview:_shopName];

    _price = [UILabel new];
    _price.textColor = MainColor;
    _price.font = tFont(20);
    _price.text = @"¥--";
    [self addSubview:_price];
    
    _stockNum = [UILabel new];
    _stockNum.text = @"库存:--";
    _stockNum.textColor = rgba(153, 153, 153, 1);
    _stockNum.font = tFont(13);
    [self addSubview:_stockNum];
    
    _line = [UIView new];
    _line.backgroundColor = rgba(249, 249, 249, 1);
    [self addSubview:_line];
    
    _formatTip = [UILabel new];
    _formatTip.text = @"规格:";
    _formatTip.textColor = rgba(153, 153, 153, 1);
    _formatTip.font = tFont(13);
    [self addSubview:_formatTip];
    
    _formatLabel1 = [UILabel new];
    _formatLabel1.text = @"长宽高:--、--、--";
    _formatLabel1.textColor = rgba(102, 102, 102, 1);
    _formatLabel1.font = tFont(13);
    _formatLabel1.numberOfLines = 0;
    [self addSubview:_formatLabel1];
    
    _formatLabel2 = [UILabel new];
    _formatLabel2.text = @"生产日期:0000-00-00";
    _formatLabel2.textColor = rgba(102, 102, 102, 1);
    _formatLabel2.font = tFont(13);
    [self addSubview:_formatLabel2];
    
    _line2 = [UIView new];
    _line2.backgroundColor = rgba(249, 249, 249, 1);
    [self addSubview:_line2];
    
    _shopDetailsTipImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"spxq"]];
    [self addSubview:_shopDetailsTipImageView];
}

- (void)layoutSubview{ 
    [_shopName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(OverAllLeft_OR_RightSpace);
        make.top.mas_equalTo(self.mas_top).offset(14.5);
        make.right.mas_equalTo(self.mas_right).offset(-OverAllLeft_OR_RightSpace);
    }];

    [_price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_shopName.mas_left);
        make.top.mas_equalTo(_shopName.mas_bottom).offset(16);
    }];
    
    [_stockNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-OverAllLeft_OR_RightSpace);
        make.centerY.mas_equalTo(_price.mas_centerY);
    }];
    
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_price.mas_bottom).offset(14.5);
        make.left.mas_equalTo(self.mas_left);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, 8));
    }];
    
    [_formatTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_line.mas_bottom).offset(OverAllLeft_OR_RightSpace);
        make.left.mas_equalTo(_line.mas_left).offset(OverAllLeft_OR_RightSpace);
        make.width.mas_equalTo([HelpManager getLabelWidth:13 labelTxt:_formatTip.text]);
    }];
    
    [_formatLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_formatTip.mas_bottom).offset(14.5);
        make.right.mas_equalTo(self.mas_right).offset(-OverAllLeft_OR_RightSpace);
        make.left.mas_equalTo(_formatTip.mas_right).offset(12).priorityHigh();
    }];
    
    [_formatLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_formatLabel1.mas_bottom).offset(11);
        make.right.mas_equalTo(self.mas_right).offset(-OverAllLeft_OR_RightSpace).priorityLow();
        make.left.mas_equalTo(_formatLabel1.mas_left).priorityHigh();
    }];
    
    [_line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_formatLabel2.mas_bottom).offset(OverAllLeft_OR_RightSpace);
        make.left.mas_equalTo(_line.mas_left);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, 8));
    }];
    
    [_shopDetailsTipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(_line2.mas_bottom).offset(22); 
        make.size.mas_equalTo(CGSizeMake(157.5, 28));
    }];
    
}

- (void)setDetailsInfoViewData:(GoodsDetailsModel *)model{
    _shopName.text = model.name; 
    [[UniversalViewMethod sharedInstance] priceAddqCouponStr:_price priceStr:model.second_price CouponStr:model.three_price];
    
    _stockNum.text = NSStringFormat(@"库存:%@",model.total_stock);
    
    _formatLabel1.text = @"";
    _formatLabel2.text = @"";
    for (GoodsDetailsAttrsModel *attrsModel in model.attrs) {
        _formatLabel1.text = [_formatLabel1.text stringByAppendingFormat:@"%@: %@ ",attrsModel.name,attrsModel.value];
      //  _formatLabel2.text = [_formatLabel2.text stringByAppendingFormat:@"%@",attrsModel.value];
    }
}


@end
