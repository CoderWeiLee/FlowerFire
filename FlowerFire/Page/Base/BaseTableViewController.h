//
//  BaseTableViewController.h
//  FireCoin
//
//  Created by 赵馨 on 2019/5/27.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "BaseViewController.h" 
#import "WTTableView.h"
#import "TableViewFreshProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseTableViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,TableViewFreshProtocol>


@property (nonatomic, strong)WTTableView *tableView;
@property (nonatomic, assign)NSInteger   pageIndex,allPages;
@property (nonatomic, assign)BOOL        isRefresh; 

/// 只设置下拉刷新 不设置加载
-(void)setOnlyReFresh;


@end

NS_ASSUME_NONNULL_END
