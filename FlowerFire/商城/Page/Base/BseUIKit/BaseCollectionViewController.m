//
//  BaseCollectionViewController.m
//  FilmCrowdfunding
//
//  Created by 王涛 on 2019/11/13.
//  Copyright © 2019 Celery. All rights reserved.
//

#import "BaseCollectionViewController.h"
#import "EmptyDataView.h"
#import "LYEmptyViewHeader.h"
 
@interface BaseCollectionViewController ()
{
    EmptyDataView *_emptyDataView;
}
@end

@implementation BaseCollectionViewController

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
    [self.collectionView ly_endLoading];
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
    
    if(![HelpManager isBlankString:dict[@"msg"]]  ){
        printAlert(dict[@"msg"], 1.5f);
    }
}

-(void)setMjFresh{
    __weak typeof (self) weakSelf = self;
    self.collectionView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf downFreshloadData];
    }];
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf upFreshLoadMoreData];
    }];
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
        self.collectionView.mj_footer.state = MJRefreshStateNoMoreData;
    }else{
        _pageIndex++;
        [self initData];
    }
    
}
  
-(void)beginRefreshing{
    [self.collectionView.mj_header beginRefreshing];
}

-(UICollectionView *)collectionView{
    if(!_collectionView){
        self.collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
        self.collectionViewLayout.minimumInteritemSpacing = 0;
        self.collectionViewLayout.minimumLineSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight - Height_NavBar - Height_TabBar) collectionViewLayout:self.collectionViewLayout];
   //     _tableView.backgroundColor = self.view.backgroundColor;
         [_collectionView setTheme_backgroundColor:THEME_MAIN_BACKGROUNDCOLOR]; 
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [self addEmptyView:_collectionView];
    }
    return _collectionView;
}

- (void)setEmptyViewContentViewY:(CGFloat)offset{
    _emptyDataView.contentViewY = offset;
}

-(void)addEmptyView:(UICollectionView *)collectionView{
    _emptyDataView = [EmptyDataView diyCustomEmptyViewWithTarget:self action:@selector(beginRefreshing)];
    collectionView.ly_emptyView = _emptyDataView ;
}
 
@end
