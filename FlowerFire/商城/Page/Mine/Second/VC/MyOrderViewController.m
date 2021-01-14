//
//  MyOrderViewController.m
//  531Mall
//
//  Created by 王涛 on 2020/5/21.
//  Copyright © 2020 Celery. All rights reserved.
//  我的订单

#import "MyOrderViewController.h"
#import "MyOrderCell.h"
#import "MyOrderReturnPopView.h"
#import <LSTPopView.h>
#import "MyOrderModel.h"
#import "OrderDetialsViewController.h"

@interface MyOrderViewController ()<JXCategoryListContainerViewDelegate>

@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;
@property (nonatomic, strong) JXCategoryTitleView         *myCategoryView;
@end

@implementation MyOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self createNavBar];
    [self createUI];
}

- (void)createNavBar{
    self.gk_navigationItem.title = @"我的订单";
    self.gk_navBackgroundColor = rgba(250, 250, 250, 1);
    self.gk_statusBarStyle = UIStatusBarStyleDefault;
}

- (void)createUI{
    self.dataArray = @[@"全部订单",@"待支付",@"待发货", @"已发货", @"已完成", ].copy;
 
    CGFloat totalItemWidth = self.view.bounds.size.width - 15*2;
    self.myCategoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(15, Height_NavBar + 10, totalItemWidth, 35)];
    self.myCategoryView.layer.cornerRadius = 17.5;
    self.myCategoryView.layer.masksToBounds = YES;
    self.myCategoryView.layer.borderColor = rgba(204, 204, 204, 1).CGColor;
    self.myCategoryView.layer.borderWidth = 0.5;
    self.myCategoryView.titles = self.dataArray;
    self.myCategoryView.titleFont = tFont(13);
    self.myCategoryView.cellSpacing = 0;
    self.myCategoryView.cellWidth = totalItemWidth/self.dataArray.count;
    self.myCategoryView.titleColor = rgba(102, 102, 102, 1);
    self.myCategoryView.titleSelectedColor = [UIColor whiteColor];
    self.myCategoryView.titleLabelMaskEnabled = YES;
    self.myCategoryView.listContainer = self.listContainerView;
    _listContainerView.frame = CGRectMake(0, self.myCategoryView.ly_maxY + 10, self.view.bounds.size.width, self.view.bounds.size.height - self.myCategoryView.height - 10);
    _listContainerView.initListPercent = 0.99;
    _listContainerView.contentScrollView.scrollEnabled = NO;
    [self.view addSubview:_listContainerView];
    
    JXCategoryIndicatorBackgroundView *backgroundView = [[JXCategoryIndicatorBackgroundView alloc] init];
    backgroundView.indicatorHeight = 35;
    backgroundView.indicatorWidthIncrement = 0;
    backgroundView.indicatorColor = MainColor;
    
    //相当于把JXCategoryIndicatorBackgroundView当做视图容器，你可以在上面添加任何想要的效果
    JXGradientView *gradientView = [JXGradientView new];
    gradientView.gradientLayer.endPoint = CGPointMake(1, 0);
    gradientView.gradientLayer.colors = @[(__bridge id)MainColor.CGColor, (__bridge id)rgba(255, 221, 148, 1).CGColor,];
    //设置gradientView布局和JXCategoryIndicatorBackgroundView一样
    gradientView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [backgroundView addSubview:gradientView];
    backgroundView.layer.masksToBounds = YES;
    self.myCategoryView.indicators = @[backgroundView];
    
    [self.view  addSubview:self.myCategoryView];
}
   
- (JXCategoryListContainerView *)listContainerView {
    if (_listContainerView == nil) {
        _listContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
    }
    return _listContainerView;
}

#pragma mark - JXCategoryListContainerViewDelegate

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    MyOrderChildViewController *list = [[MyOrderChildViewController alloc] initWithMyOrderType:index];
    return list;
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.dataArray.count;
}

@end

#pragma mark - childVC
@interface MyOrderChildViewController ()<MyOrderCellDelegate>
{
    
}
@property(nonatomic, assign)MyOrderType orderType;
@end

@implementation MyOrderChildViewController

