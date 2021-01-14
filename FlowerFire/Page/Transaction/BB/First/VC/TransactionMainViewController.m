//
//  TransactionMainViewController.m
//  FlowerFire
//
//  Created by 王涛 on 2020/5/5.
//  Copyright © 2020 Celery. All rights reserved.
//  交易首页

#import "TransactionMainViewController.h"
#import "WTSegmentedControl.h"
#import "CurrencyTransactionVC.h"
#import "ViewController.h"
#import "FBTransactionViewController.h"

@interface TransactionMainViewController ()
 
@property (nonatomic ,strong) CurrencyTransactionVC         *transactionVC;
//@property (nonatomic ,strong) FBTransactionViewController   *FBVC;
@property (nonatomic ,strong) WTSegmentedControl      *segmentedControl;

@end

@implementation TransactionMainViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.segmentedControl.selectedSegmentIndex = 0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavBar];
    [self createUI];
    [self initData];
}

#pragma mark - action
-(void)segmentSwitch:(WTSegmentedControl *)sender{
    switch (sender.selectedSegmentIndex) {
        case 0:
             
            break;
        default:
        {
            FBTransactionViewController *fb = [FBTransactionViewController new];
            [self.navigationController pushViewController:fb animated:YES];
        }
            break;
    }
}

#pragma mark - initVCProtocol
-(void)createNavBar{
    self.gk_navigationItem.title = LocalizationKey(@"tabbar3");
    return;
    NSArray *itemsStringArray = @[LocalizationKey(@"transactionTip1"),LocalizationKey(@"transactionTip2")];
    
    WTSegmentedControl *segmentedControl = [[WTSegmentedControl alloc] initWithFrame:CGRectMake(self.view.center.x - SEGMENTED_WIDTH, SafeIS_IPHONE_X, itemsStringArray.count * SEGMENTED_WIDTH, SEGMENTED_HEIGHT)];
    [self.gk_navigationBar addSubview:segmentedControl];
    
    for (int i = 0; i<itemsStringArray.count; i++) {
        [segmentedControl insertSegmentWithTitle:itemsStringArray[i] atIndex:i];
        [segmentedControl setWidth:SEGMENTED_WIDTH forSegmentAtIndex:i];
    }
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.selectedSegmentTintColor = MainColor;
    
    [segmentedControl addTarget:self action:@selector(segmentSwitch:) forControlEvents:UIControlEventValueChanged];
    self.segmentedControl = segmentedControl;
}

- (void)createUI{
     [self addChildViewController:self.transactionVC];
     [self.view addSubview:self.transactionVC.view];
}

-(CurrencyTransactionVC *)transactionVC{
    if(!_transactionVC){
        _transactionVC = [CurrencyTransactionVC new];
    }
    return _transactionVC;
}
 
@end
