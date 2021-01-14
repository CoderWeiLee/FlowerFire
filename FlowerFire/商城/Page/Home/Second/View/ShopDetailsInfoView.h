//
//  ShopDetailsInfoView.h
//  531Mall
//
//  Created by 王涛 on 2020/5/22.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "BaseUIView.h"
#import "GoodsDetailsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ShopDetailsInfoView : BaseUIView

@property(nonatomic, strong)UIImageView *shopDetailsTipImageView;

-(void)setDetailsInfoViewData:(GoodsDetailsModel *)model;

@end

NS_ASSUME_NONNULL_END
