//
//  FFBuyRecordViewController.h
//  FlowerFire
//
//  Created by 王涛 on 2020/8/25.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    FFBuyRecordTypeCommission = 0, //委托
    FFBuyRecordTypeOrderRecord, //订单
    FFBuyRecordTypeHidtoryRecord, //账单
    suo,//锁仓
} FFBuyRecordType;

@interface FFBuyRecordViewController : BaseTableViewController

-(instancetype)initWithFFBuyRecordType:(FFBuyRecordType)FFBuyRecordType;

@end

NS_ASSUME_NONNULL_END
