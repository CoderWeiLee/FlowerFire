//
//  MyWalletViewController.m
//  531Mall
//
//  Created by 王涛 on 2020/5/20.
//  Copyright © 2020 Celery. All rights reserved.
//。我的钱包

#import "MyWalletViewController.h"
#import "RechargeViewController.h"
#import "WithrdawViewController.h"
#import "TransferPopView.h"
#import <LSTPopView.h>
#import "WalletDetailsListViewController.h"
#import "MyWalletModel.h"

@interface MyWalletViewController ()<MyWalletCellDelegate>

@end

@implementation MyWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavBar];
    [self createUI];
    [self initData];
}

- (void)createNavBar{
    self.gk_navItemRightSpace = 10;
    self.gk_navBackgroundColor = rgba(250, 250, 250, 1);
    self.gk_statusBarStyle = UIStatusBarStyleDefault;
    self.gk_navigationItem.title = @"我的钱包";
    self.gk_navRightBarButtonItem = [UIBarButtonItem gk_itemWithTitle:@"明细" target:self action:@selector(jumpWalletDetailsVC)];
    
}
 
-(void)createUI{
    self.tableView.bounces = NO;
    self.tableView.frame = CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight - Height_NavBar);
    self.tableView.rowHeight = 130 + OverAllLeft_OR_RightSpace;
    [self.view addSubview:self.tableView];
}

#pragma mark - dataSource
- (void)initData{
    NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:2];
    md[@"userid"] = [WTMallUserInfo shareUserInfo].ID;
    md[@"sessionid"] = [WTMallUserInfo shareUserInfo].sessionid;
    [self.afnetWork jsonMallPostDict:@"/api/finance/getUserWallet" JsonDict:md Tag:@"1" LoadingInView:self.view];
}

- (void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    if([type isEqualToString:@"1"]){
        if([dict[@"data"] isKindOfClass:[NSArray class]]){
            [self.dataArray removeAllObjects];
            NSArray *dataArray = dict[@"data"];
            for (int i = 0; i<dataArray.count; i++) {
                MyWalletModel * model = [MyWalletModel yy_modelWithDictionary:dict[@"data"][i]];
                NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
                switch (i) {
                    case 0:
                    {
                        dataDict[@"sheet"] = model.sheet;
                        dataDict[@"bac"] = @"q1";
                        dataDict[@"title"] = model.bankname;
                        dataDict[@"titleColor"] = KWhiteColor;
                        dataDict[@"num"] = model.balance;
                        dataDict[@"numColor"] = KWhiteColor;
                        dataDict[@"buttonArray"] = @[@{@"button":@"充值",@"buttonTitleColor":rgba(88, 88, 88, 1),@"tag":@"0"},@{@"button":@"转账",@"buttonTitleColor":rgba(88, 88, 88, 1),@"tag":@"1"},@{@"button":@"提现",@"buttonTitleColor":rgba(88, 88, 88, 1),@"tag":@"2"}];
                    }
                        break;
                    case 1:
                    {
                        dataDict[@"sheet"] = model.sheet;
                        dataDict[@"bac"] = @"q2";
                        dataDict[@"title"] = model.bankname;
                        dataDict[@"titleColor"] = rgba(88, 88, 88, 1);
                        dataDict[@"num"] = model.balance;
                        dataDict[@"numColor"] = rgba(88, 88, 88, 1);
                        dataDict[@"buttonArray"] = @[@{@"button":@"转赠股权",@"tag":@"3"},@{@"button":@"兑换购物积分",@"tag":@"4"}];
                    }
                        break;
                    default:
                    {
                        dataDict[@"sheet"] = model.sheet;
                        dataDict[@"bac"] = @"q3";
                        dataDict[@"title"] = model.bankname;
                        dataDict[@"titleColor"] = KWhiteColor;
                        dataDict[@"num"] = model.balance;
                        dataDict[@"numColor"] = KWhiteColor ;
                    }
                        break;
                }
                [self.dataArray addObject:dataDict];
            }
            [self.tableView reloadData];
        }else{
            printAlert(@"数据异常", 1.f);
        }
    }else if([type isEqualToString:@"2"]){ //转账前接口
        if(dict[@"data"] != [NSNull null]){
            TransferPopView *TransferView = [[TransferPopView alloc] initWithFrame:CGRectMake(ScreenWidth*0.1 , ScreenHeight - Height_NavBar - Height_TabBar - 270/2, ScreenWidth * 0.8, 342 + 54  ) TransferPopType:TransferPopBalance];
            NSArray *transfersArray = dict[@"data"][@"transfers"];
            TransferView.giveTitle = transfersArray.firstObject[@"title"];
            TransferView.bankName = dict[@"data"][@"sheet"];
            LSTPopView *popView = [LSTPopView initWithCustomView:TransferView parentView:self.view popStyle:LSTPopStyleSpringFromTop dismissStyle:LSTDismissStyleCardDropToTop];
            
            @weakify(popView)
            [popView pop];
            TransferView.closePopViewBlock = ^{
                @strongify(popView)
                [popView dismiss];
            };
            @weakify(self)
            TransferView.transferSuccessBlock = ^{
                @strongify(popView)
                @strongify(self)
                [self initData];
                [popView dismiss];
            };
        }else{
            printAlert(@"数据异常", 1.f);
        }

    }

   

}

