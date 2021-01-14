//
//  MiningPollIncomeViewController.m
//  FlowerFire
//
//  Created by 王涛 on 2020/7/14.
//  Copyright © 2020 Celery. All rights reserved.
//  矿池收益

#import "MiningPollIncomeViewController.h"
#import "MiningPollIncomeHeaderView.h"
#import "PartWalletViewController.h"
#import "MiningPollComputingPowerViewController.h"
#import "WhatMiningPollViewControllerViewController.h"
#import "CreateRedEnvelopeViewController.h"

@interface MiningPollIncomeViewController ()
{
    WTLabel *_incomNum;
}
@end

@implementation MiningPollIncomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavBar];
    [self createUI];
    [self initData];
}

- (void)createNavBar{
    self.gk_navigationItem.title = [self.coinName stringByAppendingString:@"矿池"];
}

- (void)initData{
    self.dataArray = @[@"分钱包",@"矿工算力",[@"什么是" stringByAppendingString:self.coinName]].copy;
}
 
- (void)createUI{
    self.tableView.bounces = NO;
    self.tableView.frame = CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight - Height_NavBar);
    [self.view addSubview:self.tableView];
    self.view.backgroundColor = KWhiteColor;
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    MiningPollIncomeHeaderView *headerView = [[MiningPollIncomeHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 130) coinName:self.coinName];
    self.tableView.tableHeaderView = headerView;
    
    WTBacView *bacView = [[WTBacView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 260) backGroundColor:KWhiteColor parentView:nil];
    WTLabel *_incomeTip = [[WTLabel alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, OverAllLeft_OR_RightSpace, 150, 25) Text:@"最近一周收益" Font:[UIFont boldSystemFontOfSize:18] textColor:KBlackColor parentView:bacView];
    
    _incomNum = [[WTLabel alloc] initWithFrame:CGRectMake(_incomeTip.left, _incomeTip.bottom + 10, SCREEN_WIDTH - OverAllLeft_OR_RightSpace, 20) Text:@"最佳持币:212.33,最低持币:65" Font:tFont(13) textColor:grayTextColor parentView:bacView];
   
    
    WTButton *_upButton = [[WTButton alloc] initWithFrame:CGRectMake(ScreenWidth - OverAllLeft_OR_RightSpace - 100, _incomeTip.centerY - 20, 100, 40) titleStr:@"提升收益" titleFont:tFont(13) titleColor:MainColor parentView:bacView];
    _upButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    @weakify(self)
    [_upButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull   sender) {
        @strongify(self)
        CreateRedEnvelopeViewController *cvc = [CreateRedEnvelopeViewController new];
        [self.navigationController pushViewController:cvc animated:YES];
    }];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mycenter_3"]];
    imageView.centerX = bacView.centerX;
    imageView.top = _incomNum.bottom + 30;
    imageView.size = imageView.image.size;
    [bacView addSubview:imageView];
    self.tableView.tableFooterView = bacView;
}

#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            PartWalletViewController *pvc = [[PartWalletViewController alloc] init];
            pvc.coinName = self.coinName;
            [self.navigationController pushViewController:pvc animated:YES];
        }
            break;
        case 1:
        {
            MiningPollComputingPowerViewController *mpc = [MiningPollComputingPowerViewController new];
            mpc.coinName = self.coinName;
            [self.navigationController pushViewController:mpc animated:YES];
            break;
        }
        default:
        {
            WhatMiningPollViewControllerViewController *wvc = [WhatMiningPollViewControllerViewController new];
            [self.navigationController pushViewController:wvc animated:YES];
        }
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.textLabel.font = tFont(15);
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    WTBacView *bac = [[WTBacView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 100) backGroundColor:KWhiteColor parentView:nil];
    
    WTButton *inviteButton = [[WTButton alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, 10, ScreenWidth - 2 *OverAllLeft_OR_RightSpace, 75) buttonImage:nil parentView:bac];
    [inviteButton setBackgroundImage:[UIImage imageNamed:@"img25"] forState:UIControlStateNormal];
    
    WTBacView *line = [[WTBacView alloc] initWithFrame:CGRectMake(0, bac.height - 5, ScreenWidth, 5) backGroundColor:FlowerFirexianColor parentView:nil];
    [bac addSubview:line];
     
    @weakify(self)
    [inviteButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        @strongify(self)
        CreateRedEnvelopeViewController *cvc = [CreateRedEnvelopeViewController new];
        [self.navigationController pushViewController:cvc animated:YES];
    }];
     
    
    return bac;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 100;
}
 

@end
