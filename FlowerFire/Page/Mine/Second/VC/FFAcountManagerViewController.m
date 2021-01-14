//
//  FFAcountManagerViewController.m
//  FlowerFire
//
//  Created by 王涛 on 2020/8/24.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "FFAcountManagerViewController.h"
#import "FFAcountManagerCell.h"
#import "FFImportAccountViewController.h"
#import "FFAddAcountViewController.h"
#import "FFAcountDetailsViewController.h"
#import "FFAcountManager.h"
#import "AESCipher.h"

@interface FFAcountManagerViewController ()

@property(nonatomic, strong)NSMutableArray *selectedArray;
@end

@implementation FFAcountManagerViewController

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
-(void)exitClick{
    [self.afnetWork jsonGetDict:@"/api/user/logout" JsonDict:nil Tag:@"1" LoadingInView:self.view]; 
}

/// 创建账户，走注册流程
-(void)createAccountClick{
    FFAddAcountViewController *fvc = [FFAddAcountViewController new];
    [self.navigationController pushViewController:fvc animated:YES];
}

//导入账户，会自动登录
-(void)importClick{
    FFImportAccountViewController *fvc = [FFImportAccountViewController new];
    [self.navigationController pushViewController:fvc animated:YES];
}

-(void)singleSelectedClick:(UIButton *)button{
    CGPoint point = button.center;
    point = [self.tableView convertPoint:point fromView:button.superview];
    NSIndexPath *indexpath = [self.tableView indexPathForRowAtPoint:point];
    
    UIAlertController *ua = [UIAlertController alertControllerWithTitle:LocalizationKey(@"utilTip2") message:LocalizationKey(@"578Tip149") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ua1 = [UIAlertAction actionWithTitle:LocalizationKey(@"changeEmailTip4") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.selectedArray = [NSMutableArray array];
            [self.selectedArray addObject:indexpath];
             
            [self switchUserAccountHandler:indexpath];
            
            [self.tableView reloadData];
        }];
       
    [ua addAction:ua1];
    UIAlertAction *ua3 = [UIAlertAction actionWithTitle:LocalizationKey(@"cancel") style:UIAlertActionStyleCancel handler:nil];
    [ua addAction:ua3];
    [self presentViewController:ua animated:YES completion:nil];
     
}

-(void)arrowButtonClick:(UIButton *)button{
    if(button.isSelected){ //垃圾桶图片的才让删除
        CGPoint point = button.center;
        point = [self.tableView convertPoint:point fromView:button.superview];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
        
        UIAlertController *ua = [UIAlertController alertControllerWithTitle:LocalizationKey(@"utilTip2") message:LocalizationKey(@"578Tip155") preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ua1 = [UIAlertAction actionWithTitle:LocalizationKey(@"determine") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                if(self.dataArray.count>0){
                    UserAccount *userAccount = self.dataArray[indexPath.row];
                    [[FFAcountManager sharedInstance] deleteUserAccount:userAccount.username];
                    [self initData];
                }
            }];
           
        [ua addAction:ua1];
        UIAlertAction *ua3 = [UIAlertAction actionWithTitle:LocalizationKey(@"cancel") style:UIAlertActionStyleCancel handler:nil];
        [ua addAction:ua3];
        [self presentViewController:ua animated:YES completion:nil];
    }
}

/// 切换账号
/// @param indexPath index
-(void)switchUserAccountHandler:(NSIndexPath *)indexPath{
    UserAccount *userAccount = self.dataArray[indexPath.row];
    switch (userAccount.type) {
        case 0:
        {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:2];
            dic[@"account"] =  userAccount.username;
            dic[@"password"] = userAccount.pwd;
            [self.afnetWork jsonGetDict:@"/api/user/login" JsonDict:dic Tag:@"2" LoadingInView:self.view];
        }
            break;
        case 1:
        {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:2];
            dic[@"username"] = userAccount.username;
            dic[@"mnemonic"] = userAccount.pwd; //本身加密存储了，就不用再加密了
            [self.afnetWork jsonPostDict:@"/api/user/importMnemonic" JsonDict:dic Tag:@"2"];
        }
            break;
        default:
        {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:2];
            dic[@"username"] = userAccount.username;
            dic[@"private_key"] = userAccount.pwd;
            [self.afnetWork jsonPostDict:@"/api/user/importPrivateKey" JsonDict:dic Tag:@"2"];
        }
            break;
    }
}
 
