//
//  MyOrderViewController.h
//  531Mall
//
//  Created by 王涛 on 2020/5/21.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "BaseViewController.h"
#import <JXCategoryView.h>
#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyOrderViewController : BaseViewController

@end

typedef enum : NSUInteger {
    MyOrderTypeAll = 0, //全部订单
    MyOrderTypeWaitPay, //待支付
    MyOrderTypeWaitShip, //待发货
    MyOrderTypeShipped, //已发货
    MyOrderTypeOver,    //已完成
} MyOrderType;

@interface MyOrderChildViewController : BaseTableViewController<JXCategoryListContentViewDelegate>

-(instancetype)initWithMyOrderType:(MyOrderType)type;

@end

@interface JXGradientView : UIView

@property (nonatomic, strong, readonly) CAGradientLayer *gradientLayer;

@end

NS_ASSUME_NONNULL_END
