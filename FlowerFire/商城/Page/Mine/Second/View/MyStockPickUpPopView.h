//
//  MyStockPickUpPopView.h
//  531Mall
//
//  Created by 王涛 on 2020/5/21.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "BaseUIView.h"
#import "MyStockModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyStockPickUpPopView : BaseUIView

-(instancetype)initWithFrame:(CGRect)frame  stockInfoArray:(NSArray<MyStockSkuInfoModel *> *)stockInfoArray;

@property(nonatomic, strong)UIViewController *currentVC;
@property(nonatomic, copy)dispatch_block_t    closePopViewBlock;
@property(nonatomic, copy)dispatch_block_t    backFreshBlock;

@end

NS_ASSUME_NONNULL_END
