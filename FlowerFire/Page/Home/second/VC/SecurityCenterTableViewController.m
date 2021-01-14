//
//  SecurityCenterTableViewController.m
//  FlowerFire
//
//  Created by 王涛 on 2020/5/4.
//  Copyright © 2020 Celery. All rights reserved.
//。安全中心

#import "SecurityCenterTableViewController.h"
#import "WTTableStyleValue1Cell.h"
#import "ChangeLoginPwdViewController.h"
#import "ChangeFundPasswordViewController.h"
#import "ChangeEmailViewController.h"
#import "ChangePhoneViewController.h"
#import "VerificationSettingViewController.h"
#import "BindGoogleVerificationViewController.h"
#import "SwitchGoogleVerificationViewController.h"
#import "SettingFundPwdViewController.h"
#import "ForgetFundPwdViewController.h"

@interface SecurityCenterTableViewController ()

@property(nonatomic, strong)NSArray<UIViewController *> *viewControllerArrays;
@end

@implementation SecurityCenterTableViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self initData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self createNavBar];
    [self createUI];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] postNotificationName:PopSkidVCNotification object:nil];
}

#pragma mark - initVCDelegate
- (void)createNavBar{
    self.gk_navigationItem.title = LocalizationKey(@"securityTip1");
}
 
- (void)createUI{
    [self.view addSubview:self.tableView];
    self.tableView.bounces = NO;
}

- (void)initData{
    if([HelpManager isBlankString:[WTUserInfo shareUserInfo].paypass]){
        self.dataArray = @[@[
        @{@"title":@"578Tip119",@"details":@""}, ],
                           
        @[
          @{@"title":@"securityTip10",@"details":[WTUserInfo shareUserInfo].email},]
        ].copy;
        
        self.viewControllerArrays = @[@[ 
                                    [SettingFundPwdViewController class],
                                     ],

                                  @[
                                    [ChangeEmailViewController class],],
                                 ];
    }else{
        
        NSString *state = [[WTUserInfo shareUserInfo].is_googleauth integerValue] == 0 ? @"未绑定":@"已绑定";
        
        
        self.dataArray = @[@[
        @{@"title":@"securityTip3",@"details":@""},
        @{@"title":@"securityTip4",@"details":@""}],
                           
        @[
          @{@"title":@"googleVerificationTip3",@"details":state},]
        ].copy;
        
        self.viewControllerArrays = @[@[
                                    [ChangeFundPasswordViewController class],
                                        [ForgetFundPwdViewController class],
                                     ],

                                  @[
                                          [[WTUserInfo shareUserInfo].is_googleauth integerValue] == 0 ? [BindGoogleVerificationViewController class] : [SwitchGoogleVerificationViewController class],],
                                 ];
    }
    [self.tableView reloadData];
//
//    // google绑定了进展示页面。//没绑定进绑定页面
//    Class GoogleVerificationViewController;
//    if([[WTUserInfo shareUserInfo].is_googleauth integerValue] == 0){
//        GoogleVerificationViewController = [BindGoogleVerificationViewController class];
//    }else{
//        GoogleVerificationViewController = [SwitchGoogleVerificationViewController class];
//    }
//
    
    
}

#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *arrays = (NSArray *)self.viewControllerArrays[indexPath.section];
    id viewControllerClass = arrays[indexPath.row];
     if ([viewControllerClass isSubclassOfClass:[UIViewController class]]) {
//         if(indexPath.section == 1){
//             if(indexPath.row == 1){
//                 VerificationSettingViewController *vc = (VerificationSettingViewController *)[viewControllerClass alloc];
//                 vc.verificationSettingType = VerificationSettingTypeTransaction;
//                 [self.navigationController pushViewController:vc animated:YES];
//                 return;
//             }else if (indexPath.row == 2){
//                 VerificationSettingViewController *vc = (VerificationSettingViewController *)[viewControllerClass alloc];
//                 vc.verificationSettingType = VerificationSettingTypePay;
//                 [self.navigationController pushViewController:vc animated:YES];
//                 return;
//             }else if (indexPath.row == 3){
//                 VerificationSettingViewController *vc = (VerificationSettingViewController *)[viewControllerClass alloc];
//                 vc.verificationSettingType = VerificationSettingTypeLogin;
//                 [self.navigationController pushViewController:vc animated:YES];
//                 return;
//             }
//         }
         [self.navigationController pushViewController:[viewControllerClass alloc] animated:YES];
     }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    [self.tableView registerClass:[WTTableStyleValue1Cell class] forCellReuseIdentifier:identifier];
    WTTableStyleValue1Cell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    NSArray *cellArray = self.dataArray[indexPath.section];
    cell.leftLabel.text = LocalizationKey(cellArray[indexPath.row][@"title"]);
    cell.rightLabel.text = cellArray[indexPath.row][@"details"];
    cell.rightLabel.textColor = MainColor;
    cell.isHiddenSplitLine = YES;
    if(indexPath.section != 2){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *cellArray = self.dataArray[section];
    return cellArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *bac = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    bac.theme_backgroundColor = THEME_LINE_TABLEVIEW_SEPARATOR_COLOR;
    return bac;
}

@end
