//
//  HomeViewController.m
//  531Mall
//
//  Created by 王涛 on 2020/5/18.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "MallHomeMainViewController.h"
#import "HomeMainHeaderView.h"
#import "HomeMainCell.h"
#import "ShopDetailsViewController.h"
#import "GoodsInfoModel.h"
#import "BulletinModel.h"

@interface MallHomeMainViewController ()
{
    HomeMainHeaderView *_headerView;
}
@end

@implementation MallHomeMainViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if([WTMallUserInfo isLogIn]){
        //每次都更新地址
        NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:3];
        md[@"userid"] = [WTMallUserInfo shareUserInfo].ID;
        md[@"sessionid"] = [WTMallUserInfo shareUserInfo].sessionid;
        md[@"sheet"] = @"addr";

        @weakify(self)
        [MBManager showLoading];
        [[ReqestHelpManager share] requestMallPost:@"/api/member/memberInfo" andHeaderParam:md finish:^(NSDictionary *dicForData, ReqestType flag) {
            [MBManager hideAlert];
            @strongify(self)
            if([dicForData[@"status"] integerValue] == 1){
                WTMallUserInfo *userInfo = [WTMallUserInfo shareUserInfo];
                userInfo.addr = dicForData[@"data"][@"addr"];
                [WTMallUserInfo saveUser:userInfo];
                [self->_headerView.homeNavtionView updateAddress];
            }else if([dicForData[@"status"] integerValue] == 9){
                [WTMallUserInfo logout];
            }else{
                printAlert(dicForData[@"msg"], 1.f);
            }
        }];
        
//        [[ReqestHelpManager share] requestPost:@"/api/member/getValue" andHeaderParam:md finish:^(NSDictionary *dicForData, ReqestType flag) {
//            [MBManager hideAlert];
//            @strongify(self)
//            if([dicForData[@"status"] integerValue] == 1){
//                WTUserInfo *userInfo = [WTUserInfo shareUserInfo];
//                userInfo.addr = dicForData[@"data"];
//                [WTUserInfo saveUser:userInfo];
//                [self->_headerView.homeNavtionView updateAddress];
//            }else if([dicForData[@"status"] integerValue] == 9){
//                [WTUserInfo logout];
//            }else{
//                printAlert(dicForData[@"msg"], 1.f);
//            }
//        }];
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self createNavBar];
    [self createUI];
    [self initData];
    [self getArticlesListData];

    [self getBannerData];
    [self getNoticeData];
    [self getUserTrueNameVerification];
}

- (void)createNavBar{
    self.gk_navigationBar.hidden = YES;
    self.gk_statusBarStyle = UIStatusBarStyleLightContent;
}

 - (void)createUI{
     self.collectionViewLayout.estimatedItemSize = CGSizeMake((ScreenWidth - 16*2)/2 - 8, 200);
     self.collectionViewLayout.minimumLineSpacing = 16;
     self.collectionViewLayout.minimumInteritemSpacing = 0;
     self.collectionView.frame = CGRectMake(0, -Height_StatusBar, ScreenWidth, ScreenHeight - Height_NavBar+Height_StatusBar);
     [self.view addSubview:self.collectionView];
     
     self.collectionView.ly_emptyView = nil;
     [self setMjFresh];
 }

/// 商品数据
- (void)initData{
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    md[@"page"] = [NSString stringWithFormat:@"%ld", (long)self.pageIndex];
    md[@"is_recommend"] = @"1";
    [self.afnetWork jsonMallPostDict:@"/api/goods/goodsList" JsonDict:md Tag:@"1" LoadingInView:self.view];
      
}

/// 文章列表
- (void)getArticlesListData{
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    md[@"type"] = @"1";  // 1首页，2文章列表，默认1
    [self.afnetWork jsonMallPostDict:@"/api/index/articlesList" JsonDict:md Tag:@"2"];
}

