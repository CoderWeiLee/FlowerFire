//
//  ShopDetailsToolBarView.h
//  531Mall
//
//  Created by 王涛 on 2020/5/23.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "BaseUIView.h"
#import "SQCustomButton.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ShopDetailsToolBarViewDelegate <NSObject>

-(void)keepClick:(SQCustomButton *)button;
-(void)jumpShopCartClick:(SQCustomButton *)button;
 
-(void)addShopCartClick:(UIButton *)button;
-(void)buyClick:(UIButton *)button;

@end

@interface ShopDetailsToolBarView : BaseUIView

@property(nonatomic, strong)SQCustomButton *keepButton;
@property(nonatomic, strong)SQCustomButton *jumpShopCartButton;

@property(nonatomic, strong)UIButton       *addShopCartButton;
@property(nonatomic, strong)UIButton       *buyButton;
@property(nonatomic, weak)id<ShopDetailsToolBarViewDelegate>       delegate;

@end

NS_ASSUME_NONNULL_END