- (void)createNavBar{
    self.gk_navigationItem.title = LocalizationKey(@"578Tip28");
//    WTButton *exitButton = [[WTButton alloc] initWithFrame:CGRectMake(0, 0, 100, 30) titleStr:LocalizationKey(@"578Tip29") titleFont:tFont(14) titleColor:MainColor parentView:nil];
//    [exitButton addTarget:self action:@selector(exitClick) forControlEvents:UIControlEventTouchUpInside];
//    exitButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//
//    self.gk_navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:exitButton];
//
}

- (void)createUI{
    self.tableView.frame = CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight - Height_NavBar - SafeAreaBottomHeight - 50);
    [self.view addSubview:self.tableView];
    
    WTButton *createAccountButotn = [[WTButton alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, ScreenHeight  - SafeAreaBottomHeight - 15 - 35, (ScreenWidth - 2 *OverAllLeft_OR_RightSpace)/2 - 4, 35) titleStr:LocalizationKey(@"578Tip31") titleFont:tFont(14) titleColor:KWhiteColor parentView:self.view];
    createAccountButotn.backgroundColor = MainColor;
    createAccountButotn.layer.cornerRadius = 17.5;
    
    
    WTButton *importButotn = [[WTButton alloc] initWithFrame:CGRectMake(createAccountButotn.right+8, ScreenHeight - SafeAreaBottomHeight - 15 - 35, (ScreenWidth - 2 *OverAllLeft_OR_RightSpace)/2 - 4, 35) titleStr:LocalizationKey(@"578Tip32") titleFont:tFont(14) titleColor:KWhiteColor parentView:self.view];
    importButotn.backgroundColor = MainColor;
    importButotn.layer.cornerRadius = 17.5;
    
    [createAccountButotn addTarget:self action:@selector(createAccountClick) forControlEvents:UIControlEventTouchUpInside];
    [importButotn addTarget:self action:@selector(importClick) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)initData{
    self.selectedArray = [NSMutableArray array];
    self.dataArray = [FFAcountManager sharedInstance].userAccountArray.copy;
    [self.tableView reloadData];
}

- (void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    switch ([type integerValue]) {
        case 1:
        {
            printAlert(LocalizationKey(@"SignOutSuccess"), 1.f);
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [WTUserInfo logout];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[WTPageRouterManager sharedInstance] jumpTabBarController:0];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    //发退出通知
                    [[NSNotificationCenter defaultCenter] postNotificationName:EXIT_LOGIN_NOTIFICATION object:nil userInfo:nil];
                });
            });
        }
            break;
        case 2:
        {
            if(dict.count >0){
                printAlert(LocalizationKey(@"LoginSuccess"), 1.f);
                NSDictionary *userInforDic = dict[@"data"][@"userinfo"];
                [WTUserInfo getuserInfoWithDic:userInforDic];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:SWITCH_ACCOUNT_SUCCESS_NOTIFICATION object:nil userInfo:nil];
                
            }
        }
        default:
            break;
    }
}

#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.dataArray.count>0){
        //不是当前登录的号不让点进去
        if([self.selectedArray containsObject:indexPath]){
            UserAccount *userAccount = self.dataArray[indexPath.row];
            FFAcountDetailsViewController *fvc = [FFAcountDetailsViewController new];
            fvc.userName = userAccount.username;
            [self.navigationController pushViewController:fvc animated:YES];
        } 
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    [self.tableView registerClass:[FFAcountManagerCell class] forCellReuseIdentifier:identifier];
    FFAcountManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    if(self.dataArray.count>0){
        if(self.selectedArray.count>0){
            if([self.selectedArray containsObject:indexPath]){
                cell.singleButton.selected = YES;
                cell.tip.hidden = NO;
                cell.arrowButton.selected = NO;
            }else{
                cell.singleButton.selected = NO;
                cell.tip.hidden = YES;
                cell.arrowButton.selected = YES;
            }
        }else{//没有选择的，那么自己当前账号弄成选中
            UserAccount *userAccount = self.dataArray[indexPath.row];
            if([userAccount.username isEqualToString:[WTUserInfo shareUserInfo].username]){
                cell.arrowButton.selected = NO;
                self.selectedArray = [NSMutableArray array];
                [self.selectedArray addObject:indexPath];
                [self.tableView reloadData];
            }
        }
        
        [cell setCellData:self.dataArray[indexPath.row]];
    }
    
    [cell.singleButton addTarget:self action:@selector(singleSelectedClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.arrowButton addTarget:self action:@selector(arrowButtonClick:) forControlEvents:UIControlEventTouchUpInside];
  
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}
 
@end
