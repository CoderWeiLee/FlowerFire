//
//  InitViewControllerProtocol.h
//  FilmCrowdfunding
//
//  Created by 王涛 on 2019/11/13.
//  Copyright © 2019 Celery. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol InitViewControllerProtocol <NSObject>

/// 创建ui
-(void)createUI;

/// 设置navbar
-(void)createNavBar;

/// 加载数据
-(void)initData;

@end

NS_ASSUME_NONNULL_END
