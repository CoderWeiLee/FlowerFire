//
//  TableViewFreshProtocol.h
//  FilmCrowdfunding
//
//  Created by 王涛 on 2019/11/13.
//  Copyright © 2019 Celery. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TableViewFreshProtocol <NSObject>

/// 设置刷新
- (void)setMjFresh;
/// 下拉刷新
- (void)downFreshloadData;
/// 上拉加载
- (void)upFreshLoadMoreData;

@end

NS_ASSUME_NONNULL_END
