//
//  TaskMainViewController.m
//  531Mall
//
//  Created by 王涛 on 2020/5/19.
//  Copyright © 2020 Celery. All rights reserved.
//  任务页面

#import "TaskMainViewController.h"
#import "TaskMainCell.h"
#import "UIImage+jianbianImage.h"
#import "TaskModel.h"
#import "ArticlesInfoViewController.h"

@interface TaskMainViewController ()

@end

@implementation TaskMainViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self createNavBar];
    [self createUI]; 
}

- (void)createNavBar{
    self.gk_statusBarStyle = UIStatusBarStyleDefault;
    self.gk_navigationItem.title = @"任务";
    self.gk_navBackgroundColor = rgba(250, 250, 250, 1);
        
}

- (void)createUI{
    self.view.backgroundColor = KWhiteColor;
    self.tableView.frame = CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight - Height_NavBar - Height_TabBar);
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.tableView];
 
    [self setOnlyReFresh];
}

- (void)initData{
    NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:2];
    md[@"userid"] = [WTMallUserInfo shareUserInfo].ID;
    md[@"sessionid"] = [WTMallUserInfo shareUserInfo].sessionid;
    [self.afnetWork jsonMallPostDict:@"/api/task/lists" JsonDict:md Tag:@"1"]; 
}

- (void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    [self.tableView.mj_header endRefreshing];
    for (NSDictionary *dic in dict[@"data"]) {
        [self.dataArray addObject:[TaskModel yy_modelWithDictionary:dic]];
    }
    [self.tableView reloadData];
}

/**
  做任务
 is_get=-1或0是去完成（－1调领取任务接口，并跳转到对应接口，0只是跳转）
 is_get=1且is_reward=0是领取奖励
 is_reward=1是已领取奖励。
*/
-(void)DoTaskClick:(UIButton *)btn{
    CGPoint point = btn.center;
    point = [self.tableView convertPoint:point fromView:btn.superview];
    NSIndexPath *indexpath = [self.tableView indexPathForRowAtPoint:point];
    TaskModel *model = self.dataArray[indexpath.row];
    if(model.is_get == -1){
        NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:3];
        md[@"userid"] = [WTMallUserInfo shareUserInfo].ID;
        md[@"sessionid"] = [WTMallUserInfo shareUserInfo].sessionid;
        md[@"task_id"] = model.taskID;
        
        [MBManager showLoading];
        [[ReqestHelpManager share] requestMallPost:@"/api/task/getTask" andHeaderParam:md finish:^(NSDictionary *dicForData, ReqestType flag) {
            [MBManager hideAlert];
            if([dicForData[@"status"] integerValue] == 1){
                [self jumpTaskPage:model];
            }else if([dicForData[@"status"] integerValue] == 9){
                [WTMallUserInfo logout];
                [self jumpLogin];
            }else{
                printAlert(dicForData[@"msg"], 1.f);
            }
        }];
    }else if(model.is_get == 0){
        [self jumpTaskPage:model];
    }else if(model.is_get == 1 && model.is_reward == 0){
        NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:3];
        md[@"userid"] = [WTMallUserInfo shareUserInfo].ID;
        md[@"sessionid"] = [WTMallUserInfo shareUserInfo].sessionid;
        md[@"task_id"] = model.taskID;
        
        [MBManager showLoading];
        [[ReqestHelpManager share] requestMallPost:@"/api/task/getReward" andHeaderParam:md finish:^(NSDictionary *dicForData, ReqestType flag) {
            [MBManager hideAlert];
            if([dicForData[@"status"] integerValue] == 1){
                printAlert(dicForData[@"msg"], 1.f);
                [self.tableView.mj_header beginRefreshing];
            }else if([dicForData[@"status"] integerValue] == 9){
                [WTMallUserInfo logout];
                [self jumpLogin];
            }else{
                printAlert(dicForData[@"msg"], 1.f);
            }
        }];
    }
}

/// 跳转做任务页面
- (void)jumpTaskPage:(TaskModel *)model {
    if(model.type == 1){ //签到
        [[WTPageRouterManager sharedInstance] jumpMallTabBarController:3];
    }else{               //看文章
        ArticlesInfoViewController *avc = [[ArticlesInfoViewController alloc] initWithArticlesID:model.article_id articlesTitle:@"任务文章"];
        avc.taskID = model.taskID;
        [self.navigationController pushViewController:avc animated:YES];
    }
}

#pragma mark - tableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    [self.tableView registerClass:[TaskMainCell class] forCellReuseIdentifier:identifier];
    TaskMainCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.backgroundColor = self.view.backgroundColor;
    
    if(self.dataArray.count>0){
        [cell setCellData:self.dataArray[indexPath.row]];
    }
    [cell.goButton addTarget:self action:@selector(DoTaskClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

 

@end
