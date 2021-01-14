//
//  OrderRecordTBVC.h
//  FireCoin
//
//  Created by 王涛 on 2019/5/29.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "BaseTableViewController.h"



NS_ASSUME_NONNULL_BEGIN

@interface OrderRecordTBVC : BaseTableViewController

/**
 请求的参数
 */
@property (nonatomic, strong) NSString *paramsType,  *paramsStatus;
@end

NS_ASSUME_NONNULL_END
