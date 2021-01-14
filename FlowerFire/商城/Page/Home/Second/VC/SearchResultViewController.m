//
//  SearchResultViewController.m
//  531Mall
//
//  Created by 王涛 on 2020/5/19.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "SearchResultViewController.h"
#import "HomeMainCell.h"
#import "SearchResultHeaderView.h"
#import "SearchSingleCell.h"
#import "GoodsInfoModel.h"
#import "ShopDetailsViewController.h"

@interface SearchResultViewController ()<SearchResultHeaderViewDelegate,UISearchBarDelegate>
{
    NSString *_sort,*_sort_asc;
}
@property(nonatomic, strong)UISearchBar *searchBar;
@end

@implementation SearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavBar];
    [self createUI];
    [self initData];
}

- (void)createNavBar{
    self.gk_statusBarStyle = UIStatusBarStyleDefault;
    self.gk_navBackgroundColor = rgba(250, 250, 250, 1);
    
    if(self.searchResultWhereJump == SearchResultWhereJumpDefault){ //搜索跳过来有输入框
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth/4*3, 30)];
        self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth/4*3, 30)];
        self.searchBar.placeholder = @"请输入搜索内容";
        self.searchBar.text = self.searchText;
        [titleView addSubview:self.searchBar];
        UITextField *_searchTextField;
        if (@available(iOS 13, *)) {
            _searchTextField = self.searchBar.searchTextField;
            _searchTextField.font = tFont(11);
        }else{
            for (UIView *subView in [[self.searchBar.subviews lastObject] subviews]) {
                if ([[subView class] isSubclassOfClass:[UITextField class]]) {
                    UITextField *textField = (UITextField *)subView;
                    textField.font = tFont(11);
                    _searchTextField = textField;
                    break;
                }
            }
        }
        _searchTextField.backgroundColor = KWhiteColor;
        self.searchBar.backgroundColor = KWhiteColor;
        self.searchBar.layer.cornerRadius = 15;
        self.searchBar.layer.masksToBounds = YES;
        self.searchBar.delegate = self;
        self.gk_navTitleView = titleView;
    }else{ //商城跳过来直接显示标题
        self.gk_navigationItem.title = self.searchText;
    }
    
    _sort = @"sort";
}

- (void)createUI{
    [self.collectionView ly_startLoading];
    
    self.searchResultViewType = SearchResultViewTypeSingle; 
    self.collectionViewLayout.sectionHeadersPinToVisibleBounds = YES;
    self.collectionView.frame = CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight - Height_NavBar);
    [self.view addSubview:self.collectionView];
     
    [self setMjFresh];

}

/// cate_id    可选    int    分类ID，默认为全部商品
//name    可选    string    查询的商品名称
//sort    可选    string    排序字段，默认为sort
//sort_asc    可选    string    排序方式，默认为desc（逆序），还可以为asc
//is_hot    可选    int    是否热销，1为热销
//is_recommend    可选    int    是否推荐，1为推荐
//is_new    可选    int    是否新品，1为新品
- (void)initData{
    NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:5];
    md[@"page"] = [NSString stringWithFormat:@"%ld", (long)self.pageIndex];
    md[@"name"] = self.searchBar.text;
    md[@"sort"] = _sort;
    md[@"sort_asc"] = _sort_asc;
    md[@"cate_id"] = self.cate_id;
    [self.afnetWork jsonMallPostDict:@"/api/goods/goodsList" JsonDict:md Tag:@"1" LoadingInView:self.view];
}

#pragma mark - netData
- (void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    if([type isEqualToString:@"1"]){
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        
        if(self.isRefresh){
             self.dataArray = [[NSMutableArray alloc]init];
        }
        for (NSDictionary *dic in dict[@"data"][@"infos"]) {
            [self.dataArray addObject:[GoodsInfoModel yy_modelWithDictionary:dic]];
        }
          
        self.allPages = [dict[@"data"][@"allPage"] integerValue];
  
        [self.collectionView reloadData];
    }
}
  
#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.dataArray removeAllObjects];
    [self initData];
}

#pragma mark - SearchResultHeaderViewDelegate
- (void)searchresultButtonClick:(UIButton *)button{
    button.selected = !button.selected;
    if(button.isSelected){
        _sort_asc = @"asc";
    }else{
        _sort_asc = @"desc";
    }
    switch (button.tag) {
        case 1: //销量排序
        {
            _sort = @"sale_amount";
            [self.dataArray removeAllObjects];
            [self initData];
        }
            break;
        case 2: //时间排序
        {
            _sort = @"created_time";
            [self.dataArray removeAllObjects];
            [self initData];
        }
            break;
        case 3: //价格排序
        {
            _sort = @"second_price";
            [self.dataArray removeAllObjects];
            [self initData];
        }
            break;
        default: //横竖切换
        {
            if(self.searchResultViewType == SearchResultViewTypeSingle){
                self.searchResultViewType = SearchResultViewTypeDouble;
            }else{
                self.searchResultViewType = SearchResultViewTypeSingle;
            }
            
            [self.collectionView reloadData];
        }
            break;
    }
}

#pragma mark - collectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(self.dataArray.count >0){
        GoodsInfoModel *model = self.dataArray[indexPath.item];
        ShopDetailsViewController *svc = [[ShopDetailsViewController alloc] initWithGoodsID:model.GoodsId];
        [self.navigationController pushViewController:svc animated:YES];
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return  1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(self.searchResultViewType == SearchResultViewTypeSingle){
        static NSString *identifier = @"cell";
        [self.collectionView registerClass:[SearchSingleCell class] forCellWithReuseIdentifier:identifier];
        SearchSingleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        if(self.dataArray.count >0){
            [cell setCellData:self.dataArray[indexPath.item]];
        }
        return cell;
    }else{
        static NSString *identifier = @"cell2";
        [self.collectionView registerClass:[HomeMainCell class] forCellWithReuseIdentifier:identifier];
        HomeMainCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        if(self.dataArray.count >0){
            [cell setCellData:self.dataArray[indexPath.item]];
        }
        return cell;
    } 
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"header1";
    [self.collectionView registerClass:[SearchResultHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifier];

    SearchResultHeaderView *_headerView  = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifier forIndexPath:indexPath];
    _headerView.delegate = self;
    return _headerView;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 16, 0, 16);
}
 
- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(ScreenWidth, 45);
  
}
- (void)setSearchResultViewType:(SearchResultViewType)searchResultViewType{
    _searchResultViewType = searchResultViewType;
    switch (searchResultViewType) {
        case SearchResultViewTypeDefault:
        case SearchResultViewTypeSingle:
        {
            self.collectionViewLayout.estimatedItemSize = CGSizeMake((ScreenWidth - 16*2), 104.5);
            self.collectionViewLayout.minimumLineSpacing = 16;
            self.collectionViewLayout.minimumInteritemSpacing = 0;
        }
            break;
        case SearchResultViewTypeDouble:
        { 
            
            self.collectionViewLayout.estimatedItemSize = CGSizeMake((ScreenWidth - 16*2)/2 - 8, 200);
            self.collectionViewLayout.minimumLineSpacing = 16;
            self.collectionViewLayout.minimumInteritemSpacing = 0;
            
        }
            break;
    }
}

@end
