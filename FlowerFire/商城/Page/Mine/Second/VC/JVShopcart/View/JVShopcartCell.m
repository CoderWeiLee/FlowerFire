//
//  JVShopcartCell.m
//  JVShopcart
//
//  Created by AVGD-Jarvi on 17/3/23.
//  Copyright © 2017年 AVGD-Jarvi. All rights reserved.
//

#import "JVShopcartCell.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "JVShopcartCountView.h"

@interface JVShopcartCell ()

@property (nonatomic, strong) UIButton *productSelectButton;
@property (nonatomic, strong) UIImageView *productImageView;
@property (nonatomic, strong) UILabel *productNameLable;
@property (nonatomic, strong) UILabel *productSizeLable;
@property (nonatomic, strong) UILabel *productPriceLable;
@property (nonatomic, strong) JVShopcartCountView *shopcartCountView;
@property (nonatomic, strong) UILabel *productStockLable;
@property (nonatomic, strong) UIView *shopcartBgView;
@property (nonatomic, strong) UIView *topLineView;
@property (nonatomic, strong) NSString *cartID;
@end

@implementation JVShopcartCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = rgba(250, 250, 250, 1);
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    [self.contentView addSubview:self.shopcartBgView];
    [self.shopcartBgView addSubview:self.productSelectButton];
    [self.shopcartBgView addSubview:self.productImageView];
    [self.shopcartBgView addSubview:self.productNameLable];
    [self.shopcartBgView addSubview:self.productSizeLable];
    self.productSizeLable.hidden = YES;
    [self.shopcartBgView addSubview:self.productPriceLable];
    [self.shopcartBgView addSubview:self.shopcartCountView];
    [self.shopcartBgView addSubview:self.productStockLable];
    self.productStockLable.hidden = YES;
    [self.shopcartBgView addSubview:self.topLineView];
}

