//
//  MyTeamViewController.m
//  531Mall
//
//  Created by 王涛 on 2020/5/20.
//  Copyright © 2020 Celery. All rights reserved.
//  我的团队

#import "MyTeamViewController.h"
#import "UIImage+jianbianImage.h"
#import "MyTeamChildRecommendCell.h"
#import "MyTeamChildTotalDelegateCell.h"
#import "MyTeamChildTotalDelegateCell.h"
#import "ShareFriendViewController.h"
#import "RecommendedStructureModel.h"
#import "TotalDelegateModel.h"
#import "MyTeamRecommendHeaderCollectionView.h"

@interface MyTeamViewController ()<GKPageScrollViewDelegate>
{
    UILabel *_sumPrice,*_todayPrice;
    
}
@property (nonatomic, strong) GKPageScrollView             *pageScrollView;
@property (nonatomic, strong) JXCategoryTitleView          *categoryView;
@end

@implementation MyTeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self createNavBar];
    [self createUI];
    [self initData];
}

- (void)createNavBar{
    self.gk_navigationBar.hidden = YES;
    self.gk_navigationItem.title = @"团队";
}

- (void)createUI{
    self.pageScrollView.frame = CGRectMake(0, -Height_StatusBar, ScreenWidth, ScreenHeight+Height_StatusBar);
    [self.view addSubview:self.pageScrollView];
    [self.pageScrollView reloadData];
    
//    @weakify(self)
//    self.pageScrollView.mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        @strongify(self)
//        [self initData];
//    }];
}

//团队头部接口
- (void)initData{
    NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:2];
    md[@"userid"] = [WTMallUserInfo shareUserInfo].ID;
    md[@"sessionid"] = [WTMallUserInfo shareUserInfo].sessionid;
    [self.afnetWork jsonMallPostDict:@"/api/net/teamHand" JsonDict:md Tag:@"1" LoadingInView:self.view];
     
}

#pragma mark - dataSource
- (void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    NSString *pvTotal = NSStringFormat(@"%@",dict[@"data"][@"pvTotal"]);
    NSString *todayPv = NSStringFormat(@"%@",dict[@"data"][@"todayPv"]);
    
    NSString *_sumPriceStr = NSStringFormat(@"%@\n累计业绩",pvTotal);
    NSString *_todayPriceStr = NSStringFormat(@"%@\n今日业绩",todayPv);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 2;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_sumPriceStr attributes:@{NSParagraphStyleAttributeName:paragraphStyle}];
    [attributedString addAttributes:@{NSFontAttributeName:tFont(30)} range:[_sumPriceStr rangeOfString:pvTotal]];
    _sumPrice.attributedText = attributedString;
  
    attributedString = [[NSMutableAttributedString alloc] initWithString:_todayPriceStr attributes:@{NSParagraphStyleAttributeName:paragraphStyle}];
    [attributedString addAttributes:@{NSFontAttributeName:tFont(30)} range:[_todayPriceStr rangeOfString:todayPv]];
    _todayPrice.attributedText = attributedString;
}

