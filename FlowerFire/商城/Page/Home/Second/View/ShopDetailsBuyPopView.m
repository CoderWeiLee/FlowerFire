//
//  ShopDetailsBuyPopView.m
//  531Mall
//
//  Created by 王涛 on 2020/5/23.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "ShopDetailsBuyPopView.h"
#import "JVShopcartCountView.h"

@interface ShopDetailsBuyPopView ()
{
    UIImageView *_shopImageView;
    UIView      *_whiteBac;
    UILabel     *_shopName;
    UILabel     *_shopPrice;
    UILabel     *_stockNum;
    UIView      *_line,*_line2;
    UILabel     *_buyNumTip;
    JVShopcartCountView *_buyNumCountView;
    UIButton    *_buyButton;
}
@property(nonatomic, strong)GoodsDetailsModel *model;
@end

@implementation ShopDetailsBuyPopView
 
- (instancetype)initWithFrame:(CGRect)frame GoodsDetailsModel:(nonnull GoodsDetailsModel *)model
{
    self = [super initWithFrame:frame];
    if (self) {
        self.model = model;
        [self createUI];
        [self layoutSubview];
    }
    return self;
}

- (void)createUI{
    _whiteBac = [[UIView alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth, self.height - 20)];
    _whiteBac.backgroundColor = KWhiteColor;
    [self addSubview:_whiteBac];
    
    _shopImageView = [[UIImageView alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, 0, 92, 92)];
    _shopImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_shopImageView sd_setImageWithURL:[NSURL URLWithString:self.model.main_img]];
    [self addSubview:_shopImageView];
    
    _shopName = [[UILabel alloc] init];
    _shopName.text = self.model.name;
    _shopName.textColor = rgba(51, 51, 51, 1);
    _shopName.font = tFont(15);
    [_whiteBac addSubview:_shopName]; 
    
    _shopPrice = [[UILabel alloc] init];
    _shopPrice.textColor = MainColor;
    _shopPrice.font = tFont(15);
    [_whiteBac addSubview:_shopPrice];
    
    [[UniversalViewMethod sharedInstance] priceAddqCouponStr:_shopPrice priceStr:self.model.second_price CouponStr:self.model.three_price];
    
    _stockNum = [[UILabel alloc] init];
    _stockNum.text = NSStringFormat(@"库存:%@",self.model.total_stock);
    _stockNum.textColor = rgba(153, 153, 153, 1);
    _stockNum.font = tFont(12);
    [_whiteBac addSubview:_stockNum];
    
    _line = [[UIView alloc] initWithFrame:CGRectMake(_shopImageView.ly_x, _shopImageView.ly_maxY + 14 - 20, _whiteBac.width - 2 * OverAllLeft_OR_RightSpace, 0.5)];
    _line.backgroundColor = rgba(204, 204, 204, 1);
    [_whiteBac addSubview:_line];
    
    _buyNumTip = [[UILabel alloc] initWithFrame:CGRectMake(_line.ly_x, _line.ly_maxY + 16.5, 200, 13)];
    _buyNumTip.text = @"购买数量:";
    _buyNumTip.textColor = rgba(102, 102, 102, 1);
    _buyNumTip.font = tFont(13);
    [_whiteBac addSubview:_buyNumTip];
    [_buyNumTip sizeToFit];
    
    _buyNumCountView = [[JVShopcartCountView alloc] init];
    [_buyNumCountView configureShopcartCountViewWithProductCount:1 productStock:[self.model.total_stock integerValue]];
    @weakify(self)
    _buyNumCountView.shopcartCountViewEditBlock = ^(NSInteger count) {
        @strongify(self)
        [self->_buyNumCountView configureShopcartCountViewWithProductCount:count productStock:[self.model.total_stock integerValue]];
    };
    _buyNumCountView.frame = CGRectMake(_whiteBac.width - OverAllLeft_OR_RightSpace - 74, _buyNumTip.center.y - 10, 74, 23);
    [_whiteBac addSubview:_buyNumCountView];
    
    _line2 = [[UIView alloc] initWithFrame:CGRectMake(_line.ly_x, _buyNumCountView.ly_maxY + 14, _line.width, 0.5)];
    _line2.backgroundColor = rgba(204, 204, 204, 1);
    [_whiteBac addSubview:_line2];
    
    _buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
    _buyButton.titleLabel.font = tFont(15);
    _buyButton.frame = CGRectMake(0, _whiteBac.height - 50 - SafeAreaBottomHeight, ScreenWidth, 50);
    [[HelpManager sharedHelpManager] jianbianMainColor:_buyButton size:_buyButton.size];
    _buyButton.layer.shadowColor = [UIColor colorWithRed:255/255.0 green:115/255.0 blue:80/255.0 alpha:0.35].CGColor;
    _buyButton.layer.shadowOffset = CGSizeMake(0,2);
    _buyButton.layer.shadowOpacity = 1;
    _buyButton.layer.shadowRadius = 4;
    [_whiteBac addSubview:_buyButton];
    
    [_buyButton addTarget:self action:@selector(buyClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)layoutSubview{
    [_shopName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_shopImageView.mas_right).offset(20);
        make.right.mas_equalTo(self.mas_right).offset(-OverAllLeft_OR_RightSpace);
        make.top.mas_equalTo(_whiteBac.mas_top).offset(13.5);
    }];
     
    [_shopPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_shopImageView.mas_bottom).offset(-12.5);
        make.left.mas_equalTo(_shopName.mas_left);
    }];
    
    [_stockNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_whiteBac.mas_right).offset(-OverAllLeft_OR_RightSpace);
        make.bottom.mas_equalTo(_shopPrice.mas_bottom);
    }];
}

-(void)buyClick{
    !self.buyClickBlock ? : self.buyClickBlock(_buyNumCountView.editTextField.text); 
}

@end
