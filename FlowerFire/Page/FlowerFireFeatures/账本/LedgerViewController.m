//
//  LedgerViewController.m
//  FlowerFire
//
//  Created by 王涛 on 2020/7/14.
//  Copyright © 2020 Celery. All rights reserved.
//。账本

#import "LedgerViewController.h"
#import "LedgerCell.h"

@interface LedgerViewController ()

@end

@implementation LedgerViewController

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
- (void)theme_didChanged{
     self.gk_navLineHidden = NO;
}

- (void)createNavBar{
    self.gk_navigationItem.title = LocalizationKey(@"LedgerTip1");
     
}

- (void)createUI{
    self.tableView.frame = CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight - Height_NavBar);
 
    [self.view addSubview:self.tableView];
     
}

- (void)initData{
    self.dataArray = @[@1,];
}

#pragma mark - tableViewDegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"LedgerCell";
    [self.tableView registerClass:[LedgerCell class] forCellReuseIdentifier:identifier];
    LedgerCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

@end