#pragma mark - action
-(void)jumpShareClick{
    ShareFriendViewController *sf = [ShareFriendViewController new];
    [self.navigationController pushViewController:sf animated:YES];
}

 #pragma mark - GKPageScrollViewDelegate
 - (BOOL)shouldLazyLoadListInPageScrollView:(GKPageScrollView *)pageScrollView {
     return YES;
 }

 - (UIView *)headerViewInPageScrollView:(GKPageScrollView *)pageScrollView {
     //1.42
     UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ceil(ScreenWidth/1.42))];
     
     UIImageView *cover = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, headerView.height + 15)];
     cover.contentMode = UIViewContentModeScaleAspectFill;
     cover.clipsToBounds = YES;
     cover.image = [UIImage imageNamed:@"bg3"];
     [headerView addSubview:cover];
      
     UIButton *dissmissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
     dissmissBtn.titleLabel.font = tFont(15);
     [dissmissBtn setImage:[UIImage gk_imageNamed:@"btn_back_white"] forState:UIControlStateNormal];
     [dissmissBtn addTarget:self action:@selector(backItemClick:) forControlEvents:UIControlEventTouchUpInside];
     [headerView addSubview:dissmissBtn];

     dissmissBtn.frame = CGRectMake(OverAllLeft_OR_RightSpace, 2 * Height_StatusBar , 30, 30);

     
     UILabel *title = [UILabel new];
     title.text = @"团队";
     title.textColor = KWhiteColor;
     title.font = tFont(17);
     [headerView addSubview:title];
     [title mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerX.mas_equalTo(headerView.mas_centerX);
         make.centerY.mas_equalTo(dissmissBtn.mas_centerY);
     }];
     
     UIButton *jumpShareButton = [UIButton buttonWithType:UIButtonTypeCustom];
     jumpShareButton.frame = CGRectMake(ScreenWidth - 20 - 80, SafeAreaTopHeight * 2 + Height_StatusBar   + 33, 80, 30);
     [jumpShareButton setBackgroundImage:[UIImage gradientColorImageFromColors:@[rgba(254, 213, 132, 1),rgba(255, 230, 181, 1)] gradientType:GradientTypeLeftToRight imgSize:CGSizeMake(80, 30)] forState:UIControlStateNormal];
     [jumpShareButton addTarget:self action:@selector(jumpShareClick) forControlEvents:UIControlEventTouchUpInside];
     jumpShareButton.layer.cornerRadius = 15;
     jumpShareButton.layer.masksToBounds = YES;
     jumpShareButton.titleLabel.font = tFont(13);
     [jumpShareButton setTitleColor:MainColor forState:UIControlStateNormal];
     [jumpShareButton setTitle:@"我要推广" forState:UIControlStateNormal];
     [headerView addSubview:jumpShareButton];
     
     _sumPrice = [[UILabel alloc] init];
     _sumPrice.textColor = KWhiteColor;
     _sumPrice.font = tFont(15);
     _sumPrice.numberOfLines = 0;
     _sumPrice.text = @"累计业绩";
     [headerView addSubview:_sumPrice];
     
     _todayPrice = [[UILabel alloc] init];
     _todayPrice.textColor = KWhiteColor;
     _todayPrice.font = tFont(15);
     _todayPrice.text = @"今日业绩";
     _todayPrice.numberOfLines = 0;
     [headerView addSubview:_todayPrice];
      
     [_sumPrice mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.mas_equalTo(ScreenWidth/6);
         make.top.mas_equalTo(jumpShareButton.mas_bottom).offset(15);
     }];
     
     [_todayPrice mas_makeConstraints:^(MASConstraintMaker *make) {
         make.right.mas_equalTo(-ScreenWidth/6);
         make.centerY.mas_equalTo(_sumPrice.mas_centerY);
     }];
     
     return headerView;
 }

 - (UIView *)segmentedViewInPageScrollView:(GKPageScrollView *)pageScrollView {
     return self.categoryView;
 }

 - (NSInteger)numberOfListsInPageScrollView:(GKPageScrollView *)pageScrollView {
     return self.categoryView.titles.count;
 }

 - (id<GKPageListViewDelegate>)pageScrollView:(GKPageScrollView *)pageScrollView initListAtIndex:(NSInteger)index {
     MyTeamChildViewController *vc = [[MyTeamChildViewController alloc] initWithMyTeamChildViewType:(MyTeamChildViewType)index]; 
     [self addChildViewController:vc];
     return vc;
 }

- (void)mainTableViewDidScroll:(UIScrollView *)scrollView isMainCanScroll:(BOOL)isMainCanScroll{
    
}

 #pragma mark - 懒加载
 - (GKPageScrollView *)pageScrollView {
     if (!_pageScrollView) {
         _pageScrollView = [[GKPageScrollView alloc] initWithDelegate:self];
         _pageScrollView.lazyLoadList = YES;
     //    _pageScrollView.ceilPointHeight = Height_StatusBar;
         _pageScrollView.mainTableView.bounces = NO;
     }
     return _pageScrollView;
 }

 - (JXCategoryTitleView *)categoryView {
     if (!_categoryView) {
         _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
         _categoryView.titles = @[@"推荐结构",@"总代工资"];
         _categoryView.titleFont = [UIFont systemFontOfSize:13];
         _categoryView.titleSelectedFont = [UIFont systemFontOfSize:13];
         _categoryView.titleColor = rgba(51, 51, 51, 1);
         _categoryView.titleSelectedColor = MainColor;
         _categoryView.backgroundColor = rgba(240, 238, 239, 1);
         
         JXCategoryIndicatorLineView *lineView = [JXCategoryIndicatorLineView new];
         lineView.lineStyle = JXCategoryIndicatorLineStyle_Normal;
         lineView.indicatorHeight = ScreenWidth/750 * 4.0f;
         lineView.verticalMargin = ScreenWidth/750 * 2.0f;
         lineView.indicatorColor = MainColor ;
         _categoryView.indicators = @[lineView];
         
         // 设置关联的scrollView
         _categoryView.contentScrollView = self.pageScrollView.listContainerView.collectionView;
      
     }
     return _categoryView;
 }

