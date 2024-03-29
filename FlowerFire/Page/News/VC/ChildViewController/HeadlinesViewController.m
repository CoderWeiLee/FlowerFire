//
//  HeadlinesViewController.m
//  FlowerFire
//
//  Created by 李伟 on 2021/1/14.
//  Copyright © 2021 Celery. All rights reserved.
//

#import "HeadlinesViewController.h"
#import "LWNewsModel.h"
#import <MJExtension/MJExtension.h>
#import "LWNewsTableViewCell.h"
#import <Masonry/Masonry.h>
#import "NewsDetailViewController.h"
#import "LWNewsLineTableViewCell.h"
@interface HeadlinesViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, assign) NSInteger maxCount;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger totalPage;
@end

@implementation HeadlinesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.gk_navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.clipsToBounds = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView registerClass:[LWNewsLineTableViewCell class] forCellReuseIdentifier:NSStringFromClass([LWNewsLineTableViewCell class])];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    self.tableView.mj_footer.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
}

//下拉刷新
- (void)loadData {
    self.currentPage = 1;
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    md[@"type"] = @"3";
    md[@"page"] =  [NSString stringWithFormat:@"%ld", (long)self.currentPage];
    md[@"number"] = @"20";
    //获取头条
    [self.afnetWork jsonGetDict:@"/api/newss/list" JsonDict:md Tag:@"0" LoadingInView:self.view];
}

//加载更多
- (void)loadMore {
    self.currentPage = self.currentPage + 1;
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    md[@"type"] = @"3";
    md[@"page"] =  [NSString stringWithFormat:@"%ld", (long)self.currentPage];
    md[@"number"] = @"20";
    //获取头条
    [self.afnetWork jsonGetDict:@"/api/newss/list" JsonDict:md Tag:@"0" LoadingInView:self.view];
}


#pragma mark - JXCategoryListContentViewDelegate
// 返回列表视图
// 如果列表是 VC，就返回 VC.view
// 如果列表是 View，就返回 View 自己
- (UIView *)listView {
    return self.view;
}

- (void)getHttpData_array:(NSDictionary *)dict response:(Response)flag Tag:(NSString *)tag {
        [self.tableView.mj_header endRefreshing];
            if([dict[@"msg"] isEqualToString:@"success"]){
                if(self.currentPage == 1){
                    self.dataArray=[[NSMutableArray alloc]init];
                }
                NSArray *models = [LWNewsModel mj_objectArrayWithKeyValuesArray:dict[@"data"][@"list"]];
                [self.dataArray addObjectsFromArray:models];
                self.currentPage = (NSInteger)dict[@"data"][@"page"][@"page_current"];
                self.totalPage = (NSInteger)dict[@"data"][@"page"][@"page_count"];
                if (self.currentPage == self.totalPage) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }else {
                    [self.tableView.mj_footer endRefreshing];
                }
            }else{
                printAlert(dict[@"msg"], 1.f);
            }
        [self.tableView reloadData];
}



#pragma mark - tableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LWNewsLineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LWNewsLineTableViewCell class]) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    LWNewsModel *model = self.dataArray[indexPath.row];
    model.type = @"快讯";
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 250;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LWNewsModel *model = self.dataArray[indexPath.row];
    NewsDetailViewController *detailVC = [[NewsDetailViewController alloc] init];
    detailVC.model = model;
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - lazyInit
-(AFNetworkClass *)afnetWork{
    if(!_afnetWork){
        _afnetWork = [AFNetworkClass new];
        _afnetWork.delegate = self;
    }
    return _afnetWork;
}
@end
