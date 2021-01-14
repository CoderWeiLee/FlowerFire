//
//  RedEnvelopeViewController.m
//  FlowerFire
//
//  Created by 王涛 on 2020/7/14.
//  Copyright © 2020 Celery. All rights reserved.
//。红包首页

#import "RedEnvelopeViewController.h"
#import "CreateRedEnvelopeViewController.h"

@interface RedEnvelopeViewController ()

@end

@implementation RedEnvelopeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavBar];
    [self createUI];
    [self initData];
}

- (void)createNavBar{
    self.gk_navigationItem.title = @"红包";
    self.gk_navBarAlpha = 0;
    self.gk_backStyle = GKNavigationBarBackStyleWhite;
    self.gk_navTitleColor = KWhiteColor;
    
}

- (void)initData{
    
}
 
- (void)createUI{
    UIImageView *bac = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img38"]];
    bac.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight );
    bac.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:bac];
    
    WTButton *invitedButton = [[WTButton alloc] initWithFrame:CGRectMake(50, self.view.centerY + 20, ScreenWidth - 50 * 2, 45) titleStr:@"邀请好友" titleFont:tFont(16) titleColor:RGB(253, 83, 97) parentView:self.view];
    invitedButton.backgroundColor = RGB(253, 226, 173);
    invitedButton.layer.cornerRadius = 22.5;
    
    WTButton *button2 = [[WTButton alloc] initWithFrame:CGRectMake(50, invitedButton.bottom + 20, ScreenWidth - 50 * 2, 45) titleStr:@"主题红包" titleFont:tFont(16) titleColor:RGB(253, 83, 97) parentView:self.view];
    button2.backgroundColor = RGB(253, 226, 173);
    button2.layer.cornerRadius = 22.5;
    
    WTButton *button3 = [[WTButton alloc] initWithFrame:CGRectMake(50, button2.bottom + 20, ScreenWidth - 50 * 2, 45) titleStr:@"APP下载" titleFont:tFont(16) titleColor:KWhiteColor parentView:self.view];
    button3.backgroundColor = RGB(37, 43, 69);
    button3.layer.cornerRadius = 22.5;
    
    @weakify(self)
    [invitedButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        @strongify(self)
        CreateRedEnvelopeViewController *cvc = [CreateRedEnvelopeViewController new];
        [self.navigationController pushViewController:cvc animated:YES];
    }];
     
    [button2 addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        @strongify(self)
        CreateRedEnvelopeViewController *cvc = [CreateRedEnvelopeViewController new];
        [self.navigationController pushViewController:cvc animated:YES];
    }];
}

 

@end
