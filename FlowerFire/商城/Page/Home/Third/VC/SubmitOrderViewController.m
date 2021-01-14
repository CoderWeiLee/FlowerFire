//
//  SubmitOrderViewController.m
//  531Mall
//
//  Created by 王涛 on 2020/5/23.
//  Copyright © 2020 Celery. All rights reserved.
//  提交订单

#import "SubmitOrderViewController.h"
#import "SubmitOrderHeaderView.h"
#import "AddressManagerViewController.h"
#import "SubmitOrderCell.h"
#import "SubmitOrderSectionFooterView.h"
#import "SubmitPayPopView.h"
#import <LSTPopView.h>
#import "AddressInfoModel.h"
#import "OrderDetialsViewController.h"

static const CGFloat cellHeight = 80;
static const CGFloat sectionBottomHeight = 50;

@interface SubmitOrderViewController ()//<SubmitPayPopViewDelegate>
{
    UILabel  *_sumLabel;
    UIButton *_backButton;
    
}
@property(nonatomic, strong)SubmitOrderHeaderView           *hederView;
@property(nonatomic, strong)SubmitOrderSectionFooterView    *sectionFooterView;
@property(nonatomic, strong)AddressInfoModel                *addressInfoModel;
@property(nonatomic, assign)SubmitOrderWereJump             submitOrderWereJump;
@end

@implementation SubmitOrderViewController
 
- (instancetype)initWithSubmitOrderWereJump:(SubmitOrderWereJump )submitOrderWereJump{
    self = [super init];
    if(self){
        self.submitOrderWereJump = submitOrderWereJump;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
     
    [self createNavBar];
    [self createUI];
}

#pragma mark - action
-(void)submitClick{ //掉用订单提交接口
    NSMutableArray *cartId = [NSMutableArray array];
    for (NSDictionary *dic in self.dataArray) {
        [cartId addObject:dic[@"id"]];
    }
    NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:4];
    md[@"userid"] = [WTMallUserInfo shareUserInfo].ID;
    md[@"sessionid"] = [WTMallUserInfo shareUserInfo].sessionid;
    md[@"cart_id"] = cartId;
    md[@"address_id"] = self.addressInfoModel.AddressId;
    [self.afnetWork jsonMallPostDict:@"/api/order/orderSubmit" JsonDict:md Tag:@"2" LoadingInView:self.view];

}
#pragma makr - SubmitPayPopViewDelegate
//- (void)choosePayMethodClick:(UIButton *)btn{
//    UIAlertController *ua = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//      UIAlertAction *ua1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//      UIAlertAction *ua2 = [UIAlertAction actionWithTitle:@"微信" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//          [btn setTitle:@"微信支付>" forState:UIControlStateNormal];
//      }];
//    UIAlertAction *ua3 = [UIAlertAction actionWithTitle:@"支付宝" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//          [btn setTitle:@"支付宝支付>" forState:UIControlStateNormal];
//    }];
//      [ua addAction:ua1];
//      [ua addAction:ua2];
//      [ua addAction:ua3];
//      [self presentViewController:ua animated:YES completion:nil];
//}

- (void)createNavBar{
    self.gk_navigationBar.hidden = YES;
}

