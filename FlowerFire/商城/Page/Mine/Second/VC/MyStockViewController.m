//
//  MyStockViewController.m
//  531Mall
//
//  Created by 王涛 on 2020/5/21.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "MyStockViewController.h"
#import "UIImage+jianbianImage.h"
#import "MyStockCell.h"
#import "MyStockPickUpPopView.h"
#import <LSTPopView.h>
#import "MyStockModel.h"

@interface MyStockViewController ()
{
    UILabel *_shopOne,*_shopTwo,*_shopThree;
}
@property(nonatomic, strong)NSArray<MyStockSkuInfoModel *> *stockInfoArray;
@end

@implementation MyStockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavBar];
    [self createUI];
    [self initData];
}

#pragma mark - action
-(void)jumpPickUpClick{
    // - 80 去掉密码输入框的高度
    MyStockPickUpPopView *stockPickView = [[MyStockPickUpPopView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth * 0.8, 420 + 54 - 80) stockInfoArray:self.stockInfoArray];
    stockPickView.currentVC = self;
    LSTPopView *popView = [LSTPopView initWithCustomView:stockPickView parentView:self.view popStyle:LSTPopStyleSpringFromTop dismissStyle:LSTDismissStyleCardDropToTop];
    
    [popView pop];
    @weakify(popView)
    stockPickView.closePopViewBlock = ^{
        @strongify(popView)
        [popView dismiss];
    };
    @weakify(self)
    stockPickView.backFreshBlock = ^{
        @strongify(self)
        @strongify(popView)
        [popView dismiss];
        [self.tableView.mj_header beginRefreshing];
    };
}

#pragma mark - dataSource
- (void)initData{
    NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:4];
    md[@"userid"] = [WTMallUserInfo shareUserInfo].ID;
    md[@"sessionid"] = [WTMallUserInfo shareUserInfo].sessionid;
    md[@"page"] =  [NSString stringWithFormat:@"%ld", (long)self.pageIndex];
    md[@"number"] = @"";
    [self.afnetWork jsonMallPostDict:@"/api/order/skuInfo" JsonDict:md Tag:@"1"];
}

- (void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    if([type isEqualToString:@"1"]){
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if(dict[@"data"] != [NSNull null]){
            if(self.isRefresh){
                self.dataArray = [[NSMutableArray alloc]init];
           }
          
            MyStockModel *stockModel = [MyStockModel yy_modelWithDictionary:dict[@"data"]];
             
            for (MyStockSkuListModel *listModel in stockModel.sku_list) {
                [self.dataArray addObject:listModel];
            }
            
            self.allPages = [dict[@"data"][@"allPage"] integerValue];
                     
            NSInteger stockInfoCount = stockModel.sku_info.count;
            NSMutableArray<MyStockSkuInfoModel *> *skuInfoArray = [NSMutableArray arrayWithArray:stockModel.sku_info];
            if(stockInfoCount<3){ //数据不够3个，那就自己制造上3个
                for (NSInteger i = stockInfoCount; i<3; i++) {
                    MyStockSkuInfoModel *model = [MyStockSkuInfoModel new];
                    model.name = @"--";
                    model.stock = @"0"; 
                    [skuInfoArray  addObject:model];
                }
            }
            
            self.stockInfoArray = skuInfoArray;
            
            NSString *_sumPriceStr = NSStringFormat(@"%@\n%@",skuInfoArray[0].stock,skuInfoArray[0].name);
            NSString *_todayPriceStr = NSStringFormat(@"%@\n%@",skuInfoArray[1].stock,skuInfoArray[1].name);
            NSString *_threePriceStr = NSStringFormat(@"%@\n%@",skuInfoArray[2].stock,skuInfoArray[2].name);
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = 2;
            paragraphStyle.alignment = NSTextAlignmentCenter;
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_sumPriceStr attributes:@{NSParagraphStyleAttributeName:paragraphStyle}];
            [attributedString addAttributes:@{NSFontAttributeName:tFont(30)} range:[_sumPriceStr rangeOfString:skuInfoArray[0].stock]];
            _shopOne.attributedText = attributedString;
            
            attributedString = [[NSMutableAttributedString alloc] initWithString:_todayPriceStr attributes:@{NSParagraphStyleAttributeName:paragraphStyle}];
            [attributedString addAttributes:@{NSFontAttributeName:tFont(30)} range:[_todayPriceStr rangeOfString:skuInfoArray[1].stock]];
            _shopTwo.attributedText = attributedString;
            
            attributedString = [[NSMutableAttributedString alloc] initWithString:_threePriceStr attributes:@{NSParagraphStyleAttributeName:paragraphStyle}];
            [attributedString addAttributes:@{NSFontAttributeName:tFont(30)} range:[_threePriceStr rangeOfString:skuInfoArray[2].stock]];
            _shopThree.attributedText = attributedString;
            
            [self.tableView reloadData];
        }
        
    }
}

