//
//  MyTeamViewController.h
//  531Mall
//
//  Created by 王涛 on 2020/5/20.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "BaseViewController.h"
#import <JXCategoryView/JXCategoryView.h>
#import "GKPageScrollView.h"
#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyTeamViewController : BaseViewController

@end

typedef NS_ENUM(NSUInteger, MyTeamChildViewType) {
    MyTeamChildViewRecommend = 0, //推荐
    MyTeamChildViewTotalDelegate,  //总代
};

@interface MyTeamChildViewController : BaseTableViewController<GKPageListViewDelegate>

-(instancetype)initWithMyTeamChildViewType:(MyTeamChildViewType )type;

@end



NS_ASSUME_NONNULL_END
