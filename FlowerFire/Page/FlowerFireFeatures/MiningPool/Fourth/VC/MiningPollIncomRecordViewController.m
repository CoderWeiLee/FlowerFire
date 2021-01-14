//
//  MiningPollIncomRecordViewController.m
//  FlowerFire
//
//  Created by 王涛 on 2020/9/10.
//  Copyright © 2020 Celery. All rights reserved.
//  收益记录

#import "MiningPollIncomRecordViewController.h"
#import "FFBuyRecordCell.h"
#import "FFBuyRecordHidtoryRecordModel.h" 

@interface MiningPollIncomRecordViewController ()

@end

@implementation MiningPollIncomRecordViewController
  
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavBar];
    [self createUI];
    [self initData];
}

- (void)createNavBar{
    self.gk_navigationItem.title = LocalizationKey(@"578Tip167");
}
- (void)createUI{
    self.tableView.frame = CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight - Height_NavBar);
    [self.view addSubview:self.tableView];
    self.tableView.rowHeight = 70;
    [self setMjFresh];
}
- (void)initData{
    [self.afnetWork jsonGetDict:@"/api/bonus/records" JsonDict:nil Tag:@"1"];
}
#pragma mark - netdate
- (void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    if([type isEqualToString:@"1"]){
        if(self.isRefresh){
            self.dataArray=[[NSMutableArray alloc]init];
        }
         
        for (NSDictionary *dic in dict[@"data"][@"list"]) {
            FFBuyRecordHidtoryRecordModel *model = [FFBuyRecordHidtoryRecordModel yy_modelWithDictionary:dic];
            [self.dataArray addObject:model];
        }
        self.allPages = [dict[@"data"][@"allPage"] integerValue];
    }
    [self.tableView reloadData];
}
#pragma mark - tableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell1";
    [self.tableView registerClass:[FFBuyRecordCell class] forCellReuseIdentifier:identifier];
    FFBuyRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    if(self.dataArray.count>0){
        //120:持有收益,121:推广收益
        // 120:质押收益,121:推广收益 122 链接算力 123 团队算力 124 超级节点收益
        FFBuyRecordHidtoryRecordModel *model = self.dataArray[indexPath.row];
        if([model.type isEqualToString:@"120"]){
            cell.topLabel.text = LocalizationKey(@"578NOW1");
        }else if([model.type isEqualToString:@"121"]){
            cell.topLabel.text = LocalizationKey(@"578NOW2");
        }else if([model.type isEqualToString:@"122"]){
            cell.topLabel.text = LocalizationKey(@"578NOW3");
        }else if([model.type isEqualToString:@"123"]){
            cell.topLabel.text = LocalizationKey(@"578NOW4");
        }else if([model.type isEqualToString:@"124"]){
            cell.topLabel.text = LocalizationKey(@"578NOW5");
        }
        cell.bottomLabel.text = [HelpManager getTimeStr:NSStringFormat(@"%@",model.createtime) dataFormat:@"yyyy-MM-dd HH:mm:ss"];
        cell.centerLabel.text = NSStringFormat(@"%@SD",model.money);
    }
    return cell;
}
@end

