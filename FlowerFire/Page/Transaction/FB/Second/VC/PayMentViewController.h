//
//  PayMentViewController.h
//  FireCoin
//
//  Created by 王涛 on 2019/5/29.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PayMentViewController : BaseTableViewController

/**
 我要买 参数用1
 我要卖 参数用0
 */
@property(nonatomic, strong) NSString *buyOrSeal;
@property(nonatomic, strong) NSString *otcOrderId; //订单id

@end

NS_ASSUME_NONNULL_END