#pragma mark - tableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    [self.tableView registerClass:[MyStockCell class] forCellReuseIdentifier:identifier];
    MyStockCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if(self.dataArray.count >0){
        [cell setCellData:self.dataArray[indexPath.row]];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (void)createNavBar{
    self.gk_navigationBar.hidden = YES;
}

- (void)createUI{
    CGFloat labelHegiht = 30;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ceil(ScreenWidth/1.875)+labelHegiht + 15)];
    
    UIImageView *cover = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, headerView.height)];
    cover.contentMode = UIViewContentModeScaleAspectFill;
    cover.clipsToBounds = YES;
    cover.image = [UIImage gradientColorImageFromColors:MaingradientColor gradientType:GradientTypeLeftToRight imgSize:headerView.size];
    [headerView addSubview:cover];
     
    UIButton *dissmissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    dissmissBtn.titleLabel.font = tFont(15);
    [dissmissBtn setImage:[UIImage gk_imageNamed:@"btn_back_white"] forState:UIControlStateNormal];
    [dissmissBtn addTarget:self action:@selector(backItemClick:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:dissmissBtn];

    dissmissBtn.frame = CGRectMake(OverAllLeft_OR_RightSpace, Height_StatusBar  , 30, 30);
 
    UILabel *title = [UILabel new];
    title.text = @"我的库存";
    title.textColor = KWhiteColor;
    title.font = tFont(17);
    [headerView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(headerView.mas_centerX);
        make.centerY.mas_equalTo(dissmissBtn.mas_centerY);
    }];
    
    UIButton *jumpShareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    jumpShareButton.frame = CGRectMake(ScreenWidth - 20 - 80, dissmissBtn.ly_maxY + 15, 80, 30);
    [jumpShareButton setBackgroundImage:[UIImage gradientColorImageFromColors:@[rgba(254, 213, 132, 1),rgba(255, 230, 181, 1)] gradientType:GradientTypeLeftToRight imgSize:CGSizeMake(80, 30)] forState:UIControlStateNormal];
    [jumpShareButton addTarget:self action:@selector(jumpPickUpClick) forControlEvents:UIControlEventTouchUpInside];
    jumpShareButton.layer.cornerRadius = 15;
    jumpShareButton.layer.masksToBounds = YES;
    jumpShareButton.titleLabel.font = tFont(13);
    [jumpShareButton setTitleColor:MainColor forState:UIControlStateNormal];
    [jumpShareButton setTitle:@"申请提货" forState:UIControlStateNormal];
    [headerView addSubview:jumpShareButton];
    
    _shopOne = [[UILabel alloc] init];
    _shopOne.textColor = KWhiteColor;
    _shopOne.font = tFont(11);
    _shopOne.numberOfLines = 0;
    _shopOne.text = @"--";
    [headerView addSubview:_shopOne];
    
    _shopTwo = [[UILabel alloc] init];
    _shopTwo.textColor = KWhiteColor;
    _shopTwo.font = tFont(11);
    _shopTwo.text = @"--";
    _shopTwo.numberOfLines = 0;
    [headerView addSubview:_shopTwo];
     
    _shopThree = [[UILabel alloc] init];
    _shopThree.textColor = KWhiteColor;
    _shopThree.font = tFont(11);
    _shopThree.text = @"--";
    _shopThree.numberOfLines = 0;
    [headerView addSubview:_shopThree];
    
    [_shopOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ScreenWidth/6);
        make.top.mas_equalTo(jumpShareButton.mas_bottom).offset(20);
    }];
    
    [_shopTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(headerView.mas_centerX);
        make.centerY.mas_equalTo(_shopOne.mas_centerY);
    }];
    
    [_shopThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-ScreenWidth/6);
        make.centerY.mas_equalTo(_shopOne.mas_centerY);
    }];
    
    NSArray *labelArray = @[@"时间",@"来源",@"产品名称",@"数量"];
    for (int i = 0; i<labelArray.count; i++) {
        CGFloat labelWidth = ScreenWidth/labelArray.count;
        UILabel *la = [UILabel new];
        la.text = labelArray[i];
        la.textColor = rgba(51, 51, 51, 1);
        la.font = tFont(13);
        la.textAlignment = NSTextAlignmentCenter;
        la.backgroundColor = rgba(255, 221, 148, 1);
        la.frame = CGRectMake(labelWidth * i, headerView.height - labelHegiht, labelWidth, labelHegiht);
        [headerView addSubview:la];
    }
    
    self.tableView.frame = CGRectMake(0, -Height_StatusBar, ScreenWidth, ScreenHeight+Height_StatusBar);
    self.tableView.rowHeight = 50;
    self.tableView.tableHeaderView = headerView;
    [self.view addSubview:self.tableView];
    
    [self setMjFresh];
}
 


@end
