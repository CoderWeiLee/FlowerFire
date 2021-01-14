//
//  BaseTableViewController.m
//  FireCoin
//
//  Created by 赵馨 on 2019/5/27.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController ()

@end

@implementation BaseTableViewController

-(instancetype)init{
    self = [super init];
    if (self) {
        self.allPages = 1;
        self.pageIndex = 1;
    }
    return self;
}
 
- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)dataErrorHandle:(NSDictionary *)dict type:(NSString *)type{
    [super dataErrorHandle:dict type:type];
    [self.tableView ly_endLoading];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

-(void)setMjFresh{
    __weak typeof (self) weakSelf = self;
    self.tableView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf downFreshloadData];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf upFreshLoadMoreData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

//下拉刷新
- (void)downFreshloadData
{
    _isRefresh=YES;
    _pageIndex=1;
    self.dataArray = [[NSMutableArray alloc] init];
    [self initData];
}

//上拉加载更多
- (void)upFreshLoadMoreData
{
    _isRefresh=NO;
    if(_pageIndex>=_allPages){
        self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
    }else{
        _pageIndex++;
        [self initData];
    }
    
}

- (void)setOnlyReFresh{
    __weak typeof (self) weakSelf = self;
       self.tableView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
           [weakSelf downFreshloadData];
       }];
}

-(UITableView *)tableView{
    if(!_tableView){
        _tableView = [[WTTableView alloc] initWithFrame:CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight - Height_TabBar - Height_NavBar) style:UITableViewStylePlain];
   //     _tableView.backgroundColor = self.view.backgroundColor;
         [_tableView setTheme_backgroundColor:THEME_MAIN_BACKGROUNDCOLOR];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        @weakify(self)
        _tableView.didEmptyViewBlock = ^{
            @strongify(self)
            [self.tableView.mj_header beginRefreshing];
//            [self.dataArray addObject:@"123"];
//            [self.tableView reloadData];
//            NSLog(@"刷新重试");
        };
        
        _tableView.estimatedRowHeight = 100;
        _tableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _tableView;
}

 

 

@end
