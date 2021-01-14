//
//  AccountsReceivableSettingTBVC.m
//  FireCoin
//
//  Created by 王涛 on 2019/5/31.
//  Copyright © 2019 王涛. All rights reserved.
//  收款账户设置

#import "AccountsReceivableSettingTBVC.h"
#import "AddAccountsReceivableVC.h"

@interface AccountsReceivableSettingTBVC ()

@end

@implementation AccountsReceivableSettingTBVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated]; 
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.gk_navigationItem.title = LocalizationKey(@"Add PayMent Method");
    
    [self initData];
  
    self.tableView.bounces = NO;
    self.tableView.theme_separatorColor = THEME_LINE_TABLEVIEW_SEPARATOR_COLOR;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.frame = CGRectMake(0, Height_NavBar , ScreenWidth, ScreenHeight - Height_NavBar);
    [self.view addSubview:self.tableView];
}

#pragma mark - dataSource
-(void)initData{
    [self.afnetWork jsonGetDict:@"/api/account/getPayType" JsonDict:nil Tag:@"" LoadingInView:self.view];
}

-(void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    for (NSDictionary *dic in dict[@"data"]) {
        [self.dataArray addObject:dic];
    }
    [self.tableView reloadData];
}

#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.dataArray.count == 0){
        return;
    }
    AddAccountsReceivableVC *avc = [AddAccountsReceivableVC new];
    avc.typeId = self.dataArray[indexPath.row][@"id"];
    [self.navigationController pushViewController:avc animated:YES];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if(self.dataArray.count >0){
        cell.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = self.dataArray[indexPath.row][@"type_name"];
        cell.textLabel.theme_textColor = THEME_TEXT_COLOR;
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *bac =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
    return bac;
}

@end