- (void)createUI{

    self.view.backgroundColor = KWhiteColor;
    
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backButton addTarget:self action:@selector(backItemClick:) forControlEvents:UIControlEventTouchUpInside];
    _backButton.frame = CGRectMake(OverAllLeft_OR_RightSpace, SafeIS_IPHONE_X, 10.5, 18.85);
    [self.view addSubview:_backButton];
    [_backButton setImage:[UIImage gk_imageNamed:@"btn_back_white"] forState:UIControlStateNormal];
    
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    self.tableView.layer.shadowColor = [UIColor colorWithRed:153/255.0 green:174/255.0 blue:223/255.0 alpha:0.2].CGColor;
    self.tableView.layer.shadowOffset = CGSizeMake(0,5);
    self.tableView.layer.shadowOpacity = 1;
    self.tableView.layer.shadowRadius = 9;
    self.tableView.layer.cornerRadius = 5;
    self.tableView.clipsToBounds = NO; //默认是yes，设为no才有阴影
    self.tableView.bounces = NO;
    [self.tableView setEmptyViewContentViewY:50];
     
    _sumLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, ScreenHeight - SafeAreaBottomHeight - 45, ScreenWidth * 0.62, 45)];
    _sumLabel.text = @"合计:  --元";
    _sumLabel.textColor = rgba(51, 51, 51, 1);
    _sumLabel.font = tFont(15);
    _sumLabel.backgroundColor = rgba(244, 244, 244, 1);
    _sumLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_sumLabel];
    
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitButton setTitle:@"提交订单" forState:UIControlStateNormal];
    [submitButton setFrame:CGRectMake(_sumLabel.ly_maxX, _sumLabel.ly_y, ScreenWidth-_sumLabel.width, _sumLabel.height)];
    [[HelpManager sharedHelpManager] jianbianMainColor:submitButton size:submitButton.size];
    [submitButton.titleLabel setFont:tFont(15)];
    [self.view addSubview:submitButton];
    
    [submitButton addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
     
}

#pragma mark - datasouce
- (void)initData{
    switch (self.submitOrderWereJump) {
        case SubmitOrderWereJumpBuy:
        {
            NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:2];
            md[@"userid"] = [WTMallUserInfo shareUserInfo].ID;
            md[@"sessionid"] = [WTMallUserInfo shareUserInfo].sessionid;
            md[@"sku_id"] = self.skuID;
            md[@"amount"] = self.amount;
            [self.afnetWork jsonMallPostDict:@"/api/order/orderConfirm" JsonDict:md Tag:@"1" LoadingInView:self.view];
        }
            break;
        default:
        {
            NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:2];
            md[@"userid"] = [WTMallUserInfo shareUserInfo].ID;
            md[@"sessionid"] = [WTMallUserInfo shareUserInfo].sessionid;
            [self.afnetWork jsonMallPostDict:@"/api/order/orderConfirm" JsonDict:md Tag:@"1" LoadingInView:self.view];
        }
            break;
    }
    [self.tableView ly_startLoading];
     
}

