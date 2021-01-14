//
//  WithrdawViewController.h
//  531Mall
//
//  Created by 王涛 on 2020/5/20.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "BaseViewController.h"
#import "RechargeViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface WithrdawViewController : RechargeViewController

@property(nonatomic, copy)dispatch_block_t backFreshBlock;

@end

NS_ASSUME_NONNULL_END
