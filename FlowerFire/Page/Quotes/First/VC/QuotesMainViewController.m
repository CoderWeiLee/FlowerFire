//
//  QuotesMainViewController.m
//  FlowerFire
//
//  Created by 王涛 on 2020/4/29.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "QuotesMainViewController.h"
#import "WTSegmentedControl.h"
#import "QuotesChildVCFactory.h"

@interface QuotesMainViewController ()
{
    WTSegmentedControl *_segmentedControl;
}
@property(nonatomic, strong)QuotesChildVCFactory *qutesAllVC;
@property(nonatomic, strong)QuotesChildVCFactory *qutesChooseVC;
@property (nonatomic ,strong) UIViewController   *currentVC;
@end

@implementation QuotesMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self createNavBar];
    [self createUI];
    [self initData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChooseCustomSymbol) name:ChooseCustomSymbol object:nil];
}

-(void)ChooseCustomSymbol{
    _segmentedControl.selectedSegmentIndex = 1;
}

#pragma mark - action
-(void)segmentSwitch:(WTSegmentedControl *)sender{
    switch (sender.selectedSegmentIndex) {
        case 0:
            [self replaceController:self.currentVC newController:self.qutesChooseVC];
            break;
        default:
            [self replaceController:self.currentVC newController:self.qutesAllVC];
            break;
    }
}

//  切换各个标签内容
- (void)replaceController:(UIViewController *)oldController newController:(UIViewController *)newController
{
    [self addChildViewController:newController];
    [self transitionFromViewController:oldController toViewController:newController duration:0.2f options:UIViewAnimationOptionTransitionNone animations:nil completion:^(BOOL finished) {
        if(finished){
            [newController didMoveToParentViewController:self];
            [oldController willMoveToParentViewController:nil];
            [oldController removeFromParentViewController];
            self.currentVC = newController;
        }else{
            self.currentVC = oldController;
        }
    }];
    
}

#pragma mark - initVCProtocol
-(void)createNavBar{
    self.gk_navigationItem.title = LocalizationKey(@"tabbar2");
    return;
    NSArray *itemsStringArray = @[LocalizationKey(@"quotesTip1"),LocalizationKey(@"quotesTip2")];
    
    _segmentedControl = [[WTSegmentedControl alloc] initWithFrame:CGRectMake(self.view.center.x - SEGMENTED_WIDTH, SafeIS_IPHONE_X, itemsStringArray.count * SEGMENTED_WIDTH, SEGMENTED_HEIGHT)];
    [self.gk_navigationBar addSubview:_segmentedControl];
    
    for (int i = 0; i<itemsStringArray.count; i++) {
        [_segmentedControl insertSegmentWithTitle:itemsStringArray[i] atIndex:i];
        [_segmentedControl setWidth:SEGMENTED_WIDTH forSegmentAtIndex:i];
    }
    //行情：去掉“自选/全部”，去掉“USDT”
    _segmentedControl.selectedSegmentIndex = 1;
    _segmentedControl.selectedSegmentTintColor = MainColor;
    _segmentedControl.hidden = YES;
    [_segmentedControl addTarget:self action:@selector(segmentSwitch:) forControlEvents:UIControlEventValueChanged];
}

- (void)createUI{
    [self addChildViewController:self.qutesAllVC];
    [self.view addSubview:self.qutesAllVC.view];
//    [self addChildViewController:self.qutesChooseVC];
//    [self.view addSubview:self.qutesChooseVC.view];
//    self.currentVC = self.qutesChooseVC;
}

-(QuotesChildVCFactory *)qutesChooseVC{
    if(!_qutesChooseVC){
        _qutesChooseVC = [[QuotesChildVCFactory alloc] initWithQutesType:quotesChildTypeChoose];
        _qutesChooseVC.view.frame = CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight-  Height_NavBar);
    }
    return _qutesChooseVC;
}

-(QuotesChildVCFactory *)qutesAllVC{
    if(!_qutesAllVC){
        _qutesAllVC = [[QuotesChildVCFactory alloc] initWithQutesType:quotesChildTypeAll];
        _qutesAllVC.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight- Height_TabBar - Height_NavBar);
    }
    return _qutesAllVC;
}

@end
