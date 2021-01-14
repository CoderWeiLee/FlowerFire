//
//  MyKeepViewController.m
//  531Mall
//
//  Created by 王涛 on 2020/5/19.
//  Copyright © 2020 Celery. All rights reserved.
//  我的收藏

#import "MyKeepViewController.h"
#import "MyKeepTableViewCell.h"
#import "MyKeepModel.h"
#import "ShopDetailsViewController.h"

@interface MyKeepViewController ()

@end

@implementation MyKeepViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavBar];
    [self createUI]; 
    
    //禁止全屏幕饭回
    self.gk_fullScreenPopDisabled = YES;
}

- (void)createNavBar{
    self.gk_statusBarStyle = UIStatusBarStyleDefault;
    self.gk_navigationItem.title = @"我的收藏";
    self.gk_navBackgroundColor = rgba(250, 250, 250, 1);
}

- (void)createUI{
    self.tableView.frame = CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight - Height_NavBar);
    [self.view addSubview:self.tableView];
    [self setMjFresh];
    
}

#pragma mark - netData
- (void)initData{
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    md[@"userid"] = [WTMallUserInfo shareUserInfo].ID;
    md[@"sessionid"] = [WTMallUserInfo shareUserInfo].sessionid;
    md[@"page"] =  [NSString stringWithFormat:@"%ld", (long)self.pageIndex];
    md[@"number"] = @"";
    //获取收藏列表
    [self.afnetWork jsonMallPostDict:@"/api/goods/collectLists" JsonDict:md Tag:@"1" LoadingInView:self.view];
}

- (void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    if([type isEqualToString:@"1"]){
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if(self.isRefresh){
             self.dataArray=[[NSMutableArray alloc]init];
        }
        for (NSDictionary *dic in dict[@"data"][@"infos"]) {
            [self.dataArray addObject:[MyKeepModel yy_modelWithDictionary:dic]];
        }
          
        self.allPages = [dict[@"data"][@"allPage"] integerValue];
        [self.tableView reloadData];
    }else{//删除收藏
        [self.tableView.mj_header beginRefreshing];
    }
}

#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.dataArray>0){
        MyKeepModel *model = self.dataArray[indexPath.row];
        ShopDetailsViewController *s = [[ShopDetailsViewController alloc] initWithGoodsID:model.good_id];
        [self.navigationController pushViewController:s animated:YES];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     static NSString *identifier = @"cell";
     [self.tableView registerClass:[MyKeepTableViewCell class] forCellReuseIdentifier:identifier];
     MyKeepTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if(self.dataArray.count>0){
        [cell setCellData:self.dataArray[indexPath.row]];
    }
     return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
 
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        MyKeepModel *model = self.dataArray[indexPath.row];
        NSMutableDictionary *md = [NSMutableDictionary dictionary];
        md[@"userid"] = [WTMallUserInfo shareUserInfo].ID;
        md[@"sessionid"] = [WTMallUserInfo shareUserInfo].sessionid;
        md[@"id"] = model.good_id;
        md[@"sku_id"] = @""; //商品库存ID（用于区分多规格），不填为默认规格
        [self.afnetWork jsonMallPostDict:@"/api/goods/cancelCollect" JsonDict:md Tag:@"2" LoadingInView:self.view];
    }];
  
    return @[deleteAction];
}

@end