///轮播
-(void)getBannerData{
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    md[@"userid"] = [WTMallUserInfo shareUserInfo].ID;
    md[@"sessionid"] = [WTMallUserInfo shareUserInfo].sessionid;
    [self.afnetWork jsonMallPostDict:@"/api/index/getad" JsonDict:md Tag:@"3" LoadingInView:self.view];
}
///公告列表
-(void)getNoticeData{
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    md[@"userid"] = [WTMallUserInfo shareUserInfo].ID;
    md[@"sessionid"] = [WTMallUserInfo shareUserInfo].sessionid;
    md[@"page"] =  [NSString stringWithFormat:@"%ld", (long)self.pageIndex];
    md[@"number"] = @"";
    //获取公告列表
    [self.afnetWork jsonMallPostDict:@"/api/notice/notice" JsonDict:md Tag:@"4" LoadingInView:self.view];
}

/// 获取用户实名认证状态
-(void)getUserTrueNameVerification{
//    if([WTUserInfo isLogIn]){
//        NSMutableDictionary *md = [NSMutableDictionary dictionary];
//        md[@"userid"] = [WTUserInfo shareUserInfo].ID;
//        md[@"sessionid"] = [WTUserInfo shareUserInfo].sessionid;
//        md[@"sheet"] = @"is_realname";
//        [self.afnetWork jsonPostDict:@"/api/member/getValue" JsonDict:md Tag:@"5"];
//
//    }
}
    
#pragma mark - netBack
- (void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    if([type isEqualToString:@"1"]){
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        
        if(self.isRefresh){
             self.dataArray=[[NSMutableArray alloc]init];
        }
        for (NSDictionary *dic in dict[@"data"][@"infos"]) {
            [self.dataArray addObject:[GoodsInfoModel yy_modelWithDictionary:dic]];
        }
          
        self.allPages = [dict[@"data"][@"allPage"] integerValue];
        self.collectionViewLayout.estimatedItemSize = CGSizeMake((ScreenWidth - 16*2)/2 - 8, 200);
        self.collectionViewLayout.minimumLineSpacing = 16;
        self.collectionViewLayout.minimumInteritemSpacing = 0;
        [self.collectionView reloadData];
    }else if([type isEqualToString:@"2"]){  //文章列表
        if(dict[@"data"] != [NSNull null]){
            _headerView.articleDataArray = dict[@"data"];
        }
    }else if([type isEqualToString:@"3"]){
         [_headerView setBanner:dict[@"data"]];
    }else if([type isEqualToString:@"4"]){
         NSMutableArray<BulletinModel *> *noticeArray = [NSMutableArray array];
         for (NSDictionary *dic in dict[@"data"][@"notices"]) {
             BulletinModel *model = [BulletinModel yy_modelWithDictionary:dic];
             [noticeArray addObject:model];
         }
        //只显示最新的一条公告；
        _headerView.dataSource = [NSMutableArray arrayWithObject:noticeArray.firstObject];
    }
}

- (void)dataErrorHandle:(NSDictionary *)dict type:(NSString *)type{
    if([dict[@"status"] integerValue] == 9){
        [WTMallUserInfo logout];
        [self jumpLogin];
        [self.collectionView ly_endLoading];
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
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    [self.collectionView registerClass:[HomeMainCell class] forCellWithReuseIdentifier:identifier];
    HomeMainCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if(self.dataArray.count>0){
        [cell setCellData:self.dataArray[indexPath.item]];
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"header1";
    [self.collectionView registerClass:[HomeMainHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifier];

    _headerView  = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifier forIndexPath:indexPath];
    return _headerView;
}
  
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 16, 0, 16);
}

- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(ScreenWidth, [HomeMainHeaderView HomeMainHeaderHeight]);
  
}

#pragma mark - scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY >= 250) {
        self.gk_statusBarStyle = UIStatusBarStyleDefault;
    }else{
        self.gk_statusBarStyle = UIStatusBarStyleLightContent;
    }
}

@end