- (instancetype)initWithMyOrderType:(MyOrderType)type{
    self = [super init];
    if(self){
        self.orderType = type;
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
    self.view.backgroundColor = rgba(250, 250, 250, 1);
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - Height_NavBar -  55 - SafeAreaBottomHeight);
    [self.view addSubview:self.tableView];
    [self setMjFresh];
}

#pragma mark - netBack
- (void)initData{
    [self.tableView ly_startLoading];
    
    NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:4];
    md[@"userid"] = [WTMallUserInfo shareUserInfo].ID;
    md[@"sessionid"] = [WTMallUserInfo shareUserInfo].sessionid;
    md[@"page"] = [NSString stringWithFormat:@"%ld", (long)self.pageIndex];
    //1待付款;3待发货;4部分发货;5待收货;7已完成;默认为全部
//    state:1 待付款 3待发货 4部分发货  5待收货 7已完成  9退货申请中 11退货取消 13退货拒绝  15 退货完成 17 交易关闭
//    is_pay:0未支付,1已支付
//    order_type:订单类型: 0实体商品 1虚拟商品
//    deliver_type:运输类型 0快递 1自提
    switch (self.orderType) {
        case MyOrderTypeAll:
        {
            md[@"types"] = @"0";
        }
            break;
        case MyOrderTypeWaitPay:
        {
            md[@"types"] = @"1";
        }
            break;
        case MyOrderTypeWaitShip:
        {
            md[@"types"] = @"3";
        }
            break;
        case MyOrderTypeShipped:
        {
            md[@"types"] = @"5";
        }
            break;
        case MyOrderTypeOver:
        {
            md[@"types"] = @"7";
        }
            break;
    }
    [self.afnetWork jsonMallPostDict:@"/api/order/orderList" JsonDict:md Tag:@"1" LoadingInView:self.view];
     
}

- (void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    if([type isEqualToString:@"1"]){
        [self.tableView ly_endLoading];
             
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
       
        if(self.isRefresh){
             self.dataArray=[[NSMutableArray alloc]init];
        }
        for (NSDictionary *dic in dict[@"data"][@"infos"]) {
            MyOrderModel *model = [MyOrderModel yy_modelWithDictionary:dic];
            [self.dataArray addObject:model];
            
        }
          
        self.allPages = [dict[@"data"][@"allPage"] integerValue];
        [self.tableView reloadData];
    }else if([type isEqualToString:@"2"]){//取消订单
        printAlert(dict[@"msg"], 1.f);
        [self.tableView.mj_header beginRefreshing];
    }else if([type isEqualToString:@"3"]){//退货
        printAlert(dict[@"msg"], 1.f);
        [self.tableView.mj_header beginRefreshing];
    }else if([type isEqualToString:@"4"]){//签收
        printAlert(dict[@"msg"], 1.f);
        [self.tableView.mj_header beginRefreshing];
    }else if([type isEqualToString:@"5"]){//取消显示订单
        printAlert(dict[@"msg"], 1.f);
        [self.tableView.mj_header beginRefreshing];
    }
}

#pragma mark - MyOrderCellDelegate
/// 签收
- (void)signForClick:(UIButton *)btn{
    UIAlertController *ua = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认签收" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ua1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *ua2 = [UIAlertAction actionWithTitle:@"签收" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSIndexPath * indexpath = [self getButtonConvertPoint:btn];
        MyOrderModel *model = self.dataArray[indexpath.section];
        NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:3];
        md[@"userid"] = [WTMallUserInfo shareUserInfo].ID;
        md[@"sessionid"] = [WTMallUserInfo shareUserInfo].sessionid;
        md[@"id"] = model.orderID;
        [self.afnetWork jsonMallPostDict:@"/api/order/orderReceive" JsonDict:md Tag:@"4"];
    }];
    [ua addAction:ua1];
    [ua addAction:ua2];
    [self presentViewController:ua animated:YES completion:nil];
}

