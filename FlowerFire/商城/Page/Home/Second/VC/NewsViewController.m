//
//  NewsViewController.m
//  531Mall
//
//  Created by 王涛 on 2020/5/19.
//  Copyright © 2020 Celery. All rights reserved.
//  消息

#import "NewsViewController.h"
#import "NewsCell.h"
#import "BulletinModel.h"

@interface NewsViewController ()

@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self createNavBar];
    [self createUI];
    [self initData];
}

- (void)createNavBar{
    self.gk_statusBarStyle = UIStatusBarStyleDefault;
    self.gk_navigationItem.title = @"消息";
    self.gk_navBackgroundColor = rgba(250, 250, 250, 1);
    
}

- (void)createUI{
    self.view.backgroundColor = self.gk_navBackgroundColor;
    self.tableView.frame = CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight - Height_NavBar);
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.tableView];
    
    [self setMjFresh];
}

- (void)initData{
     NSMutableDictionary *md = [NSMutableDictionary dictionary];
     md[@"userid"] = [WTMallUserInfo shareUserInfo].ID;
     md[@"sessionid"] = [WTMallUserInfo shareUserInfo].sessionid;
     md[@"page"] =  [NSString stringWithFormat:@"%ld", (long)self.pageIndex];
     md[@"number"] = @"";
     //获取公告列表
     [self.afnetWork jsonMallPostDict:@"/api/notice/notice" JsonDict:md Tag:@"1" LoadingInView:self.view];
     
}

#pragma mark - netdate
- (void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    if([type isEqualToString:@"1"]){
        if([dict[@"status"] integerValue] == 1){
            if(self.isRefresh){
                self.dataArray=[[NSMutableArray alloc]init];
            }
            for (NSDictionary *dic in dict[@"data"][@"notices"]) {
                BulletinModel *model = [BulletinModel yy_modelWithDictionary:dic];
                [self.dataArray addObject:model];
            }
             
            self.allPages = [dict[@"data"][@"allPage"] integerValue];
           

        }else{
            printAlert(dict[@"msg"], 1.f);
            
        }
       
    }
    [self.tableView reloadData];
}


#pragma mark - tableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    [self.tableView registerClass:[NewsCell class] forCellReuseIdentifier:identifier];
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.backgroundColor = self.view.backgroundColor;
    if(self.dataArray.count >0){
        BulletinModel *model = self.dataArray[indexPath.row];
        [cell setCellData:model];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

@end
