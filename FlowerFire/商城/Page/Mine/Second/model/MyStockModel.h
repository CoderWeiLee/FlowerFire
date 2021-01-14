//
//  MyStockModel.h
//  531Mall
//
//  Created by 王涛 on 2020/6/12.
//  Copyright © 2020 Celery. All rights reserved.
//  我的库存

#import "WTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyStockSkuInfoModel : WTBaseModel

@property(nonatomic, copy)NSString *skuInfoID;
@property(nonatomic, copy)NSString *name;
@property(nonatomic, copy)NSString *stock;

@end

@interface MyStockSkuListModel : WTBaseModel

@property(nonatomic, copy)NSString *created_time;
@property(nonatomic, copy)NSString *skuListID;
@property(nonatomic, copy)NSString *name;
/// 来源
@property(nonatomic, copy)NSString *reason;
@property(nonatomic, copy)NSString *stock;
@property(nonatomic, copy)NSString *type;

@end

@interface MyStockModel : WTBaseModel

@property(nonatomic, strong)NSArray<MyStockSkuInfoModel *> *sku_info;
@property(nonatomic, strong)NSArray<MyStockSkuListModel *> *sku_list;

@end

NS_ASSUME_NONNULL_END
