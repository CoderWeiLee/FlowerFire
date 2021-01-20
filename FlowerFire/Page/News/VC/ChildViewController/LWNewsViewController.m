//
//  LWNewsViewController.m
//  FlowerFire
//
//  Created by 李伟 on 2021/1/14.
//  Copyright © 2021 Celery. All rights reserved.
//  新闻

#import "LWNewsViewController.h"

@interface LWNewsViewController ()

@end

@implementation LWNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
}

#pragma mark - JXCategoryListContentViewDelegate
// 返回列表视图
// 如果列表是 VC，就返回 VC.view
// 如果列表是 View，就返回 View 自己
- (UIView *)listView {
    return self.view;
}


@end