/// 退货
- (void)returnClick:(UIButton *)btn{
    MyOrderReturnPopView *returnView = [[MyOrderReturnPopView alloc] initWithFrame:CGRectMake(ScreenWidth*0.1, 0, ScreenWidth * 0.8, 211 + 54)];
    LSTPopView *popView = [LSTPopView initWithCustomView:returnView];
    [popView pop];
    @weakify(popView)
    returnView.closePopViewBlock = ^{
        @strongify(popView)
        [popView dismiss];
    };
    @weakify(self)
    returnView.returnGoodsBlock = ^(NSString * _Nonnull returnReason) {
        @strongify(self)
        NSIndexPath * indexpath = [self getButtonConvertPoint:btn];
        MyOrderModel *model = self.dataArray[indexpath.section];
        NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:3];
        md[@"userid"] = [WTMallUserInfo shareUserInfo].ID;
        md[@"sessionid"] = [WTMallUserInfo shareUserInfo].sessionid;
        md[@"id"] = model.orderID;
        md[@"content"] = returnReason;
        [self.afnetWork jsonMallPostDict:@"/api/order/orderReturn" JsonDict:md Tag:@"3"];
        
        @strongify(popView)
        [popView dismiss];
    };
}
  
/// 付款
- (void)payClick:(UIButton *)btn{
    [self jumpOrderDetialsVC:[self getButtonConvertPoint:btn]];
}

/// 取消订单
/// @param btn 按钮
- (void)cancelClick:(UIButton *)btn{
    UIAlertController *ua = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定取消订单" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ua1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *ua2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSIndexPath * indexpath = [self getButtonConvertPoint:btn];
        MyOrderModel *model = self.dataArray[indexpath.section];
        NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:3];
        md[@"userid"] = [WTMallUserInfo shareUserInfo].ID;
        md[@"sessionid"] = [WTMallUserInfo shareUserInfo].sessionid;
        md[@"id"] = model.orderID;
        [self.afnetWork jsonMallPostDict:@"/api/order/orderCancel" JsonDict:md Tag:@"2"];
    }];
    [ua addAction:ua1];
    [ua addAction:ua2];
    [self presentViewController:ua animated:YES completion:nil];
}

/// 取消显示
/// @param btn 按钮
- (void)cancelShowClick:(UIButton *)btn{
    UIAlertController *ua = [UIAlertController alertControllerWithTitle:@"删除订单" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ua1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *ua2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSIndexPath * indexpath = [self getButtonConvertPoint:btn];
        MyOrderModel *model = self.dataArray[indexpath.section];
        NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:3];
        md[@"userid"] = [WTMallUserInfo shareUserInfo].ID;
        md[@"sessionid"] = [WTMallUserInfo shareUserInfo].sessionid;
        md[@"id"] = model.orderID;
        [self.afnetWork jsonMallPostDict:@"/api/order/cancelShowOrder" JsonDict:md Tag:@"5"];
    }];
    [ua addAction:ua1];
    [ua addAction:ua2];
    [self presentViewController:ua animated:YES completion:nil];
}

#pragma mark - privateMethod
- (void)jumpOrderDetialsVC:(NSIndexPath *)indexpath {
    if(self.dataArray.count>0){
        MyOrderModel *model = self.dataArray[indexpath.section];
        if(model.orderID){
            OrderDetialsViewController *o = [[OrderDetialsViewController alloc] initWithOrderID:model.orderID];
            [self.navigationController pushViewController:o animated:YES];
        }else{
                printAlert(@"无效订单", 1.f);
        }
    }
}

- (NSIndexPath *)getButtonConvertPoint:(UIButton * _Nonnull)btn {
    CGPoint point = btn.center;
    point = [self.tableView convertPoint:point fromView:btn.superview];
    NSIndexPath  *indexpath = [self.tableView indexPathForRowAtPoint:point];
    return indexpath;
}

