//
//  QutesChildAllViewController.m
//  FlowerFire
//
//  Created by 王涛 on 2020/4/29.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "QutesChildAllViewController.h"
#import <JXCategoryView/JXCategoryView.h>
#import "QutesPageTableViewController.h"

@interface QutesChildAllViewController ()<JXCategoryViewDelegate,JXCategoryListContainerViewDelegate>
{
    NSInteger                         _pageIndex;
}
@property(nonatomic, strong)JXCategoryTitleView *titleCategoryView;
@property(nonatomic, strong)NSMutableArray      *pageTableDataArray;
@property(nonatomic, strong)QutesPageTableViewController *qutesPageTableVC;
@property(nonatomic, strong)JXCategoryListContainerView  *listContainerView;
@end

@implementation QutesChildAllViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

#pragma mark - netBack
- (void)netDateHandle:(NSArray *)titleArray withArray:(NSMutableArray *)array{
    if(self.pageTableDataArray.count == 0){
       self.pageTableDataArray = array;
       self.titleCategoryView.titles = titleArray;
       [self.view addSubview:self.titleCategoryView];
       [self.titleCategoryView reloadData];
    }else{
        QutesPageTableViewController *qptbvc = (QutesPageTableViewController*)self.listContainerView.validListDict[@(_pageIndex)];
        [self startSortData:qptbvc model:self.dataArray[_pageIndex]];

        [self.qutesPageTableVC.tableView reloadData];
        [self.titleCategoryView reloadData];
    }
    
}

#pragma mark - JXCategoryViewDelegate
//点击选中或者滚动选中都会调用该方法。适用于只关心选中事件，不关心具体是点击还是滚动选中的。
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index{
    _pageIndex = index;
    QuotesTradingZoneModel *model = self.dataArray[index];
    [self.qutesPageTableVC setModelArray:model.list.copy];
}

#pragma mark - JXCategoryListContainerViewDelegate
//返回列表的数量
- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.titleCategoryView.titles.count;
}
//根据下标index返回对应遵从`JXCategoryListContentViewDelegate`协议的列表实例
- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    QuotesTradingZoneModel *model = self.dataArray[index];
    QutesPageTableViewController * qptbvc = [[QutesPageTableViewController alloc] initWithDataArray:self.dataArray];
    @weakify(self)
    @weakify(qptbvc)
    qptbvc.sortBlock = ^(int sortType, int sortDirection) {
        @strongify(self)
        @strongify(qptbvc)
        self.sortType = sortType;
        self.sortDirection = sortDirection;
        //[self startSortData:qptbvc model:model];
    };
    return qptbvc;
}

#pragma mark - InitVcProtocol
- (void)createUI{
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 5)];
    topLine.theme_backgroundColor = THEME_LINE_TABLEVIEW_SEPARATOR_COLOR;
    [self.view addSubview:topLine];
    
//    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, topLine.ly_maxY + 50, ScreenWidth, 1)];
//    [self.view addSubview:bottomLine];
//    
//    bottomLine.layer.shadowColor = [UIColor grayColor].CGColor;
//    bottomLine.layer.shadowOffset = CGSizeMake(0,0);
//    bottomLine.layer.shadowOpacity = 0.3;
//    bottomLine.layer.shadowRadius = 2;
//       // 单边阴影 顶边
//    float shadowPathWidth = bottomLine.layer.shadowRadius;
//    CGRect shadowRect = CGRectMake(0, 0, bottomLine.bounds.size.width, shadowPathWidth);
//    UIBezierPath *path = [UIBezierPath bezierPathWithRect:shadowRect];
//    bottomLine.layer.shadowPath = path.CGPath;
}

#pragma mark - lazyInit
-(JXCategoryTitleView *)titleCategoryView{
    if(!_titleCategoryView){
        _titleCategoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)];
        _titleCategoryView.titleColor = [UIColor grayColor];
        _titleCategoryView.titleSelectedColor = MainColor;
        _titleCategoryView.titleFont = [UIFont boldSystemFontOfSize:15];
        _titleCategoryView.contentEdgeInsetLeft = OverAllLeft_OR_RightSpace;
        _titleCategoryView.delegate = self;
        _titleCategoryView.averageCellSpacingEnabled = NO;
         
        _listContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
        _listContainerView.frame = CGRectMake(0, _titleCategoryView.ly_maxY, self.view.bounds.size.width, self.view.bounds.size.height - _titleCategoryView.height);
        _listContainerView.scrollView.scrollEnabled = NO;
        [self.view addSubview:_listContainerView];
        //关联到categoryView
        _titleCategoryView.listContainer = _listContainerView;
         
        JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
        lineView.indicatorColor = MainColor;
        lineView.indicatorWidth = 15;
        _titleCategoryView.indicators = @[lineView];
    }
    return _titleCategoryView;
}

 
@end
