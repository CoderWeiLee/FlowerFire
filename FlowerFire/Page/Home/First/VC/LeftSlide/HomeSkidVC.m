//
//  HomeSkidVC.m
//  FlowerFire
//
//  Created by 王涛 on 2020/5/4.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "HomeSkidVC.h"
#import "UIViewController+LeftSlide.h"
#import "HomeSkidHeaderView.h"
#import "SettingTableViewController.h"
#import "SecurityCenterTableViewController.h"
#import "KycCertificationMainVC.h"
#import "WTWebViewController.h"
#import "AboutUsViewController.h"
#import "ShowPaymentMethodTBVC.h"
#import "HelpCenterViewController.h"
#import "ChooseCoinTBVC.h"
#import "TransferVC.h"
#import "RedEnvelopeViewController.h"

@interface HomeSkidVC ()
{
    HomeSkidHeaderView *_headerView;
}
@property(nonatomic,strong)NSArray<UIViewController *> *viewControllers;

@end

@implementation HomeSkidVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self initData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavBar];
    [self createUI];
    
    
  //  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showFromLeft) name:PopSkidVCNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitLoginStatus) name:LOGIN_SUCCESS_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitLoginStatus) name:EXIT_LOGIN_NOTIFICATION object:nil];
}

-(void)exitLoginStatus{
    [_headerView exitLogin];
}

#pragma mark - initVCDelegate
- (void)initData{
    NSString *certificationStatus;
    NSString *isNeedCertification;
    if([[WTUserInfo shareUserInfo].kyc integerValue] > 0){
        certificationStatus = @"";
        isNeedCertification = @"0";
    }else{
        certificationStatus = LocalizationKey(@"not certified");
        isNeedCertification = @"1";
    }
    
    self.dataArray = @[@{@"title":@"homeSkidTip3",@"imageName":@"img48",@"isNeedLogin":@"1"},
                        @{@"title":@"homeSkidTip4",@"imageName":@"img52",@"isNeedLogin":@"1"},
                       @{@"title":@"homeSkidTip5",@"imageName":@"img53",@"isNeedLogin":@"1",@"isNeedCertification":isNeedCertification},
                        @{@"title":@"homeSkidTip6",@"imageName":@"img54",@"isNeedLogin":@"0"},
                        @{@"title":@"homeSkidTip7",@"imageName":@"img55",@"isNeedLogin":@"0"},
                       @{@"title":@"homeSkidTip8",@"imageName":@"img51",@"isNeedLogin":@"1",@"certificationStatus":certificationStatus},
                        @{@"title":@"homeSkidTip9",@"imageName":@"img56",@"isNeedLogin":@"0"},
                        @{@"title":@"homeSkidTip10",@"imageName":@"img57",@"isNeedLogin":@"0"}].copy;
     
        //控制器数组
        self.viewControllers = @[
             [SecurityCenterTableViewController class], //账号管理
             [SecurityCenterTableViewController class],
             [ShowPaymentMethodTBVC class], //支付管理
             [WTWebViewController class],
             [AboutUsViewController class],
             [KycCertificationMainVC class],
             [HelpCenterViewController class], //帮助中心
             [SettingTableViewController class],
        ];

    
//    self.dataArray = @[@[@{@"title":@"Deposit",@"imageName":@"wode03",@"isNeedLogin":@"1",@"vcName":@"ChooseCoinTBVC"},
//        @{@"title":@"Withdraw",@"imageName":@"wode04",@"isNeedLogin":@"1",@"vcName":@"ChooseCoinTBVC"},
//        @{@"title":@"Transfer",@"imageName":@"wode05",@"isNeedLogin":@"1",@"vcName":@"TransferVC"}],
//
//        @[@{@"title":@"homeTip13",@"imageName":@"wode06",@"isNeedLogin":@"0",@"vcName":@"KycCertificationMainVC"},
//        @{@"title":@"homeTip14",@"imageName":@"wode07",@"isNeedLogin":@"0",@"vcName":@"SecurityCenterTableViewController"},
//        @{@"title":@"homeButtonTip7",@"imageName":@"wode08",@"isNeedLogin":@"1",@"vcName":@"ShowPaymentMethodTBVC"}, ],
//
//        @[@{@"title":@"homeTip15",@"imageName":@"wode10",@"isNeedLogin":@"0",@"vcName":@"SettingTableViewController"}]].copy;
      
}

- (void)createNavBar{
    self.gk_navigationBar.hidden = YES;
}

