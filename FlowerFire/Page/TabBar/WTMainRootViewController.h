//
//  WTMainRootViewController.h
//  BaseDevelopmentFramework
//
//  Created by 王涛 on 2019/11/6.
//  Copyright © 2019 Celery. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"
#import <CYLTabBarController/CYLTabBarController.h>
 
NS_ASSUME_NONNULL_BEGIN

@interface WTMainRootViewController : UINavigationController

- (CYLTabBarController *)createNewTabBarWithContext:(NSString *__nullable)context;


@end

NS_ASSUME_NONNULL_END
