//
//  QutesChildChooseViewController.h
//  FlowerFire
//
//  Created by 王涛 on 2020/4/29.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "BaseViewController.h"
#import "QuotesChildVCFactory.h"
#import "QuotesTransactionPairModel.h"
#import "WTTableView.h"


NS_ASSUME_NONNULL_BEGIN
 
@interface QutesChildChooseViewController : QuotesChildVCFactory

@property(nonatomic, strong)NSMutableArray  *modelArray;
/// 存一份排序前的数组,这样不排序时候刷新快,不用等到轮训后再刷新
@property(nonatomic, strong)NSArray<QuotesTransactionPairModel *> *sortAfterModelArray;
@property(nonatomic, strong)WTTableView  *tableView;

@end

NS_ASSUME_NONNULL_END
