//
//  BaseNavigationController.m
//  FireCoin
//
//  Created by 王涛 on 2019/8/22.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
     
}

//
//// 渐变导航栏
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGFloat contentY = scrollView.contentOffset.y;
//
//    if (contentY <= 0) {
//        self.gk_navBarAlpha = 0;
//        return;
//    }
//
//    // 渐变区间 (0 - 80)
//    if (contentY > 0 && contentY < Height_NavBar) {
//        CGFloat alpha = contentY / (Height_NavBar - 0);
//
//        self.gk_navBarAlpha = alpha;
//        self.gk_backStyle = GKNavigationBarBackStyleWhite;
//    }else {
//        self.gk_navBarAlpha = 1.0;
//
//        self.gk_backStyle = GKNavigationBarBackStyleBlack;
//    }
//}
 
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count >= 1) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}



@end
