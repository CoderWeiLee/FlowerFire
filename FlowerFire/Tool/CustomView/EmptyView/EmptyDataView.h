//
//  EmptyDataView.h
//  BaseDevelopmentFramework
//
//  Created by 王涛 on 2019/11/7.
//  Copyright © 2019 Celery. All rights reserved.
//

#import <LYEmptyView/LYEmptyView.h>

NS_ASSUME_NONNULL_BEGIN

@interface EmptyDataView : LYEmptyView

+ (instancetype)diyNoDataEmpty;

+ (instancetype)diyNoNetworkEmptyWithTarget:(id)target action:(SEL)action;

+ (instancetype)diyCustomEmptyViewWithTarget:(id)target action:(SEL)action;

@end

NS_ASSUME_NONNULL_END
