//
//  LWNewsViewController.h
//  FlowerFire
//
//  Created by 李伟 on 2021/1/14.
//  Copyright © 2021 Celery. All rights reserved.
//  新闻

#import "BaseViewController.h"
#import <JXCategoryView/JXCategoryView.h>
#import "AFNetworking.h"
NS_ASSUME_NONNULL_BEGIN

@interface LWNewsViewController : UIViewController<JXCategoryListContentViewDelegate, AFNetworkDelege>
@property(nonatomic, strong) AFNetworkClass *afnetWork; 
@end

NS_ASSUME_NONNULL_END