@end

@interface MyTeamChildViewController ()

@property (nonatomic, copy) void(^listScrollViewScrollCallback)(UIScrollView *scrollView);
@property(nonatomic, assign)  MyTeamChildViewType          myTeamChildViewType;
@property (nonatomic, strong) RecommendedStructureModel    *recommendedStructureModel;
@property (nonatomic, strong) MyTeamRecommendHeaderCollectionView  *recommendHeaderCollectionView;
/// 全部层数标题数组
@property (nonatomic, strong) NSMutableArray               *sumLayerRecommendTitleArray;
/// 当前层数
@property(nonatomic,  assign) NSInteger                     currentLalyer;
/// 记录第一层级的坐标
@property (nonatomic, strong) NSIndexPath                  *firstLayerIndexPath;
@end

@implementation MyTeamChildViewController

- (instancetype)initWithMyTeamChildViewType:(MyTeamChildViewType)type{
    self = [super init];
    if (self) {
        self.myTeamChildViewType=  type;
       
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self createNavBar];
    [self createUI];
    [self initData];
}

- (void)createNavBar{
    self.gk_navigationBar.hidden = YES;
}

- (void)createUI{
  //  [self.tableView.ly_emptyView setAutoShowEmptyView:NO];
    self.tableView.backgroundColor = rgba(240, 238, 239, 1);
    self.tableView.frame = CGRectMake(0, self.view.mj_y - Height_NavBar, ScreenWidth, ScreenHeight - self.view.mj_y);
    [self.view addSubview:self.tableView];
    [self setOnlyReFresh];
}

- (void)initData{
    switch (self.myTeamChildViewType) {
        case MyTeamChildViewRecommend:
        {   //推荐结构接口
            NSMutableDictionary *md = [NSMutableDictionary dictionary];
            md[@"userid"] = [WTMallUserInfo shareUserInfo].ID;
            md[@"sessionid"] = [WTMallUserInfo shareUserInfo].sessionid;
            [self.afnetWork jsonMallPostDict:@"/api/net/recommendInWork" JsonDict:md Tag:@"1" LoadingInView:self.view];
        }
            break;
        default:
        {   //团队总工资
            NSMutableDictionary *md = [NSMutableDictionary dictionary];
            md[@"userid"] = [WTMallUserInfo shareUserInfo].ID;
            md[@"sessionid"] = [WTMallUserInfo shareUserInfo].sessionid;
            [self.afnetWork jsonMallPostDict:@"/api/net/wages" JsonDict:md Tag:@"2" LoadingInView:self.view];
        }
            break;
    }

    [self.tableView ly_startLoading];
}

#pragma mark - netData
- (void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    [self.tableView.mj_header endRefreshing];
    if([type isEqualToString:@"1"]){
        [self.dataArray removeAllObjects];
        self.currentLalyer = 1; //层数重置
        
        self.recommendedStructureModel = [RecommendedStructureModel yy_modelWithDictionary:dict[@"data"]];
       
        for (RecommendedStructureDownusersModel *downusersModel in self.recommendedStructureModel.downusers) {
            //下级的上级是自己，那么才加进数据
            if([self.recommendedStructureModel.users.userID isEqualToString:downusersModel.introduce]){
                [self.dataArray addObject:downusersModel];
            }
        }
        
        self.sumLayerRecommendTitleArray = [NSMutableArray arrayWithArray:@[@"A1",@"B1",@"C1",@"D1",@"E1",@"F1",@"G1",@"H1",@"I1",@"J1",@"K1",@"L1",@"M1",@"N1",@"O1",@"P1",@"Q1",@"R1",@"S1",@"T1",@"U1",@"V1",@"W1",@"X1",@"Y1",@"Z1"]];
      //  self.sumLayerRecommendTitleArray = [self.sumLayerRecommendTitleArray subarrayWithRange:NSMakeRange(0, [self.recommendedStructureModel.chengnums integerValue])].copy;
        
        self.recommendHeaderCollectionView.recommendHeaderArray = [self.sumLayerRecommendTitleArray subarrayWithRange:NSMakeRange(0, 1)].copy;
        
    }else{ //团队总工资
        [self.dataArray removeAllObjects];
        for (NSDictionary *dic in dict[@"data"]) {
            [self.dataArray addObject:[TotalDelegateModel yy_modelWithDictionary:dic]];
        }
    }
       [self.tableView reloadData];
       [self.tableView ly_endLoading];
}
 
