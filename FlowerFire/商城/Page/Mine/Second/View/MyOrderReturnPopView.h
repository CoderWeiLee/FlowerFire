//
//  MyOrderReturnPopView.h
//  531Mall
//
//  Created by 王涛 on 2020/5/21.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "BaseUIView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^returnGoodsBlock)(NSString *returnReason);

@interface MyOrderReturnPopView : BaseUIView

@property(nonatomic, copy)dispatch_block_t closePopViewBlock;
/// 退货回调
 @property(nonatomic, copy)returnGoodsBlock returnGoodsBlock;
 


@end

NS_ASSUME_NONNULL_END
