//
//  ChooseProvinceViewController.m
//  FilmCrowdfunding
//
//  Created by 王涛 on 2019/11/25.
//  Copyright © 2019 Celery. All rights reserved.
//

#import "ChooseProvinceViewController.h"
#import "ChooseCityViewController.h"

@interface ChooseProvinceViewController ()

@end

@implementation ChooseProvinceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self createNavBar];
    [self createUI];
    [self initData];
}

- (void)createNavBar{
    self.gk_statusBarStyle = UIStatusBarStyleDefault;
    self.gk_navigationItem.title = @"选择省份";
}

- (void)createUI{
    self.tableView.frame = CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight - Height_NavBar);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self setOnlyReFresh];
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [UIView new];
}

- (void)initData{
    //获取省
    [self.afnetWork jsonMallPostDict:@"/api/Webmember/getProvince" JsonDict:nil Tag:@"1" LoadingInView:self.view];
}

#pragma mark - netData
- (void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    if([type isEqualToString:@"1"]){
        [self.tableView.mj_header endRefreshing];
        self.dataArray = [NSMutableArray array];
        if([dict[@"status"] integerValue] == 1){
            self.dataArray = [NSMutableArray arrayWithArray:dict[@"data"][@"province"]]; 
        }
    }
    [self.tableView reloadData];
}

#pragma mark - tableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if(self.dataArray.count>0){
        cell.textLabel.text = self.dataArray[indexPath.row][@"name"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.dataArray.count>0){
        ChooseCityViewController *vc = [ChooseCityViewController new];
        vc.provinceId = self.dataArray[indexPath.row][@"id"];
        vc.provinceName = self.dataArray[indexPath.row][@"name"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

@end
