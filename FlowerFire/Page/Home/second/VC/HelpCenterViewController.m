//
//  HelpCenterViewController.m
//  FlowerFire
//
//  Created by 王涛 on 2020/7/15.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "HelpCenterViewController.h"
#import "WhatMiningPollViewControllerViewController.h"

@interface HelpCenterViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong)UITableView *leftTableView;
@property(nonatomic, strong)UITableView *rightTableView;

@property(nonatomic, strong)NSMutableArray *leftDataArray;
@property(nonatomic, strong)NSMutableArray *rightDataArray;


@end

@implementation HelpCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self createNavBar];
    [self createUI];
    [self initData];
}

- (void)theme_didChanged{
     self.gk_navLineHidden = NO;
}

- (void)createNavBar{
    self.gk_navigationItem.title = LocalizationKey(@"HelpCenterTip1");
   
}

- (void)createUI{
    [self.view addSubview:self.leftTableView];
    [self.view addSubview:self.rightTableView];
}

- (void)initData{
//    self.dataArray = @[
//    @{@"常见问题":@[@"注册和激活SD账号",@"实名认证",@"如何获得HDU矿池收益",@"如何快速切换多账号",@"添加资产网关"]},
//    @{@"新手指引":@[@"注册和激活SD账号",@"如何获得HDU矿池收益",@"如何快速切换多账号",@"实名认证",@"添加资产网关"]},
//    @{@"充提币":@[@"添加资产网关",@"如何获得HDU矿池收益",@"如何快速切换多账号",@"实名认证",@"注册和激活SD账号"]},
//    @{@"币币交易":@[@"如何快速切换多账号",@"如何获得HDU矿池收益",@"添加资产网关",@"实名认证",@"注册和激活SD账号"]},
//    @{@"法币交易":@[@"如何获得HDU矿池收益",@"如何快速切换多账号",@"添加资产网关",@"实名认证",@"注册和激活SD账号"]},].copy;
//    
//    self.leftDataArray = [NSMutableArray array];
//    
//    for (NSDictionary *dic in self.dataArray) {
//        [self.leftDataArray addObject:[dic allKeys]];
//    }
//    [self currentLeftKey:0];
    
    self.leftDataArray = @[@"常见问题",@"新手指引",@"充提币",@"币币交易",@"法币交易"];
    self.rightDataArray = @[@"注册和激活SD账号",@"实名认证",@"如何获得HDU矿池收益",@"如何快速切换多账号",@"添加资产网关"];
}

-(void)currentLeftKey:(NSInteger )index{
    self.rightDataArray = self.leftDataArray[index];
    [self.rightTableView reloadData];
}
 
#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.leftTableView){
        for (int i = 0; i<self.leftDataArray.count; i++) {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            cell.textLabel.textColor = grayTextColor;
        }
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.textLabel.textColor = RGB(89, 170, 247);
       // [self currentLeftKey:indexPath.row];
    }else{
        WhatMiningPollViewControllerViewController *wvc = [WhatMiningPollViewControllerViewController new];
        [self.navigationController pushViewController:wvc animated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == self.leftTableView){
        return self.leftDataArray.count;
    }
    return self.rightDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.leftTableView){
        static NSString *identifier = @"left";
        [self.leftTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        cell.textLabel.center = cell.contentView.center;
        cell.textLabel.text = self.leftDataArray[indexPath.row];
        cell.textLabel.font = tFont(13);
        cell.textLabel.textColor = grayTextColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = self.leftTableView.backgroundColor;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        return cell;
    }else{
        static NSString *identifier = @"right";
        [self.rightTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        cell.textLabel.center = cell.contentView.center;
        cell.imageView.image = [UIImage imageNamed:@"img59"];
        cell.textLabel.text = self.rightDataArray[indexPath.row];
        cell.textLabel.font = tFont(16);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }

}

-(UITableView *)leftTableView{
    if(!_leftTableView){
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Height_NavBar, 100, ScreenHeight - Height_NavBar) style:UITableViewStylePlain];
        _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        _leftTableView.backgroundColor = rgba(245, 249, 252, 1);
    }
    return _leftTableView;
}

-(UITableView *)rightTableView{
    if(!_rightTableView){
        _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(100, Height_NavBar, ScreenWidth - 100, ScreenHeight - Height_NavBar) style:UITableViewStylePlain];
        _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
        _rightTableView.backgroundColor = KWhiteColor;
    }
    return _rightTableView;
}



@end
