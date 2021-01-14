//
//  ShopDetailsBuyPopView.h
//  531Mall
//
//  Created by 王涛 on 2020/5/23.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "BaseUIView.h"
#import "GoodsDetailsModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^chooseNumBlock)(NSString *num);

@interface ShopDetailsBuyPopView : BaseUIView
 
-(instancetype)initWithFrame:(CGRect)frame GoodsDetailsModel:(GoodsDetailsModel *)model;

@property(nonatomic, copy)chooseNumBlock buyClickBlock;

@end

NS_ASSUME_NONNULL_END
