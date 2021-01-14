//
//  kyc1PopView.h
//  FlowerFire
//
//  Created by 王涛 on 2020/5/12.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "BaseUIView.h"

NS_ASSUME_NONNULL_BEGIN

@interface Kyc1PopView : BaseUIView

@property(nonatomic, copy)dispatch_block_t dissmissPopBlock;
@property(nonatomic, copy)dispatch_block_t jumpKycVCBlock;
@end

NS_ASSUME_NONNULL_END
