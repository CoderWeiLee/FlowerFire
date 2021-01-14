//
//  ShopDetailsToolBarView.m
//  531Mall
//
//  Created by 王涛 on 2020/5/23.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "ShopDetailsToolBarView.h"
#import "UIImage+jianbianImage.h"

@implementation ShopDetailsToolBarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
        [self layoutSubview];
        
        @weakify(self)
        [self.keepButton touchAction:^(SQCustomButton * _Nonnull button) {
            @strongify(self)
            if([self.delegate respondsToSelector:@selector(keepClick:)]){
                [self.delegate keepClick:button];
            }
        }];
        [self.jumpShopCartButton touchAction:^(SQCustomButton * _Nonnull button) {
            @strongify(self)
            if([self.delegate respondsToSelector:@selector(jumpShopCartClick:)]){
                [self.delegate jumpShopCartClick:button];
            }
        }];
        
        [self.addShopCartButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            @strongify(self)
            if([self.delegate respondsToSelector:@selector(addShopCartClick:)]){
                [self.delegate addShopCartClick:sender];
            }
        }];
        [self.buyButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            @strongify(self)
            if([self.delegate respondsToSelector:@selector(buyClick:)]){
                [self.delegate buyClick:sender];
            }
        }];
    }
    return self;
}

- (void)createUI{
    CGFloat buttonW = self.width * 0.2 - 8;
    CGFloat buttonH = 50;
    
    self.keepButton = [[SQCustomButton alloc] initWithFrame:CGRectMake(0, 0, buttonW, buttonH) type:SQCustomButtonTopImageType imageSize:CGSizeMake(20, 20) midmargin:3];
    self.keepButton.selecetdTitleStr = @"已收藏";
    self.keepButton.normalTitleStr = @"收藏";
    self.keepButton.titleLabel.font = tFont(12);
    self.keepButton.titleLabel.textColor = rgba(127, 127, 127, 1);
    self.keepButton.selecetedImage = [UIImage imageNamed:@"start2"];
    self.keepButton.normalImage = [UIImage imageNamed:@"start1"];
    [self addSubview:self.keepButton];
    
    self.jumpShopCartButton = [[SQCustomButton alloc] initWithFrame:CGRectMake(buttonW, 0, buttonW, buttonH) type:SQCustomButtonTopImageType imageSize:CGSizeMake(20, 20) midmargin:3];
    self.jumpShopCartButton.titleLabel.text = @"购物车";
    self.jumpShopCartButton.titleLabel.font = tFont(12);
    self.jumpShopCartButton.imageView.image = [UIImage imageNamed:@"shop_cart"];
    self.jumpShopCartButton.titleLabel.textColor = rgba(127, 127, 127, 1);
    [self addSubview:self.jumpShopCartButton];
    
    self.addShopCartButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addShopCartButton setTitle:@"加入购物车" forState:UIControlStateNormal];
    [self.addShopCartButton setTitle:@"已加入购物车" forState:UIControlStateDisabled];
    self.addShopCartButton.titleLabel.font = tFont(15);
    [self.addShopCartButton setTitleColor:rgba(88, 88, 88, 1) forState:UIControlStateNormal];
    [self addSubview:self.addShopCartButton];
    
    self.buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
    self.buyButton.titleLabel.font = tFont(15);
    [self addSubview:self.buyButton];
}

- (void)layoutSubview{
    CGFloat buttonW = self.width * 0.6 * 0.5;
    CGFloat buttonH = 40;
    //右边边距16
    self.addShopCartButton.frame = CGRectMake(self.width * 0.4 - 16, (self.height - buttonH)/2, buttonW, buttonH);
    self.buyButton.frame = CGRectMake(self.addShopCartButton.ly_maxX, self.addShopCartButton.ly_y, buttonW, buttonH);
    
    [[HelpManager sharedHelpManager] setPartRoundWithView:self.addShopCartButton corners:UIRectCornerBottomLeft | UIRectCornerTopLeft cornerRadius:20];
    [[HelpManager sharedHelpManager] setPartRoundWithView:self.buyButton corners:UIRectCornerBottomRight | UIRectCornerTopRight cornerRadius:20];
    
    [self.addShopCartButton setBackgroundImage:[UIImage gradientColorImageFromColors:@[rgba(255, 230, 181, 1),rgba(254, 213, 132, 1)] gradientType:GradientTypeLeftToRight imgSize:self.addShopCartButton.size] forState:UIControlStateNormal];
    [self.buyButton setBackgroundImage:[UIImage gradientColorImageFromColors:MaingradientColor gradientType:GradientTypeLeftToRight imgSize:self.buyButton.size] forState:UIControlStateNormal];
    
     
    
}

@end
