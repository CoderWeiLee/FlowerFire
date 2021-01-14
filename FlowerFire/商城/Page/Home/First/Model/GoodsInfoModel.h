//
//  GoodsInfoModel.h
//  531Mall
//
//  Created by 王涛 on 2020/6/3.
//  Copyright © 2020 Celery. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GoodsInfoModel : WTBaseModel

@property(nonatomic, copy)NSString *brand_id;
/// 所属分类id
@property(nonatomic, copy)NSString *cate_id;
@property(nonatomic, copy)NSString *cate_ids;
@property(nonatomic, copy)NSString *comment_amount;
@property(nonatomic, copy)NSString *created_time;
@property(nonatomic, copy)NSString *GoodsId; //商品ID
@property(nonatomic, copy)NSString *is_hot;
@property(nonatomic, copy)NSString *is_new;
@property(nonatomic, copy)NSString *is_recommend;
@property(nonatomic, copy)NSString *is_sale;
@property(nonatomic, copy)NSString *is_spec;
/// 商品图片
@property(nonatomic, copy)NSString *main_img;
@property(nonatomic, copy)NSString *name;
@property(nonatomic, copy)NSString *product_no;
/// 销售数量
@property(nonatomic, copy)NSString *sale_amount;
/// 销售价格
@property(nonatomic, copy)NSString *second_price;
/// 销售价格(代金券)，是现金和代金券同时支付
@property(nonatomic, copy)NSString *three_price;
@property(nonatomic, copy)NSString *sku_id;
@property(nonatomic, copy)NSString *sort;
@property(nonatomic, copy)NSString *state;
/// 总库存
@property(nonatomic, copy)NSString *total_stock;
@property(nonatomic, copy)NSString *type;
@property(nonatomic, copy)NSString *unit;
@property(nonatomic, copy)NSString *updated_time;
@property(nonatomic, copy)NSString *visit_amount;
 
@end

NS_ASSUME_NONNULL_END
