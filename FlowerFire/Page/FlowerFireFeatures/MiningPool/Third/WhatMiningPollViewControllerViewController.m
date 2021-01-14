//
//  WhatMiningPollViewControllerViewController.m
//  FlowerFire
//
//  Created by 王涛 on 2020/7/14.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "WhatMiningPollViewControllerViewController.h"

@interface WhatMiningPollViewControllerViewController ()

@end

@implementation WhatMiningPollViewControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self createNavBar];
    [self createUI];
    [self initData];
}

- (void)createNavBar{
    self.gk_navigationItem.title = @"矿池";
}

- (void)initData{
}
 
- (void)createUI{
    UIImageView *bac = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img58"]];
    bac.frame = CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight - Height_NavBar);
    bac.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:bac];
}

  
 

@end
