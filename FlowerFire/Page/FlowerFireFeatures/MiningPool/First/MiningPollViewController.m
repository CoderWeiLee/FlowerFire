//
//  MiningPollViewController.m
//  FlowerFire
//
//  Created by 王涛 on 2020/7/14.
//  Copyright © 2020 Celery. All rights reserved.
//  矿池

#import "MiningPollViewController.h"
#import "MiningPollCell.h"
#import "MiningPollIncomeViewController.h"

@interface MiningPollViewController ()

@end

@implementation MiningPollViewController

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
    self.dataArray = @[@"XRP",@"EOS",@"LTC",@"ETH",@"BTC"];
}
 
- (void)createUI{
    self.tableView.frame = CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight - Height_NavBar);
    [self.view addSubview:self.tableView];
    self.view.backgroundColor = KGrayBacColor;
    self.tableView.backgroundColor = self.view.backgroundColor;
}

#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MiningPollIncomeViewController *m = [MiningPollIncomeViewController new];
    m.coinName = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:m animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    [self.tableView registerClass:[MiningPollCell class] forCellReuseIdentifier:identifier];
    MiningPollCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if(self.dataArray.count>0){
        [cell setCellData:self.dataArray[indexPath.row]];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 160;
}

@end
