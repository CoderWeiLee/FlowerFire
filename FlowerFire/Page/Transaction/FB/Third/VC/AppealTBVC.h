//
//  AppealTBVC.h
//  FireCoin
//
//  Created by 王涛 on 2019/6/3.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "BaseTableViewController.h"
#import "OrderRecordModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppealTBVC : BaseTableViewController

@property(nonatomic, strong) OrderRecordModel *model;
 
@end

NS_ASSUME_NONNULL_END
