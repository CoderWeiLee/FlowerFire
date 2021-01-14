//
//  ShopDetailsModel.h
//  531Mall
//
//  Created by 王涛 on 2020/6/3.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "GoodsInfoModel.h"
#import "WTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GoodsDetailsHeavyModel : WTBaseModel

@property(nonatomic, copy)NSString *created_time;

@property(nonatomic, copy)NSString *imgs;
/// 图集
@property(nonatomic, copy)NSArray  *imgsArray;
@property(nonatomic, copy)NSString *good_id;
@property(nonatomic, copy)NSString *updated_time;
/// 详情
@property(nonatomic, copy)NSString *desc;


@end

/// 商品属性
@interface GoodsDetailsAttrsModel : WTBaseModel
 
@property(nonatomic, copy)NSString *name;
@property(nonatomic, copy)NSString *value;


@end

@interface GoodsDetailsModel : GoodsInfoModel

@property(nonatomic, copy)NSString *first_price;
/// 是否收藏，1为收藏，0为未收藏
@property(nonatomic, assign)NSInteger is_collect;
/// 是否加入购物车，1为加入，0为未加入
@property(nonatomic, assign)NSInteger is_cart;

@property(nonatomic, strong)GoodsDetailsHeavyModel            *heavy;
@property(nonatomic, strong)NSArray<GoodsDetailsAttrsModel *> *attrs;
@end



NS_ASSUME_NONNULL_END