#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.myTeamChildViewType == MyTeamChildViewRecommend){
        if(self.currentLalyer == 1){
            self.firstLayerIndexPath = indexPath;
        }
        [self currentLayerData:indexPath];
        
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (self.myTeamChildViewType) {
        case MyTeamChildViewRecommend:
        {
            static NSString *identifier = @"cell";
            [self.tableView registerClass:[MyTeamChildRecommendCell class] forCellReuseIdentifier:identifier];
            MyTeamChildRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
             
            if(self.dataArray.count>0){
                RecommendedStructureDownusersModel *model = self.dataArray[indexPath.row];
                [cell setCellData:model];
                if([model.introduce_down_data allValues].count>0){
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }else{
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
            }
            
            return cell;
        }
        default:
        {
            static NSString *identifier = @"cell";
            [self.tableView registerClass:[MyTeamChildTotalDelegateCell class] forCellReuseIdentifier:identifier];
            MyTeamChildTotalDelegateCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            if(self.dataArray.count>0){
                TotalDelegateModel *model = self.dataArray[indexPath.row];
                [cell setCellData:model];
            }
            return cell;
        }
    }
}
 
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    switch (self.myTeamChildViewType) {
        case MyTeamChildViewRecommend:
            return self.recommendHeaderCollectionView;
        default:
            return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (self.myTeamChildViewType) {
        case MyTeamChildViewRecommend:
            return 40;
        default:
            return 0;
    }
}

/// 看一级
-(void)lookFirstRecommendClick{
    [self.dataArray removeAllObjects];
    for (RecommendedStructureDownusersModel *downusersModel in self.recommendedStructureModel.downusers) {
       //下级的上级是自己，那么才加进数据
       if([self.recommendedStructureModel.users.userID isEqualToString:downusersModel.introduce]){
           [self.dataArray addObject:downusersModel];
       }
    }
    [self.tableView reloadData];
}
  
-(MyTeamRecommendHeaderCollectionView *)recommendHeaderCollectionView{
    if(!_recommendHeaderCollectionView){
        _recommendHeaderCollectionView = [[MyTeamRecommendHeaderCollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
        
        @weakify(self)
        _recommendHeaderCollectionView.didSwitchLayerClick = ^(NSInteger layer) {
            @strongify(self)
            self.currentLalyer = layer;
            self.recommendHeaderCollectionView.recommendHeaderArray = [self.sumLayerRecommendTitleArray subarrayWithRange:NSMakeRange(0, layer)].copy;
            
            if(layer == 1){
                [self lookFirstRecommendClick];
            }else{
                [self.dataArray removeAllObjects];
                for (RecommendedStructureDownusersModel *downusersModel in self.recommendedStructureModel.downusers) {
                   //下级的上级是自己，那么才加进数据
                   if([self.recommendedStructureModel.users.userID isEqualToString:downusersModel.introduce]){
                       [self.dataArray addObject:downusersModel];
                   }
                }
                
                if(self.myTeamChildViewType == MyTeamChildViewRecommend){
                    [self currentLayerData:self.firstLayerIndexPath];
                }
                
            }
        };
    }
    return _recommendHeaderCollectionView;
}

/// 获取当前层数的数据
/// @param currentIndex 当前第几层
-(void)currentLayerData:(NSIndexPath *)currentIndex{
    self.currentLalyer++;
    if(self.currentLalyer > [self.recommendedStructureModel.chengnums integerValue]){
        self.currentLalyer--;
        return;
    }
    RecommendedStructureDownusersModel *downusersModel = self.dataArray[currentIndex.row];
    NSMutableArray *ma = [NSMutableArray array];
    for (RecommendedStructureDownusersModel *downDownusersModel in self.recommendedStructureModel.downusers) {
        //下级的下级的上级是下级，那么才加进数据
        if([downusersModel.userID isEqualToString:downDownusersModel.introduce]){
           [ma addObject:downDownusersModel];
        }
    }
    if(ma.count > 0){
        if(self.currentLalyer > self.sumLayerRecommendTitleArray.count){
            return;
        }
        self.dataArray = [NSMutableArray arrayWithArray:ma];
        self.recommendHeaderCollectionView.recommendHeaderArray = [self.sumLayerRecommendTitleArray subarrayWithRange:NSMakeRange(0, self.currentLalyer)].copy;
        [self.tableView reloadData];
    }else{
        self.currentLalyer--;
        printAlert(@"没有下级", 1.f);
    }
}

#pragma mark - GKPageListViewDelegate
- (UIView *)listView {
    return self.view;
}

- (UIScrollView *)listScrollView {
    return self.tableView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.listScrollViewScrollCallback = callback;
}


@end
