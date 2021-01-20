//
//HeadlinesViewController.h
//  FlowerFire
//
//  Created by 李伟 on 2021/1/14.
//  Copyright © 2021 Celery. All rights reserved.
//  快讯

#import "BaseTableViewController.h"
#import <JXCategoryView/JXCategoryView.h>
#import "AFNetworking.h"
NS_ASSUME_NONNULL_BEGIN

@interface HeadlinesViewController : UIViewController<JXCategoryListContentViewDelegate, AFNetworkDelege>
@property(nonatomic, strong) AFNetworkClass *afnetWork; 
@end

NS_ASSUME_NONNULL_END
