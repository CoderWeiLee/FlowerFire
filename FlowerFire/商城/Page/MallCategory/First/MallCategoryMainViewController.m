//
//  MallCategoryMainViewController.m
//  531Mall
//
//  Created by 王涛 on 2020/5/8.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "MallCategoryMainViewController.h"
#import "MallCategoryParams.h"
#import "MallCategoryMenuController.h"
#import "MallCategoryDetailController.h"
#import "EmptyDataView.h"

@interface MallCategoryMainViewController ()
{
    NSInteger _sectionNum;//计算有几个section，自己组合数据结构
}
@property (nonatomic, strong) MallCategoryMenuController    *categoryMenuVC;
@property (nonatomic, strong) MallCategoryDetailController  *categoryMenuDetailVC;
@property (nonatomic, strong) NSMutableArray                *detailsVCArray;

@end

@implementation MallCategoryMainViewController
 
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if(self.categoryMenuVC.categoryList.count == 0){
        [self initData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MALLHEXCOLOR(@"FFFFFF");
  
    self.gk_navigationItem.title = @"商城";
    self.gk_statusBarStyle = UIStatusBarStyleDefault;
    self.gk_navBackgroundColor = rgba(250, 250, 250, 1);
    
    self.view.ly_emptyView = [EmptyDataView diyCustomEmptyViewWithTarget:self action:@selector(initData)];
}

#pragma mark - netData
- (void)initData{
    [self.afnetWork jsonMallPostDict:@"/api/goods/getCategory" JsonDict:nil Tag:@"1" LoadingInView:self.view];
}

//    2 =         {
//        "created_time" = 1591169585;
//        description = "";
//        id = 2;
//        img = "http://shangtukeji.oss-cn-hongkong.aliyuncs.com/t531_shangtua_co/category/20200603/94216ee410787200f258e8eb04aeb13b.png";
//        "is_floor" = 0;
//        "is_show" = 1;
//        name = "\U6d4b\U8bd5";
//        "parent_id" = 0;
//        sort = 50;
//        "updated_time" = 1591169585;
//    };
//    3 =         {
//        "created_time" = 1591169602;
//        description = "";
//        id = 3;
//        img = "http://shangtukeji.oss-cn-hongkong.aliyuncs.com/t531_shangtua_co/category/20200603/66c43b38cbf5f494a43f0044f699e3d3.png";
//        "is_floor" = 0;
//        "is_show" = 1;
//        name = "\U6d4b\U8bd52";
//        "parent_id" = 0;
//        sort = 50;
//        "updated_time" = 1591169602;
//    };
//};

- (void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    [self.view ly_hideEmptyView];
    if([type isEqualToString:@"1"]){
        for (NSDictionary *dic in dict[@"data"]) {
            [self.dataArray addObject:dic];
        }
        
        NSMutableDictionary *md = [NSMutableDictionary dictionary];
        md[@"cate_id"] = self.dataArray.firstObject[@"id"];
        [self.afnetWork jsonMallPostDict:@"/api/goods/getCategory" JsonDict:md Tag:@"2" LoadingInView:self.view];
 
        _sectionNum = 0;
        self.detailsVCArray = [NSMutableArray array];
    }else{
        NSLog(@"%@",dict.description);
        _sectionNum++;
        NSMutableArray *sectionArray = [NSMutableArray array];
        
        for (NSDictionary *dic in dict[@"data"]) {
            [sectionArray addObject:dic];
        }
        [self.detailsVCArray addObject:sectionArray];
          
        if(self.dataArray.count == _sectionNum){ //说明数据都有了,再创建
            //left
            [self addCategoryMenuView];
            self.categoryMenuVC.categoryList = self.dataArray;
            //right
            [self addCategoryDetailCollectionView];
            self.categoryMenuDetailVC.dataArray = self.detailsVCArray;
            self.categoryMenuDetailVC.sectionHeaderArray = self.dataArray;
        }else if(self.dataArray.count > _sectionNum){
            NSMutableDictionary *md = [NSMutableDictionary dictionary];
            md[@"cate_id"] = self.dataArray[_sectionNum][@"id"];
            [self.afnetWork jsonMallPostDict:@"/api/goods/getCategory" JsonDict:md Tag:@"2" LoadingInView:self.view];
                     
        }
    }
} 
  
- (MallCategoryMenuController *)categoryMenuVC {
    if (!_categoryMenuVC) {
        _categoryMenuVC = [[MallCategoryMenuController alloc] init];
    }
    return _categoryMenuVC;
}

- (MallCategoryDetailController *)categoryMenuDetailVC{
    if (!_categoryMenuDetailVC) {
        _categoryMenuDetailVC = [[MallCategoryDetailController alloc] init];
     
        _categoryMenuDetailVC.parentVC = self; 
    }
    return _categoryMenuDetailVC;
}
#pragma mark - 添加一级分类菜单
- (void)addCategoryMenuView{
    [self.view addSubview:self.categoryMenuVC.view];
    [self.categoryMenuVC.view setRTLFrame:CGRectMake(0, Height_NavBar, CATEGORYMENU_WIDTH, kMain_Height - Height_NavBar)];
}
#pragma mark - 添加详细分类列表
- (void)addCategoryDetailCollectionView{
    [self.view addSubview:self.categoryMenuDetailVC.view];
    [self.categoryMenuDetailVC.view setRTLFrame:CGRectMake(CATEGORYMENU_WIDTH, Height_NavBar, CATEGORYDETAIL_WIDTH, kMain_Height - Height_NavBar)];
}


@end