#pragma mark - tableViewDelegate
- (void)setCellData:(UITableViewCell *)cell indexPath:(NSIndexPath * _Nonnull)indexPath {
    if(self.dataArray.count>0){
        MyOrderModel *model = self.dataArray[indexPath.section];
        
        BOOL isLastRow = false;
        if(indexPath.row == [self.tableView numberOfRowsInSection:indexPath.section] - 1){
            isLastRow = YES;
        }
        
        [(MyOrderCell *)cell setCellData:self.dataArray[indexPath.section] GoodsInfoModel:model.good_info[indexPath.row] orderType:self.orderType isLastRow:isLastRow];
    }
    [(MyOrderCell *) cell setDelegate:self];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{ 
    static NSString *identifier1 = @"cell1";
    static NSString *identifier2 = @"cell2";
    static NSString *identifier3 = @"cell3";
    static NSString *identifier4 = @"cell4";
    static NSString *identifier5 = @"cell5";
    [self.tableView registerClass:[MyOrderCellWaitPay class] forCellReuseIdentifier:identifier1];
    [self.tableView registerClass:[MyOrderCellWaitShip class] forCellReuseIdentifier:identifier2];
    [self.tableView registerClass:[MyOrderCellShipped class] forCellReuseIdentifier:identifier3];
    [self.tableView registerClass:[MyOrderCellOver class] forCellReuseIdentifier:identifier4];
    [self.tableView registerClass:[MyOrderCellOther class] forCellReuseIdentifier:identifier5];
     
    switch (self.orderType) {
        case MyOrderTypeAll:
        {
            MyOrderModel *orderModel = self.dataArray[indexPath.section];
            switch ([orderModel.state integerValue]) {
                case 1://待支付
                {
                    MyOrderCellWaitPay *cell = (MyOrderCellWaitPay *)[tableView dequeueReusableCellWithIdentifier:identifier1 forIndexPath:indexPath];
                    [self setCellData:(MyOrderCellWaitPay *)cell indexPath:indexPath];
                    
                    return cell;
                }
                case 3://待发货
                {
                    MyOrderCellWaitShip *cell = (MyOrderCellWaitShip *)[tableView dequeueReusableCellWithIdentifier:identifier2 forIndexPath:indexPath];
                    [self setCellData:cell indexPath:indexPath];
                    return cell;
                }
                case 5: //已发货
                {
                    MyOrderCellShipped *cell = (MyOrderCellShipped *)[tableView dequeueReusableCellWithIdentifier:identifier3 forIndexPath:indexPath];
                    [self setCellData:cell indexPath:indexPath];
                    return cell;
                }
                case 7: //已完成
                {
                    MyOrderCellOver *cell = (MyOrderCellOver *)[tableView dequeueReusableCellWithIdentifier:identifier4 forIndexPath:indexPath];
                    [self setCellData:cell indexPath:indexPath];
                    return cell;
                }
                case 9://退货申请中
//                {
//                    MyOrderCellOther *cell = (MyOrderCellOther *)[tableView dequeueReusableCellWithIdentifier:identifier5 forIndexPath:indexPath];
//                    [self setCellData:cell indexPath:indexPath];
//                    [cell.stateButton setTitle:orderModel.state_info forState:UIControlStateNormal];
//                    [cell.stateButton mas_updateConstraints:^(MASConstraintMaker *make) {
//                        make.width.mas_equalTo([HelpManager getLabelWidth:12 labelTxt:cell.stateButton.titleLabel.text].width + 25);
//                    }];
//                    return cell;
//                }
                case 17://交易关闭
                default:
                {
                    MyOrderCellOther *cell = (MyOrderCellOther *)[tableView dequeueReusableCellWithIdentifier:identifier5 forIndexPath:indexPath];
                    [self setCellData:(MyOrderCellWaitPay *)cell indexPath:indexPath];
                    [cell.stateButton setTitle:orderModel.state_info forState:UIControlStateNormal];
                    [cell.stateButton mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.width.mas_equalTo([HelpManager getLabelWidth:12 labelTxt:cell.stateButton.titleLabel.text].width + 25);
                    }];
                    return cell;
                }
            }
        }
        case MyOrderTypeWaitPay:
        {
            MyOrderCellWaitPay *cell = (MyOrderCellWaitPay *)[tableView dequeueReusableCellWithIdentifier:identifier1 forIndexPath:indexPath];
            [self setCellData:(MyOrderCellWaitPay *)cell indexPath:indexPath];
            return cell;
        }
            
        case MyOrderTypeWaitShip:
        {
            MyOrderCellWaitShip *cell = (MyOrderCellWaitShip *)[tableView dequeueReusableCellWithIdentifier:identifier2 forIndexPath:indexPath];
            [self setCellData:cell indexPath:indexPath];
            return cell;
        }
            
        case MyOrderTypeShipped:
        {
            MyOrderCellShipped *cell = (MyOrderCellShipped *)[tableView dequeueReusableCellWithIdentifier:identifier3 forIndexPath:indexPath];
            [self setCellData:cell indexPath:indexPath];
            return cell;
        }
           
        default:
        {
            MyOrderCellOver *cell = (MyOrderCellOver *)[tableView dequeueReusableCellWithIdentifier:identifier4 forIndexPath:indexPath];
            [self setCellData:cell indexPath:indexPath];
            return cell;
        }
    }
     
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self jumpOrderDetialsVC:indexPath];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    MyOrderModel *model = self.dataArray[section];
    return model.good_info.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *bacView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 15)];
    return bacView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // 圆角角度
    CGFloat radius = 5;
    // 设置cell 背景色为透明
    cell.backgroundColor = UIColor.clearColor;
    // 创建两个layer
    CAShapeLayer *normalLayer = [[CAShapeLayer alloc] init];
    CAShapeLayer *selectLayer = [[CAShapeLayer alloc] init];
    // 获取显示区域大小
    CGRect bounds = CGRectInset(cell.bounds, 15, 0);
    // cell的backgroundView
    UIView *normalBgView = [[UIView alloc] initWithFrame:bounds];
    // 获取每组行数
    NSInteger rowNum = [tableView numberOfRowsInSection:indexPath.section];
    // 贝塞尔曲线
    UIBezierPath *bezierPath = nil;
  
    if (rowNum == 1) {
        // 一组只有一行（四个角全部为圆角）
        bezierPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, radius)];
        normalBgView.clipsToBounds = NO;
    }else {
        if (indexPath.row == 0) {
            normalBgView.clipsToBounds = YES;
            normalBgView.frame = UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(-5, 0, 0, 0));
            CGRect rect = UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(5, 0, 0, 0));
            // 每组第一行（添加左上和右上的圆角）
            bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight) cornerRadii:CGSizeMake(radius, radius)];
        }else if (indexPath.row == rowNum - 1) {
            normalBgView.frame = UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(0, 0, -5, 0));
            CGRect rect = UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(0, 0, 5, 0));
            // 每组最后一行（添加左下和右下的圆角）
            bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight) cornerRadii:CGSizeMake(radius, radius)];
            normalBgView.clipsToBounds = NO;
        }else {
            // 每组不是首位的行不设置圆角
            normalBgView.clipsToBounds = YES;
            bezierPath = [UIBezierPath bezierPathWithRect:bounds];
            
        }
    }
    
    // 阴影
    normalLayer.shadowColor = [UIColor colorWithRed:153/255.0 green:174/255.0 blue:223/255.0 alpha:0.2].CGColor;
    normalLayer.shadowOffset = CGSizeMake(0,5);
    normalLayer.shadowOpacity = 1;
    normalLayer.shadowRadius = 9;
    normalLayer.cornerRadius = 5;
    normalLayer.shadowPath = bezierPath.CGPath;
    
    // 把已经绘制好的贝塞尔曲线路径赋值给图层，然后图层根据path进行图像渲染render
    normalLayer.path = bezierPath.CGPath;
    selectLayer.path = bezierPath.CGPath;
    
    // 设置填充颜色
    normalLayer.fillColor = [UIColor whiteColor].CGColor;
    // 添加图层到nomarBgView中
    [normalBgView.layer insertSublayer:normalLayer atIndex:0];
    normalBgView.backgroundColor = UIColor.clearColor;
    cell.backgroundView = normalBgView;
    
   
}

#pragma mark - JXCategoryListContentViewDelegate

- (UIView *)listView {
    return self.view;
}

@end

 
@implementation JXGradientView

+ (Class)layerClass {
    return [CAGradientLayer class];
}

- (CAGradientLayer *)gradientLayer {
    return (CAGradientLayer *)self.layer;
}

@end