- (void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    if([type isEqualToString:@"1"]){//进入确认订单
        [self.tableView ly_endLoading];
        [self.tableView.mj_header endRefreshing];
        [self.dataArray removeAllObjects];
        for (NSDictionary *dic in dict[@"data"][@"infos"]) {
            [self.dataArray addObject:dic];
        }
        self.addressInfoModel = [AddressInfoModel yy_modelWithDictionary:dict[@"data"][@"default_address"]];
      
        NSInteger tableViewCellNum;
        if(self.dataArray.count>4){
            tableViewCellNum = 4;
        }else{
            tableViewCellNum = self.dataArray.count;
        }
        
        if(self.addressInfoModel){
            [self.hederView layoutHasAddress:self.addressInfoModel];
        }else{
            [self.hederView layoutNoAddress];
        }
        
        self.tableView.frame = CGRectMake(OverAllLeft_OR_RightSpace, self.hederView.height-20, ScreenWidth - 2 *OverAllLeft_OR_RightSpace , cellHeight * tableViewCellNum + sectionBottomHeight);
        self.tableView.contentSize = CGSizeMake(ScreenWidth - 2 *OverAllLeft_OR_RightSpace , cellHeight * self.dataArray.count + sectionBottomHeight);
        [self.tableView reloadData];
        
        [self.view bringSubviewToFront:self.tableView];
        [self.view bringSubviewToFront:_backButton];
        
        NSInteger num = 0;
        //去除返回的带逗号的价格
        NSString *threeTotalPrice = [NSStringFormat(@"%@",dict[@"data"][@"three_total_price"]) stringByReplacingOccurrencesOfString:@"," withString:@""];
        NSString *sumPriceStr = [NSStringFormat(@"%@",dict[@"data"][@"total_price"]) stringByReplacingOccurrencesOfString:@"," withString:@""];
        if([threeTotalPrice doubleValue] != 0){
            sumPriceStr = NSStringFormat(@"%@ + %@券",sumPriceStr,threeTotalPrice);
        }
        
        for (NSDictionary *dic in self.dataArray) {
            num += [dic[@"amount"] integerValue];
        }
        
        NSString *labelStr = NSStringFormat(@"共%ld件商品 小计:¥%@",(long)num,sumPriceStr);
        NSMutableAttributedString *ma = [[NSMutableAttributedString alloc] initWithString:labelStr];
        [ma addAttributes:@{NSForegroundColorAttributeName:MainColor} range:[labelStr rangeOfString:NSStringFormat(@"¥%@",sumPriceStr)]];
        
        if([threeTotalPrice doubleValue] != 0){
            [ma addAttributes:@{NSForegroundColorAttributeName:MainYellowColor} range:[labelStr rangeOfString:NSStringFormat(@"%@券",threeTotalPrice)]];
            [ma addAttributes:@{NSForegroundColorAttributeName:KBlackColor} range:[labelStr rangeOfString:@"+"]];
             
        }
       
        self.sectionFooterView.buyNumLabel.attributedText = ma;
        
        labelStr = NSStringFormat(@"合计:  ¥%@",sumPriceStr);
        ma = [[NSMutableAttributedString alloc] initWithString:labelStr];
        [ma addAttributes:@{NSForegroundColorAttributeName:MainColor} range:[labelStr rangeOfString:NSStringFormat(@"¥%@",sumPriceStr)]];
        if([threeTotalPrice doubleValue] != 0){
            [ma addAttributes:@{NSForegroundColorAttributeName:MainYellowColor} range:[labelStr rangeOfString:NSStringFormat(@"%@券",threeTotalPrice)]];
            [ma addAttributes:@{NSForegroundColorAttributeName:KBlackColor} range:[labelStr rangeOfString:@"+"]];
        }
        
        _sumLabel.attributedText = ma;
    }else if([type isEqualToString:@"2"]){ //提交订单，获取到订单号，在用订单号查询付款信息
        OrderDetialsViewController *ovc = [[OrderDetialsViewController alloc] initWithOrderID:NSStringFormat(@"%@",dict[@"data"][@"id"])]; 
        [[WTPageRouterManager sharedInstance] pushNextCloseCurrentViewController:self nextVC:ovc];
    }
 
}

#pragma mark - tableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    [self.tableView registerClass:[SubmitOrderCell class] forCellReuseIdentifier:identifier];
    SubmitOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if(self.dataArray.count>0){
        [cell setCellData:self.dataArray[indexPath.row]];
    }
     
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellHeight;
}
 
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return self.sectionFooterView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return sectionBottomHeight;
}

-(SubmitOrderHeaderView *)hederView{
    if (!_hederView) {
        _hederView = [[SubmitOrderHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ceil(ScreenWidth/2.12))];
        [self.view addSubview:_hederView];
        @weakify(self)
        _hederView.chooseAddressBlock = ^{
            @strongify(self)
           
            AddressManagerViewController *avc = [AddressManagerViewController new];
            avc.noHasAddressBlock = ^{
                [self->_hederView layoutNoAddress];
            };
            @weakify(avc)
            avc.didSelectedAddressBlock = ^(AddressInfoModel * _Nullable model) {
                @strongify(self)
                @strongify(avc)
                [avc closeVC];
                [self->_hederView layoutHasAddress:model];
            };
            [self.navigationController pushViewController:avc animated:YES];
        };
      

    }
    return _hederView;
}

-(SubmitOrderSectionFooterView *)sectionFooterView{
    if(!_sectionFooterView){
        _sectionFooterView = [[SubmitOrderSectionFooterView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    }
    return _sectionFooterView;
}

@end
