//
//  RaiseMainViewController.m
//  FlowerFire
//
//  Created by 王涛 on 2020/7/14.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "RaiseMainViewController.h"
#import "RaiseCell.h"
#import "RaiseInfoViewController.h"
#import "ApplyCoinViewController.h"

@interface RaiseMainViewController ()<JXCategoryListContainerViewDelegate>

@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;
@property (nonatomic, strong) JXCategoryTitleView         *myCategoryView;

@end

@implementation RaiseMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self createNavBar];
    [self createUI];
    [self initData];
}

- (void)createNavBar{
    self.gk_navigationItem.title = LocalizationKey(@"RaiseTip1");
    
    WTButton *recordButton = [[WTButton alloc] initWithFrame:CGRectMake(0, 0, 50, 40) titleStr:LocalizationKey(@"RaiseTip9") titleFont:tFont(15) titleColor:[UIColor redColor] parentView:nil];
    
    @weakify(self)
    [recordButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        @strongify(self)
        ApplyCoinViewController *avc = [ApplyCoinViewController new];
        [self.navigationController pushViewController:avc animated:YES];
    }];
    
    recordButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.gk_navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:recordButton];
}

- (void)initData{
    
}
 
- (void)createUI{
    self.dataArray = @[LocalizationKey(@"RaiseTip2"),LocalizationKey(@"RaiseTip3"),LocalizationKey(@"RaiseTip4"),LocalizationKey(@"RaiseTip5") ].copy;
 
    CGFloat totalItemWidth = self.view.bounds.size.width;
    self.myCategoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, Height_NavBar , totalItemWidth, 50)];
     
    self.myCategoryView.titles = self.dataArray;
    self.myCategoryView.titleFont = tFont(15);
    self.myCategoryView.cellSpacing = 0;
   // self.myCategoryView.cellWidth = totalItemWidth/self.dataArray.count;
    self.myCategoryView.titleColor = rgba(51, 51, 51, 1);
    self.myCategoryView.titleSelectedColor = MainColor;
 //   self.myCategoryView.titleLabelMaskEnabled = YES;
    self.myCategoryView.listContainer = self.listContainerView;
    self.listContainerView.frame = CGRectMake(0, self.myCategoryView.ly_maxY, self.view.bounds.size.width, self.view.bounds.size.height - self.myCategoryView.height);
   // _listContainerView.initListPercent = 0.99;
  //  self.listContainerView.contentScrollView.scrollEnabled = NO;
    
    JXCategoryIndicatorLineView *lineView = [JXCategoryIndicatorLineView new];
    lineView.lineStyle = JXCategoryIndicatorLineStyle_Normal;
    lineView.indicatorColor = MainColor ;
    self.myCategoryView.indicators = @[lineView];
    
    [self.view addSubview:self.listContainerView];
    [self.view addSubview:self.myCategoryView];
    [self.myCategoryView reloadData];
}

- (JXCategoryListContainerView *)listContainerView {
    if (_listContainerView == nil) {
        _listContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
     
    }
    return _listContainerView;
}

#pragma mark - JXCategoryListContainerViewDelegate
-(id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    RaiseChildViewController *list = [[RaiseChildViewController alloc] initWithRaiseType:index];
    return list;
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.dataArray.count;
}


@end

@interface RaiseChildViewController ()

@property(nonatomic, assign)RaiseType raiseType;
@end

@implementation RaiseChildViewController

-(instancetype)initWithRaiseType:(RaiseType)type{
   self = [super init];
   if(self){
       self.raiseType = type;
   }
   return self;
}

- (void)viewWillAppear:(BOOL)animated{
   [super viewWillAppear:animated];
   
   [self.tableView.mj_header beginRefreshing];
}

- (void)viewDidLoad{
   [self createNavBar];
   [self createUI];
//   [self initData];
}

- (void)createNavBar{
   self.gk_navigationBar.hidden = YES;
}

- (void)createUI{
   self.view.backgroundColor = KGrayBacColor;
   self.tableView.backgroundColor = self.view.backgroundColor;
   self.tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - Height_NavBar -  50 - SafeAreaBottomHeight);
   [self.view addSubview:self.tableView];
//   [self setMjFresh];
   self.tableView.estimatedRowHeight = 123;
   [self initData];
}

#pragma mark - netBack
- (void)initData{
   [self.tableView ly_startLoading];
    
    if(self.raiseType == RaiseTypeUnderReview){
        self.dataArray = @[@"XRP"];
    }else if(self.raiseType == RaiseTypeEnd){
        self.dataArray = @[@"BTC"];
    }else if(self.raiseType == RaiseTypeActivite){
        self.dataArray = @[@"EOS",@"LTC"];
    }
    
 //  self.dataArray = @[@"XPR",@"123",@"123",@"123",@"123",@"123",@"123",@"123",@"123",@"123",@"123",@"123",@"123",@"123",@"123",@"123",];
   [self.tableView reloadData];
   [self.tableView.mj_header endRefreshing];
   [self.tableView.mj_footer endRefreshing];
 
    
}

- (void)dataNormal:(NSDictionary *)dict type:(nonnull NSString *)type{
   if([type isEqualToString:@"1"]){
       [self.tableView ly_endLoading];
            
       [self.tableView.mj_header endRefreshing];
       [self.tableView.mj_footer endRefreshing];
      
       if(self.isRefresh){
            self.dataArray=[[NSMutableArray alloc]init];
       }
//        for (NSDictionary *dic in dict[@"data"][@"infos"]) {
//            MyOrderModel *model = [MyOrderModel yy_modelWithDictionary:dic];
//            [self.dataArray addObject:model];
//
//        }
         
       self.allPages = [dict[@"data"][@"allPage"] integerValue];
       [self.tableView reloadData];

   }
}


#pragma mark - tableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   static NSString *identifier1 = @"cell1";
   [self.tableView registerClass:[RaiseCell class] forCellReuseIdentifier:identifier1];
    RaiseCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier1 forIndexPath:indexPath];
    [cell setCellData:self.dataArray[indexPath.row]];
    
   return cell;
     
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RaiseInfoViewController *rvc = [RaiseInfoViewController new];
    rvc.coinName = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:rvc animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
   return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}

#pragma mark - JXCategoryListContentViewDelegate

- (UIView *)listView {
   return self.view;
}

@end
