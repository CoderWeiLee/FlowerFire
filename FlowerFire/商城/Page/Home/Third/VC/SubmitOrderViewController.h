//
//  SubmitOrderViewController.h
//  531Mall
//
//  Created by 王涛 on 2020/5/23.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    SubmitOrderWereJumpBuy,     //从立即抢购过来
    SubmitOrderWereJumpShopCart, //从购物车跳转过来
} SubmitOrderWereJump;

@interface SubmitOrderViewController : BaseTableViewController

-(instancetype)initWithSubmitOrderWereJump:(SubmitOrderWereJump  )submitOrderWereJump ;
 
//从立即抢购过来 需要传值
@property(nonatomic, strong)NSString *skuID;
@property(nonatomic, strong)NSString *amount;


@end

NS_ASSUME_NONNULL_END
