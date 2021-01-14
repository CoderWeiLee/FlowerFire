//
//  RedEnvelopeRecordViewController.m
//  FlowerFire
//
//  Created by 王涛 on 2020/7/14.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "RedEnvelopeRecordViewController.h"

@interface RedEnvelopeRecordViewController ()

@end

@implementation RedEnvelopeRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self createNavBar];
    [self createUI];
    [self initData];
}

#pragma mark - action 
- (void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    if([type isEqualToString:@"1"]){
         
    }else{
        printAlert(dict[@"msg"], 1.f);
        [self closeVC];
    }
}

#pragma mark - initViewDelegate
- (void)createNavBar{
    self.gk_navigationItem.title = LocalizationKey(@"RedEnvelopeTip9");
     
}

- (void)createUI{
    self.tableView.frame = CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight - Height_NavBar);
 
    [self.view addSubview:self.tableView];
     
    
}

 

@end
