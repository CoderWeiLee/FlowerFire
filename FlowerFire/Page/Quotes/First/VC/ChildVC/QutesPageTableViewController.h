//
//  QutesPageTableViewController.h
//  FlowerFire
//
//  Created by 王涛 on 2020/4/29.
//  Copyright © 2020 Celery. All rights reserved.
//  行情哪列表视图

#import "BaseTableViewController.h"
#import <JXCategoryView/JXCategoryView.h>
#import "QuotesTransactionPairModel.h"

NS_ASSUME_NONNULL_BEGIN
/**
 排序回调

 @param sortType 排序类型 0 名字排序 1 最新价排序 2涨跌幅排序
 @param sortDirection 排序方向 0默认 1升序 2降序
 */
typedef void(^sortBlock)(int sortType,int sortDirection);

@interface QutesPageTableViewController : BaseTableViewController<JXCategoryListContentViewDelegate>

-(instancetype)initWithDataArray:(NSMutableArray *)dataArray;
 
@property(nonatomic, strong) NSMutableArray *modelArray;
@property(nonatomic, copy) sortBlock sortBlock;

@end 

NS_ASSUME_NONNULL_END
