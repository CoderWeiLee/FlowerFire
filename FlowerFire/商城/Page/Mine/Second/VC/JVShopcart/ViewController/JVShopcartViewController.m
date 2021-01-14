//
//  JVShopcartViewController.m
//  JVShopcart
//
//  Created by AVGD-Jarvi on 17/3/23.
//  Copyright © 2017年 AVGD-Jarvi. All rights reserved.
//

#import "JVShopcartViewController.h"
#import "JVShopcartTableViewProxy.h"
#import "JVShopcartBottomView.h"
#import "JVShopcartCell.h"
#import "JVShopcartHeaderView.h"
#import "JVShopcartFormat.h"
#import "Masonry.h"
#import "MainMallTabBarController.h"
#import "ShopDetailsViewController.h"
#import "SubmitOrderViewController.h"

@interface JVShopcartViewController ()<JVShopcartFormatDelegate>

@property (nonatomic, strong) UITableView *shopcartTableView;   /**< 购物车列表 */
@property (nonatomic, strong) JVShopcartBottomView *shopcartBottomView;    /**< 购物车底部视图 */
@property (nonatomic, strong) JVShopcartTableViewProxy *shopcartTableViewProxy;    /**< tableView代理 */
@property (nonatomic, strong) JVShopcartFormat *shopcartFormat;    /**< 负责购物车逻辑处理 */
@property (nonatomic, strong) UIButton *editButton;    /**< 编辑按钮 */

@end

@implementation JVShopcartViewController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //回到商品详情刷新一下加入购物车按钮的状态
    !self.backFreshBlock ? : self.backFreshBlock();
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self requestShopcartListData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.gk_statusBarStyle = UIStatusBarStyleDefault;
    self.gk_navigationItem.title = @"购物车";
    self.gk_navBackgroundColor = rgba(250, 250, 250, 1);
    self.view.backgroundColor = self.gk_navBackgroundColor;
    self.gk_navItemRightSpace = 15;
    //禁止全屏幕饭回
    self.gk_fullScreenPopDisabled = YES;
    
    [self addSubview];
    [self layoutSubview];
    
     
    @weakify(self)
    self.shopcartTableView.ly_emptyView = [LYEmptyView emptyActionViewWithImage:[UIImage imageNamed:@"gouwuche1"] titleStr:@"" detailStr:@"购物车竟然是空的" btnTitleStr:@"去商城逛逛" btnClickBlock:^{
        @strongify(self)
        [[NSNotificationCenter defaultCenter] postNotificationName:SelectedTabBarIndexNotice object:nil userInfo:@{@"index":@(1)}]; 
    }];

}

- (void)requestShopcartListData {
    [self.shopcartTableView ly_startLoading];
    [self.shopcartFormat requestShopcartProductList];
}

#pragma mark JVShopcartFormatDelegate

//数据请求成功回调
- (void)shopcartFormatRequestProductListDidSuccessWithArray:(NSMutableArray *)dataArray {
    [self.shopcartTableView ly_endLoading];
    if(dataArray.count>0){
        self.shopcartTableView.frame = CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight - Height_NavBar - SafeAreaBottomHeight - 50);
        self.shopcartBottomView.frame = CGRectMake(0, ScreenHeight - 50 - SafeAreaBottomHeight, ScreenWidth, 50);
        self.shopcartTableViewProxy.dataArray = dataArray;
        [self.shopcartTableView reloadData];
    }else{
        self.shopcartBottomView.frame = CGRectZero;
        self.shopcartTableView.frame = CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight - Height_NavBar);
        self.shopcartTableViewProxy.dataArray = dataArray;
        [self.shopcartTableView reloadData];
    }
    
    
}

//购物车视图需要更新时的统一回调
- (void)shopcartFormatAccountForTotalPrice:(float)totalPrice totalCount:(NSInteger)totalCount isAllSelected:(BOOL)isAllSelected TotalThreePrice:(float)threePrice{
    [self.shopcartBottomView configureShopcartBottomViewWithTotalPrice:totalPrice totalCount:totalCount isAllselected:isAllSelected TotalThreePrice:threePrice];
    [self.shopcartTableView reloadData];
}

//点击结算按钮后的回调
- (void)shopcartFormatSettleForSelectedProducts:(NSArray *)selectedProducts {
    SubmitOrderViewController *s = [SubmitOrderViewController new];
    [self.navigationController pushViewController:s animated:YES];
}

//批量删除回调
- (void)shopcartFormatWillDeleteSelectedProducts:(NSArray *)selectedProducts {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"确认要删除这%ld个宝贝吗？", selectedProducts.count] preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.shopcartFormat deleteSelectedProducts:selectedProducts];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

//全部删除回调
- (void)shopcartFormatHasDeleteAllProducts {
    self.shopcartBottomView.frame = CGRectZero;
    self.shopcartTableView.frame = CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight - Height_NavBar);
}

#pragma mark getters

