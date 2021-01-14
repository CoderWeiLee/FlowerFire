//
//  LeftMenuPageVC.h
//  FireCoin
//
//  Created by 王涛 on 2019/6/5.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "BaseTableViewController.h"
#import "QuotesTradingZoneModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 搜索内容回调

 @param searchStr 搜索的内容
 */
typedef void(^searchBlock)(NSString *searchStr);

@interface LeftMenuPageVC : BaseTableViewController

@property(nonatomic, strong) NSArray *modelArray;

@property(nonatomic, copy) backRefreshBlock backRefreshBlock;
@property(nonatomic, copy) searchBlock searchBlock;
@property(nonatomic, strong)UITextField *searchField;
@end

NS_ASSUME_NONNULL_END