#pragma mark - action
-(void)jumpWalletDetailsVC{
    WalletDetailsListViewController *wlvc = [WalletDetailsListViewController new];
    [self.navigationController pushViewController:wlvc animated:YES];
}

#pragma mark - MyWalletCellDelegate
- (void)walletButtonClick:(UIButton *)button {
    CGPoint point = button.center;
    point = [self.tableView convertPoint:point fromView:button.superview];
    NSIndexPath* indexpath = [self.tableView indexPathForRowAtPoint:point];
    NSDictionary *dataDic = self.dataArray[indexpath.row];
    switch (button.tag) {
        case 0:
        {
            RechargeViewController *rvc = [RechargeViewController new];
            rvc.balanceNumStr = dataDic[@"num"];
            rvc.bankName = dataDic[@"title"];
            [self.navigationController pushViewController:rvc animated:YES];
        }
            break;
        case 1:
        {
            NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:3];
            md[@"userid"] = [WTMallUserInfo shareUserInfo].ID;
            md[@"sessionid"] = [WTMallUserInfo shareUserInfo].sessionid;
            md[@"sheet"] = dataDic[@"sheet"];
            [self.afnetWork jsonMallPostDict:@"/api/finance/transfer" JsonDict:md Tag:@"2" LoadingInView:self.view];
        }
            break;
        case 2:
        { 
            WithrdawViewController *wvc =[WithrdawViewController new];
            wvc.balanceNumStr = dataDic[@"num"];
            wvc.bankName = dataDic[@"sheet"];
            [self.navigationController pushViewController:wvc animated:YES];
            @weakify(self)
            wvc.backFreshBlock = ^{
                @strongify(self)
                [self initData];
            };
            break;
        }
        case 3:
        {
            TransferPopView *TransferView = [[TransferPopView alloc] initWithFrame:CGRectMake(ScreenWidth*0.1 , ScreenHeight - Height_NavBar - Height_TabBar - 270/2, ScreenWidth * 0.8, 342 + 54 ) TransferPopType:TransferPopEquity];
            LSTPopView *popView = [LSTPopView initWithCustomView:TransferView parentView:self.view popStyle:LSTPopStyleSpringFromTop dismissStyle:LSTDismissStyleCardDropToTop];
            @weakify(popView)
            [popView pop];
            TransferView.closePopViewBlock = ^{
                @strongify(popView)
                [popView dismiss];
            };
            @weakify(self)
            TransferView.transferSuccessBlock = ^{
                @strongify(popView)
                @strongify(self)
                [self initData];
                [popView dismiss];
            };
        }
            break;
        default:
        {
            TransferPopView *TransferView = [[TransferPopView alloc] initWithFrame:CGRectMake(ScreenWidth*0.1 , ScreenHeight - Height_NavBar - Height_TabBar - 270/2, ScreenWidth * 0.8, 260 + 54 + 7.5 * 1) TransferPopType:TransferPopIntegralExchange];
            LSTPopView *popView = [LSTPopView initWithCustomView:TransferView parentView:self.view popStyle:LSTPopStyleSpringFromTop dismissStyle:LSTDismissStyleCardDropToTop];
            @weakify(popView)
            [popView pop];
            TransferView.closePopViewBlock = ^{
                @strongify(popView)
                [popView dismiss];
            };
            @weakify(self)
            TransferView.transferSuccessBlock = ^{
                @strongify(popView)
                @strongify(self)
                [self initData];
                [popView dismiss];
            };
        }
            break;
    }
}