- (void)configureShopcartCellWithProductURL:(NSString *)productURL productName:(NSString *)productName productSize:(NSString *)productSize productPrice:(NSString *)productPrice threePrice:(NSString *)threePrice productCount:(NSInteger)productCount productStock:(NSInteger)productStock productSelected:(BOOL)productSelected cartId:(NSString *)cartId{
    NSURL *encodingURL = [NSURL URLWithString:[productURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
     [self.productImageView sd_setImageWithURL:encodingURL];
     self.productNameLable.text = productName;
     self.productSizeLable.text = productSize; 
    [[UniversalViewMethod sharedInstance] priceAddqCouponStr:self.productPriceLable priceStr:productPrice CouponStr:threePrice];
    
     self.productSelectButton.selected = productSelected;
     [self.shopcartCountView configureShopcartCountViewWithProductCount:productCount productStock:productStock];
     self.productStockLable.text = [NSString stringWithFormat:@"库存:%ld", productStock];
     self.cartID = cartId;
}

- (void)productSelectButtonAction {
   
    
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    md[@"userid"] = [WTMallUserInfo shareUserInfo].ID;
    md[@"sessionid"] = [WTMallUserInfo shareUserInfo].sessionid;
    md[@"choose"] = self.productSelectButton.isSelected ? @"0" : @"1";
    md[@"cart_id"] = @[self.cartID];
      
    [[ReqestHelpManager share] requestMallPost:@"/api/cart/chooseCartGood" andHeaderParam:md finish:^(NSDictionary *dicForData, ReqestType flag) {
        if([dicForData[@"status"] integerValue] == 1){
          self.productSelectButton.selected = !self.productSelectButton.isSelected;
             if (self.shopcartCellBlock) {
                 self.shopcartCellBlock(self.productSelectButton.selected,self.productSelectButton);
             }
        }else{
            printAlert(dicForData[@"msg"], 1.f);
        }
        
    }];
    
}

- (UIButton *)productSelectButton
{
    if(_productSelectButton == nil)
    {
        _productSelectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_productSelectButton setImage:[UIImage imageNamed:@"Unselected"] forState:UIControlStateNormal];
        [_productSelectButton setImage:[UIImage imageNamed:@"Selected"] forState:UIControlStateSelected];
        [_productSelectButton addTarget:self action:@selector(productSelectButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _productSelectButton;
}

- (UIImageView *)productImageView {
    if (_productImageView == nil){
        _productImageView = [[UIImageView alloc] init];
    }
    return _productImageView;
}

- (UILabel *)productNameLable {
    if (_productNameLable == nil){
        _productNameLable = [[UILabel alloc] init];
        _productNameLable.font = tFont(15);
        _productNameLable.textColor = rgba(51, 51, 51, 1);
    }
    return _productNameLable;
}

- (UILabel *)productSizeLable {
    if (_productSizeLable == nil){
        _productSizeLable = [[UILabel alloc] init];
        _productSizeLable.font = [UIFont systemFontOfSize:13];
        _productSizeLable.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1];
    }
    return _productSizeLable;
}

- (UILabel *)productPriceLable {
    if (_productPriceLable == nil){
        _productPriceLable = [[UILabel alloc] init];
        _productPriceLable.font = tFont(16);
        _productPriceLable.textColor = MainColor;
    }
    return _productPriceLable;
}

- (JVShopcartCountView *)shopcartCountView {
    if (_shopcartCountView == nil){
        _shopcartCountView = [[JVShopcartCountView alloc] init];
        
        __weak __typeof(self) weakSelf = self;
        _shopcartCountView.shopcartCountViewEditBlock = ^(NSInteger count){
            if (weakSelf.shopcartCellEditBlock) {
                weakSelf.shopcartCellEditBlock(count);
            }
        };
    }
    return _shopcartCountView;
}

- (UILabel *)productStockLable {
    if (_productStockLable == nil){
        _productStockLable = [[UILabel alloc] init];
        _productStockLable.font = [UIFont systemFontOfSize:13];
        _productStockLable.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1];
        _productStockLable.hidden = YES;
    }
    return _productStockLable;
}

- (UIView *)shopcartBgView {
    if (_shopcartBgView == nil){
        _shopcartBgView = [[UIView alloc] init];
        _shopcartBgView.backgroundColor = [UIColor whiteColor];
        _shopcartBgView.layer.shadowColor = [UIColor colorWithRed:153/255.0 green:174/255.0 blue:223/255.0 alpha:0.2].CGColor;
        _shopcartBgView.layer.shadowOffset = CGSizeMake(0,5);
        _shopcartBgView.layer.shadowOpacity = 1;
        _shopcartBgView.layer.shadowRadius = 9;
        _shopcartBgView.layer.cornerRadius = 5;
    }
    return _shopcartBgView;
}

- (UIView *)topLineView {
    if (_topLineView == nil){
        _topLineView = [[UIView alloc] init];
        _topLineView.backgroundColor = [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1];
    }
    return _topLineView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.productSelectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.shopcartBgView).offset(10);
        make.centerY.equalTo(self.shopcartBgView).offset(0);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [self.productImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.productSelectButton.mas_right).offset(5);
        make.top.equalTo(self.shopcartBgView).offset(10);
        make.bottom.equalTo(self.shopcartBgView).offset(-10);
        make.size.mas_equalTo(CGSizeMake(65, 65));
    }];
    
    [self.productNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.productImageView.mas_right).offset(10);
        make.top.equalTo(self.productImageView).offset(10);
        make.right.equalTo(self.shopcartBgView).offset(-10);
    }];
    
//    [self.productSizeLable mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.productImageView.mas_right).offset(10);
//        make.top.equalTo(self.productNameLable.mas_bottom);
//        make.right.equalTo(self.shopcartBgView).offset(-5);
//        make.height.equalTo(@20);
//    }];
    
    [self.productPriceLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.productImageView.mas_right).offset(10);
        make.bottom.equalTo(self.productImageView.mas_bottom).offset(-10);
        make.right.equalTo(self.shopcartBgView).offset(-10 - 90);
        make.height.equalTo(@20);
    }];
    
    [self.shopcartCountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.shopcartBgView.mas_right).offset(-10);
        make.bottom.equalTo(self.productImageView).offset(-5);
        make.size.mas_equalTo(CGSizeMake(90, 25));
    }];
    
    [self.productStockLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.shopcartCountView.mas_right).offset(20);
        make.centerY.equalTo(self.shopcartCountView);
    }];
    
    [self.shopcartBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(14.5);
        make.left.mas_equalTo(self.contentView.mas_left).offset(OverAllLeft_OR_RightSpace);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-OverAllLeft_OR_RightSpace);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-2.5);
    }];
    
//    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.shopcartBgView).offset(50);
//        make.top.right.equalTo(self.shopcartBgView);
//        make.height.equalTo(@0.4);
//    }];
}

@end
