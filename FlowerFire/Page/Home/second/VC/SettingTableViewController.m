//
//  SettingTableViewController.m
//  FlowerFire
//
//  Created by 王涛 on 2020/5/4.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "SettingTableViewController.h"
#import "LanguageSettingsTBVC.h"

@interface SettingTableViewController ()

@end

@implementation SettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self createNavBar];
    [self createUI];
    [self initData];
     
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoginSuccessStatus) name:LOGIN_SUCCESS_NOTIFICATION object:nil];
}
 
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] postNotificationName:PopSkidVCNotification object:nil];
}

-(void)LoginSuccessStatus{
    [self closeVC];
}

#pragma mark - netData
-(void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    printAlert(LocalizationKey(@"SignOutSuccess"), 1.f);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [WTUserInfo logout];
        dispatch_async(dispatch_get_main_queue(), ^{
             [self closeVC];
            //发退出通知
            [[NSNotificationCenter defaultCenter] postNotificationName:EXIT_LOGIN_NOTIFICATION object:nil userInfo:nil];
        });
    });
    
   
  
}

#pragma mark - initViewDelegate
- (void)createNavBar{
    self.gk_navigationItem.title = LocalizationKey(@"settingTip4");
}

- (void)createUI{
    [self.view addSubview:self.tableView];
}

- (void)initData{
    NSString *loginText;
    if([WTUserInfo isLogIn]){
        loginText = LocalizationKey(@"settingTip3");
    }else{
        loginText = LocalizationKey(@"settingTip2");
    }
    self.dataArray = @[LocalizationKey(@"settingTip1"),loginText].copy;
    [self.tableView reloadData];
}

#pragma mark - talbeViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if(self.dataArray.count > 0){
        cell.textLabel.text = LocalizationKey(self.dataArray[indexPath.row]);
    }
   
    cell.textLabel.font = tFont(15);
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.theme_backgroundColor = THEME_TABBAR_BACKGROUNDCOLOR;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row == 0){
        LanguageSettingsTBVC *lbc = [LanguageSettingsTBVC new];
        [self.navigationController pushViewController:lbc animated:YES];
    }else{
        //是登录且未登录
        if([self.dataArray[indexPath.row] isEqualToString:LocalizationKey(@"settingTip2")] && ![WTUserInfo isLogIn]){
            [[WTPageRouterManager sharedInstance] jumpLoginViewController:self isModalMode:YES whatProject:0];
        }else{//已登录是退出
            [self.afnetWork jsonGetDict:@"/api/user/logout" JsonDict:nil Tag:@"1" LoadingInView:self.view]; 
        };
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

 

@end