#pragma mark - tableViewDelegated
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell1";
    [self.tableView registerClass:[MyWalletCell class] forCellReuseIdentifier:identifier];
    MyWalletCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.delegate = self;
    [cell setCellData:self.dataArray[indexPath.row]];
    return cell;
}
 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

@end

#pragma mark - cell
@interface MyWalletCell ()
{
    UIImageView *_bac;
    UILabel     *_title;
    NSMutableArray *_buttonArray;
}
@end

@implementation MyWalletCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        _bac = [[UIImageView alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, OverAllLeft_OR_RightSpace, ScreenWidth - OverAllLeft_OR_RightSpace * 2, 130)];
        _bac.image = [UIImage imageNamed:@"q1"];
        _bac.userInteractionEnabled = YES;
        [self addSubview:_bac];
        
        _title = [[UILabel alloc] initWithFrame:CGRectMake(20, OverAllLeft_OR_RightSpace, ScreenWidth/2, 18)];
        _title.text = @"工资钱包";
        _title.font = [UIFont boldSystemFontOfSize:16];
        _title.textColor = KWhiteColor;
        [_bac addSubview:_title];
        
        self.balanceNumLabel = [[UILabel alloc] init];
        self.balanceNumLabel.textColor = KWhiteColor;
        self.balanceNumLabel.text = @"--";
        self.balanceNumLabel.font = tFont(23);
        [_bac addSubview:self.balanceNumLabel];
        [self.balanceNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_bac.mas_centerX);
            make.centerY.mas_equalTo(_bac.mas_centerY).offset(-10);
        }];
        
          
    }
    return self;
}

- (void)setCellData:(NSDictionary *)dic{
    _bac.image = [UIImage imageNamed:dic[@"bac"]];
    _title.text = dic[@"title"];
    self.balanceNumLabel.text = dic[@"num"];
    _title.textColor = dic[@"titleColor"];
    self.balanceNumLabel.textColor = dic[@"numColor"];
    
    _buttonArray = [NSMutableArray array];
    for (NSDictionary *dict in dic[@"buttonArray"]) {
        [_buttonArray addObject:dict];
    }
    
    for (int i = 0; i<_buttonArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = tFont(13);
        [button setTitle:_buttonArray[i][@"button"] forState:UIControlStateNormal];
        [button setTitleColor:_buttonArray[i][@"buttonTitleColor"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(walletButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = [_buttonArray[i][@"tag"] integerValue];
        [_bac addSubview:button];
        
        CGFloat buttonWidth = _bac.width / _buttonArray.count;
        button.frame = CGRectMake(i * buttonWidth , _bac.ly_maxY - 20 - 30, buttonWidth, 25);
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake((i-0) * buttonWidth, button.ly_y, 0.5, button.ly_height)];
        line.backgroundColor = KWhiteColor;
        [_bac addSubview:line];
    }
    
}

-(void)walletButtonClick:(UIButton *)button{
    if([self.delegate respondsToSelector:@selector(walletButtonClick:)]){
        [self.delegate walletButtonClick:button];
    }
}

@end
 
