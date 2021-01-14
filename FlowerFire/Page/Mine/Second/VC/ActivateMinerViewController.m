//
//  ActivateMinerViewController.m
//  FlowerFire
//
//  Created by 王涛 on 2020/8/24.
//  Copyright © 2020 Celery. All rights reserved.
//  激活矿工列表

#import "ActivateMinerViewController.h"
#import "ActivateMinerCell.h"
#import "FFMinerListModel.h"

@interface ActivateMinerViewController ()
{
    WTButton *_activityNumButton;
}
@end

@implementation ActivateMinerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createNavBar];
    [self createUI];
    [self initData];
}

- (void)createNavBar{
    self.gk_navigationItem.title = LocalizationKey(@"578Tip13");
}

- (void)createUI{
    self.tableView.frame = CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight - Height_NavBar);
    [self.view addSubview:self.tableView];
    
    _activityNumButton = [[WTButton alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50) titleStr:LocalizationKey(@"578Tip156") titleFont:tFont(15) titleColor:KBlackColor buttonImage:[UIImage imageNamed:@"phone"] parentView:nil];
    _activityNumButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _activityNumButton.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, -15);
    _activityNumButton.titleEdgeInsets = UIEdgeInsetsMake(0, 15+5, 0, -5-15);
    self.tableView.tableHeaderView = _activityNumButton;
}

- (void)initData{
    NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:1];
    md[@"activation_status"] = @"1";
    [self.afnetWork jsonPostDict:@"/api/user/downUsers" JsonDict:md Tag:@"1"];
}
//SD的币ID是19
- (void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    for (NSDictionary *dic in dict[@"data"][@"list"]) {
        [self.dataArray addObject:[FFMinerListModel yy_modelWithDictionary:dic]];
    }
    [_activityNumButton setTitle:NSStringFormat(@"%@ %d",LocalizationKey(@"578Tip156"),[dict[@"data"][@"count"] intValue]) forState:UIControlStateNormal];
    [self.tableView reloadData];
}

#pragma mark - tableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    [self.tableView registerClass:[ActivateMinerCell class] forCellReuseIdentifier:identifier];
    ActivateMinerCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if(self.dataArray.count>0){
        [cell setCellData:self.dataArray[indexPath.row]];
    }
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}

@end
