//
//  RaiseMainViewController.h
//  FlowerFire
//
//  Created by 王涛 on 2020/7/14.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseTableViewController.h"
#import <JXCategoryView.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    RaiseTypeUnderReview = 0, //审核中
    RaiseTypeWait,
    RaiseTypeActivite,
    RaiseTypeEnd
} RaiseType;

@interface RaiseMainViewController : BaseViewController


@end

@interface RaiseChildViewController : BaseTableViewController<JXCategoryListContentViewDelegate> 

-(instancetype)initWithRaiseType:(RaiseType)type;

@end

NS_ASSUME_NONNULL_END
