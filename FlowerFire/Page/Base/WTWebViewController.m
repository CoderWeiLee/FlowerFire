//
//  WTWebViewController.m
//  FireCoin
//
//  Created by 王涛 on 2019/7/16.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "WTWebViewController.h"

@interface WTWebViewController ()

@end

@implementation WTWebViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
     self.gk_navigationBar.hidden = NO; 

 //  self.tabBarController.tabBar.hidden = YES;
 //   self.progressTintColor = rgba(34, 129, 205, 1) ; 
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
     
    self.webView.frame = CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight - Height_NavBar); 
}

- (void)dealloc
{
    NSLog(@"%@ dealloc了",[self className]);
}

- (void)viewDidLoad {
    [super viewDidLoad];
     
}
 
- (void)didFailLoadWithError:(NSError *)error{
    [super didFailLoadWithError:error];
    NSLog(@"%@", error.localizedDescription);
    NSLog(@"%@", error.localizedRecoverySuggestion);
    NSLog(@"%@", error.localizedFailureReason);
    NSLog(@"%@", error.localizedRecoveryOptions);
}


@end