- (void)createUI{
    self.view.backgroundColor = rgba(0, 0, 0, 0.5);

    CGFloat skidWidth = ScreenWidth /5 * 4;
    self.tableView.bounces = NO;
    self.tableView.frame = CGRectMake(0, 0, skidWidth, ScreenHeight);
    CGFloat headerViewHeight = 100;
    if(SafeIS_IPHONE_X){
        headerViewHeight += 30;
    }
    _headerView = [[HomeSkidHeaderView alloc] initWithFrame:CGRectMake(0, 0, skidWidth, headerViewHeight)];
    self.tableView.tableHeaderView = _headerView;
    self.tableView.backgroundColor = SkidBackgrouondColor;
    [self.view addSubview:self.tableView];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.backgroundColor = rgba(0, 0, 0, 0.5);
    closeBtn.frame = CGRectMake(self.tableView.ly_maxX, 0, ScreenWidth - self.tableView.width, ScreenHeight);
    [self.view addSubview:closeBtn];
    [closeBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    WTButton *callKF = [[WTButton alloc] initWithFrame:CGRectMake(30, 30, 70, 30) titleStr:LocalizationKey(@"homeTip16") titleFont:tFont(15) titleColor:KWhiteColor parentView:bottomView];
    
    WTButton *shareButton = [[WTButton alloc] initWithFrame:CGRectMake(skidWidth/2 + 30, 30, 70, 30) titleStr:LocalizationKey(@"homeTip17") titleFont:tFont(15) titleColor:KWhiteColor parentView:bottomView];
    
    @weakify(self)
    [callKF addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        @strongify(self)
        NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@""];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:nil];
    }];
    
    [shareButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        @strongify(self)
        RedEnvelopeViewController *rvc = [RedEnvelopeViewController new];
        [self.rootVC.navigationController pushViewController:rvc animated:YES];
        [self hide];
    }];
    
    
    self.tableView.tableFooterView = bottomView;
}

#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //if([self.dataArray[indexPath.section][indexPath.row][@"isNeedLogin"] isEqualToString:@"1"]){ //需要登录
    if([self.dataArray[indexPath.row][@"isNeedLogin"] isEqualToString:@"1"]){ //需要登录
        if(![WTUserInfo isLogIn]){
            [[WTPageRouterManager sharedInstance] jumpLoginViewController:self isModalMode:YES whatProject:0];
            return;
        }
    }
    if([self.dataArray[indexPath.row][@"isNeedCertification"] isEqualToString:@"1"]){ //需要认证
        printAlert(LocalizationKey(@"homeSkidTip13"), 1.f);
        return;
    }
    
//    if(indexPath.section == 0){
//        if(indexPath.row == 0){
//            [self hide];
//            ChooseCoinTBVC *tvc = [[ChooseCoinTBVC alloc] initWithChooseCoinType:ChooseCoinTypeDeposit];
//            [self.rootVC.navigationController pushViewController:tvc animated:YES];
//            return;
//        }else if(indexPath.row == 1){
//            [self hide];
//            ChooseCoinTBVC *tvc = [[ChooseCoinTBVC alloc] initWithChooseCoinType:ChooseCoinTypeWithdraw];
//            [self.rootVC.navigationController pushViewController:tvc animated:YES];
//            return;
//        }
//    }
//
    id viewControllerClass = self.viewControllers[indexPath.row];
    

    //NSString *vcName = self.dataArray[indexPath.section][indexPath.row][@"vcName"];
   // Class viewControllerClass = NSClassFromString(vcName);
    if ([viewControllerClass isSubclassOfClass:[UIViewController class]]) {
        if([viewControllerClass isSubclassOfClass:[WTWebViewController class]]){
            [self hide];
            WTWebViewController *webVC = [[WTWebViewController alloc] initWithURLString:@"http://trade.eos-club.com/web/#/cms/article/1"];
            webVC.progressTintColor = MainColor;
            [self.rootVC.navigationController pushViewController:webVC animated:YES];
            
            return;
        }
        [self.rootVC.navigationController pushViewController:[viewControllerClass alloc] animated:YES];
        [self hide];
    } 
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    if(self.dataArray.count > 0){
        cell.textLabel.text = LocalizationKey(self.dataArray[indexPath.row][@"title"]);
        cell.imageView.image = [UIImage imageNamed:self.dataArray[indexPath.row][@"imageName"]];
        cell.detailTextLabel.text = self.dataArray[indexPath.row][@"certificationStatus"];

//        cell.textLabel.text = LocalizationKey(self.dataArray[indexPath.section][indexPath.row][@"title"]);
//        cell.imageView.image = [UIImage imageNamed:self.dataArray[indexPath.section][indexPath.row][@"imageName"]];
//        cell.detailTextLabel.text = self.dataArray[indexPath.section][indexPath.row][@"certificationStatus"];
    }
    cell.textLabel.textColor = KWhiteColor;
    cell.textLabel.font = tFont(15);
    cell.detailTextLabel.textColor = [UIColor grayColor];
    cell.detailTextLabel.font = tFont(14);
    cell.accessoryView = [self accessoryDisclosureIndicator];
    cell.backgroundColor = tableView.backgroundColor;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 20;
//}
//
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *bac = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
//    bac.backgroundColor = rgba(0, 16, 36, 1);
//    return bac;
//}
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return self.dataArray.count;
//}
//
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    NSArray *array = self.dataArray[section];
//    return array.count;
//}

-(UIImageView *)accessoryDisclosureIndicator{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"history_order_right_arrow"]];
    return imageView;
}

#pragma mark - UIViewController+LeftSlide
- (void)showFromLeft
{
    [self show];
}

 -(void)hide{
     [super hide]; 
 }

@end
