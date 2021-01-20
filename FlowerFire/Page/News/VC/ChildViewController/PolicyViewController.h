//
//  PolicyViewController.h
//  FlowerFire
//
//  Created by 李伟 on 2021/1/14.
//  Copyright © 2021 Celery. All rights reserved.
//  政策

#import "BaseViewController.h"
#import <JXCategoryView/JXCategoryView.h>
#import "AFNetworking.h"
NS_ASSUME_NONNULL_BEGIN

@interface PolicyViewController : UIViewController<JXCategoryListContentViewDelegate, AFNetworkDelege>
@property(nonatomic, strong) AFNetworkClass *afnetWork; 
@end

NS_ASSUME_NONNULL_END