- (UITableView *)shopcartTableView {
    if (_shopcartTableView == nil){
        _shopcartTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _shopcartTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_shopcartTableView registerClass:[JVShopcartCell class] forCellReuseIdentifier:@"JVShopcartCell"];
     //   [_shopcartTableView registerClass:[JVShopcartHeaderView class] forHeaderFooterViewReuseIdentifier:@"JVShopcartHeaderView"];
        _shopcartTableView.showsVerticalScrollIndicator = NO;
        _shopcartTableView.delegate = self.shopcartTableViewProxy;
        _shopcartTableView.dataSource = self.shopcartTableViewProxy;
        _shopcartTableView.rowHeight = 100;
     //   _shopcartTableView.sectionFooterHeight = 10;
      //  _shopcartTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
     //   _shopcartTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        _shopcartTableView.backgroundColor = self.view.backgroundColor;
    }
    return _shopcartTableView;
}

- (JVShopcartTableViewProxy *)shopcartTableViewProxy {
    if (_shopcartTableViewProxy == nil){
        _shopcartTableViewProxy = [[JVShopcartTableViewProxy alloc] init];
        
        __weak __typeof(self) weakSelf = self;
        _shopcartTableViewProxy.shopcartProxyProductSelectBlock = ^(BOOL isSelected, NSIndexPath *indexPath,UIButton *productButton){
            [weakSelf.shopcartFormat selectProductAtIndexPath:indexPath isSelected:isSelected productButton:productButton];
        };
        
        _shopcartTableViewProxy.shopcartProxyBrandSelectBlock = ^(BOOL isSelected, NSInteger section){
            [weakSelf.shopcartFormat selectBrandAtSection:section isSelected:isSelected];
        };
        
        _shopcartTableViewProxy.shopcartProxyChangeCountBlock = ^(NSInteger count, NSIndexPath *indexPath){
            [weakSelf.shopcartFormat changeCountAtIndexPath:indexPath count:count];
        };
        
        _shopcartTableViewProxy.shopcartProxyDidSelectedRowBlock = ^(NSString *goodsID) {
            ShopDetailsViewController *s = [[ShopDetailsViewController alloc] initWithGoodsID:goodsID];
            [weakSelf.navigationController pushViewController:s animated:YES];
        };
        
        _shopcartTableViewProxy.shopcartProxyDeleteBlock = ^(NSIndexPath *indexPath){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"确认要删除这个宝贝吗？" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf.shopcartFormat deleteProductAtIndexPath:indexPath];
            }]];
            [weakSelf presentViewController:alert animated:YES completion:nil];
        };
        
        _shopcartTableViewProxy.shopcartProxyStarBlock = ^(NSIndexPath *indexPath){
            [weakSelf.shopcartFormat starProductAtIndexPath:indexPath];
        };
    }
    return _shopcartTableViewProxy;
}

- (JVShopcartBottomView *)shopcartBottomView {
    if (_shopcartBottomView == nil){
        _shopcartBottomView = [[JVShopcartBottomView alloc] init];
        
        __weak __typeof(self) weakSelf = self;
        _shopcartBottomView.shopcartBotttomViewAllSelectBlock = ^(BOOL isSelected){
            [weakSelf.shopcartFormat selectAllProductWithStatus:isSelected];
        };
        
        _shopcartBottomView.shopcartBotttomViewSettleBlock = ^(){
            [weakSelf.shopcartFormat settleSelectedProducts];
        };
        
        _shopcartBottomView.shopcartBotttomViewStarBlock = ^(){
            [weakSelf.shopcartFormat starSelectedProducts];
        };
        
        _shopcartBottomView.shopcartBotttomViewDeleteBlock = ^(){
            [weakSelf.shopcartFormat beginToDeleteSelectedProducts];
        };
    }
    return _shopcartBottomView;
}

- (JVShopcartFormat *)shopcartFormat {
    if (_shopcartFormat == nil){
        _shopcartFormat = [[JVShopcartFormat alloc] init];
        _shopcartFormat.delegate = self;
    }
    return _shopcartFormat;
}

- (UIButton *)editButton {
    if (_editButton == nil){
        _editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _editButton.frame = CGRectMake(0, 0, 40, 40);
        [_editButton setTitle:@"编辑" forState:UIControlStateNormal];
        [_editButton setTitle:@"完成" forState:UIControlStateSelected];
        [_editButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _editButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_editButton addTarget:self action:@selector(editButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editButton;
}

- (void)editButtonAction {
    self.editButton.selected = !self.editButton.isSelected;
    [self.shopcartBottomView changeShopcartBottomViewWithStatus:self.editButton.isSelected];
}

- (void)addSubview {
    UIBarButtonItem *editBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.editButton];
    self.gk_navigationItem.rightBarButtonItem = editBarButtonItem;
    
    [self.view addSubview:self.shopcartTableView];
    [self.view addSubview:self.shopcartBottomView];
}

- (void)layoutSubview {
    self.shopcartTableView.frame = CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight - Height_NavBar - SafeAreaBottomHeight - 50);
    self.shopcartBottomView.frame = CGRectMake(0, ScreenHeight - 50 - SafeAreaBottomHeight, ScreenWidth, 50);
}

@end
