//
//  MineMainViewController.m
//  531Mall
//
//  Created by 王涛 on 2020/5/19.
//  Copyright © 2020 Celery. All rights reserved.
//  我的主页

#import "MineMainViewController.h"
#import "MineMainHeaderView.h"
#import "TrueNameCertificationViewController.h"

@interface MineMainViewController ()<MineMainHeaderViewDelegate>
{
    MineMainHeaderView *_headerView;
}
@end

@implementation MineMainViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self initData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self createNavBar];
    [self createUI];
 
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CloseLoginVCNotice) name:CloseLoginVCNotice object:nil];
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserInfo) name:UpdateUserInfoNotice object:nil];
}

-(void)CloseLoginVCNotice{
    [[WTPageRouterManager sharedInstance] jumpMallTabBarController:0];
}

- (void)createNavBar{
    self.gk_navigationBar.hidden = YES;
    self.gk_statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)createUI{
    self.tableView.frame = CGRectMake(0, -Height_StatusBar, ScreenWidth, ScreenHeight - Height_TabBar + Height_StatusBar);
    self.tableView.bounces = NO;
    [self.view addSubview:self.tableView];
    _headerView = [[MineMainHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 280)];
    _headerView.delegate = self;
    _headerView.height = _headerView.whiteBac.ly_maxY + 20;
    self.tableView.tableHeaderView = _headerView;
     
}

- (void)initData{
    self.dataArray = @[@{@"image":@"w1",@"title":@"个人信息",@"viewControllerName":@"UserInfoViewController"},
    @{@"image":@"w2",@"title":@"我的团队",@"viewControllerName":@"MyTeamViewController"},
    @{@"image":@"w3",@"title":@"地址管理",@"viewControllerName":@"AddressManagerViewController"},
    @{@"image":@"w4",@"title":@"我的钱包",@"viewControllerName":@"MyWalletViewController"},
    @{@"image":@"w5",@"title":@"公告通知",@"viewControllerName":@"NewsViewController"},
    @{@"image":@"w6",@"title":@"设置",@"viewControllerName":@"SettingViewController"}].copy;

    [self getUserInfo];
}

/// 主要获取下用户名字和用户等级
-(void)getUserInfo{
    NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:2];
    md[@"userid"] = [WTMallUserInfo shareUserInfo].ID;
    md[@"sessionid"] = [WTMallUserInfo shareUserInfo].sessionid;
    [self.afnetWork jsonMallPostDict:@"/api/member/memberInfo" JsonDict:md Tag:@"2"];
    
}

- (void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    if([type isEqualToString:@"1"]){
        printAlert(dict[@"msg"], 1.f);
       
        WTMallUserInfo *userInfo = [WTMallUserInfo shareUserInfo];
        userInfo.is_sign = @"1";
        [WTMallUserInfo saveUser:userInfo];
        [_headerView updateUserInfoCache];
        
    }else{
        WTMallUserInfo *userInfo = [WTMallUserInfo shareUserInfo];
        userInfo.truename = dict[@"data"][@"truename"];
        userInfo.memberrank_info = dict[@"data"][@"memberrank_info"];
        userInfo.is_realname = dict[@"data"][@"is_realname"];
        userInfo.is_sign = dict[@"data"][@"is_sign"];
        [WTMallUserInfo saveUser:userInfo];
        [_headerView updateUserInfoCache];
    }
    
}

#pragma mark - MineMainHeaderViewDelegate
- (void)singUpClick:(UIButton *)button{
    NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:2];
    md[@"userid"] = [WTMallUserInfo shareUserInfo].ID;
    md[@"sessionid"] = [WTMallUserInfo shareUserInfo].sessionid;

    [MBManager showLoading];
    [[ReqestHelpManager share] requestMallPost:@"/api/member/memberInfo" andHeaderParam:md finish:^(NSDictionary *dicForData, ReqestType flag) {
        [MBManager hideAlert];
        @weakify(self)
        if([dicForData[@"status"] integerValue] == 1){
            @strongify(self)
            WTMallUserInfo *userInfo = [WTMallUserInfo shareUserInfo];
            userInfo.is_sign = dicForData[@"data"][@"is_sign"];
            [WTMallUserInfo saveUser:userInfo];
            [self->_headerView updateUserInfoCache];
            if([NSStringFormat(@"%@",[WTMallUserInfo shareUserInfo].is_sign) isEqualToString:@"0"]){
                NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:2];
                md[@"userid"] = [WTMallUserInfo shareUserInfo].ID;
                md[@"sessionid"] = [WTMallUserInfo shareUserInfo].sessionid;
                [self.afnetWork jsonMallPostDict:@"/api/sign/qiandao" JsonDict:md Tag:@"1" LoadingInView:self.view];
            }
        }else if([dicForData[@"status"] integerValue] == 9){
            [WTMallUserInfo logout];
            [self jumpLogin];
        }else{
            printAlert(dicForData[@"msg"], 1.f);
        }
    }];
    

}

- (void)certificationClick:(UIButton *)button{
    NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:3];
    md[@"userid"] = [WTMallUserInfo shareUserInfo].ID;
    md[@"sessionid"] = [WTMallUserInfo shareUserInfo].sessionid;
    md[@"sheet"] = @"is_realname";

    [MBManager showLoading];
    [[ReqestHelpManager share] requestMallPost:@"/api/member/getValue" andHeaderParam:md finish:^(NSDictionary *dicForData, ReqestType flag) {
        [MBManager hideAlert];
        @weakify(self)
        if([dicForData[@"status"] integerValue] == 1){
            @strongify(self)
            WTMallUserInfo *userInfo = [WTMallUserInfo shareUserInfo];
            userInfo.is_realname = dicForData[@"data"];
            [WTMallUserInfo saveUser:userInfo];
            [self->_headerView updateUserInfoCache];
            if([NSStringFormat(@"%@",[WTMallUserInfo shareUserInfo].is_realname) isEqualToString:@"1"]){
                printAlert(@"已实名", 1.f);
            }else if([NSStringFormat(@"%@",[WTMallUserInfo shareUserInfo].is_realname) isEqualToString:@"3"]){
                printAlert(@"已提交实名认证，等待审核", 1.f);
            }else{
                TrueNameCertificationViewController *tvc = [TrueNameCertificationViewController new];
                [self.navigationController pushViewController:tvc animated:YES];
            }
        }else if([dicForData[@"status"] integerValue] == 9){
            [WTMallUserInfo logout];
            [self jumpLogin];
        }else{
            printAlert(dicForData[@"msg"], 1.f);
        }
    }];
}

#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    Class class = NSClassFromString(self.dataArray[indexPath.row][@"viewControllerName"]);
    UIViewController *vc = [class new];
    [self.navigationController pushViewController:vc animated:true];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.textLabel.text = self.dataArray[indexPath.row][@"title"];
    cell.imageView.image = [UIImage imageNamed:self.dataArray[indexPath.row][@"image"]];
    cell.textLabel.font = tFont(14);
    cell.textLabel.textColor = rgba(51, 51, 51, 1);
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

@end
