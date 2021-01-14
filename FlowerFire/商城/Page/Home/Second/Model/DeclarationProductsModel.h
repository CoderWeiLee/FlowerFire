//
//  DeclarationProductsModel.h
//  531Mall
//
//  Created by 王涛 on 2020/6/12.
//  Copyright © 2020 Celery. All rights reserved.
//  报单产品模型

#import "WTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DeclarationProductsGoodsModel : WTBaseModel

@property(nonatomic, copy)NSString *amount;
@property(nonatomic, copy)NSString *good_id;
@property(nonatomic, copy)NSString *good_name;
@property(nonatomic, assign)BOOL    isShowLeftText;

@end

@interface DeclarationProductsModel : WTBaseModel

@property(nonatomic, copy)NSString *name;
@property(nonatomic, copy)NSString *productsID;
@property(nonatomic, strong)NSArray<DeclarationProductsGoodsModel *>  *goods;

@end

NS_ASSUME_NONNULL_END
