//
//  WalletDetailsListViewController.m
//  531Mall
//
//  Created by 王涛 on 2020/5/20.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "WalletDetailsListViewController.h"
#import "WalletDetailsListCell.h"
#import "WalletDetailsListModel.h"

@interface WalletDetailsListViewController ()

@end

@implementation WalletDetailsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     
    [self createNavBar];
    [self createUI];
    [self initData];
}

- (void)createNavBar{
    self.gk_navigationItem.title = @"钱包明细";
    self.gk_navBackgroundColor = rgba(250, 250, 250, 1);
    self.gk_statusBarStyle = UIStatusBarStyleDefault;
}

- (void)createUI{ 
    self.tableView.frame = CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight - Height_NavBar);
    [self.view addSubview:self.tableView];
    
    [self setMjFresh];
}

#pragma mark - dataSource
- (void)initData{
    NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:5];
    md[@"userid"] = [WTMallUserInfo shareUserInfo].ID;
    md[@"sessionid"] = [WTMallUserInfo shareUserInfo].sessionid;
    md[@"page"] = [NSString stringWithFormat:@"%ld", (long)self.pageIndex];
    md[@"number"] = @"";
    [self.afnetWork jsonMallPostDict:@"/api/finance/banklists" JsonDict:md Tag:@"1" LoadingInView:self.view];
}

- (void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
      
    if(self.isRefresh){
         self.dataArray = [[NSMutableArray alloc]init];
    }
    for (NSDictionary *dic in dict[@"data"][@"lists"]) {
        [self.dataArray addObject:[WalletDetailsListModel yy_modelWithDictionary:dic]];
    }
      
    self.allPages = [dict[@"data"][@"allPage"] integerValue];
    [self.tableView reloadData];
    
}

#pragma mark - tableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    [self.tableView registerClass:[WalletDetailsListCell class] forCellReuseIdentifier:identifier];
    WalletDetailsListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if(self.dataArray.count >0){
        [cell setCellData:self.dataArray[indexPath.row]];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

@end
