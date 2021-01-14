//
//  UserInfoViewController.m
//  531Mall
//
//  Created by 王涛 on 2020/5/19.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "UserInfoViewController.h"
#import "WTTableStyleValue1Cell.h"
#import "UserInfoCell.h"
#import <LSTPopView.h>
#import "UpdateUserInfoPopView.h"
#import "UserInfoModel.h"

@interface UserInfoViewController ()
{
    
}
@property(nonatomic, strong)LSTPopView  *popView;
@property(nonatomic, strong)NSArray     *leftArray;
@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self createNavBar];
    [self createUI];
    [self initData];
}

- (void)createNavBar{
    self.gk_statusBarStyle = UIStatusBarStyleDefault;
    self.gk_navigationItem.title = @"个人信息";
    self.gk_navBackgroundColor = rgba(250, 250, 250, 1);
}

- (void)createUI{
    self.tableView.frame = CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight - Height_NavBar);
    [self.view addSubview:self.tableView];
    
    [self setOnlyReFresh];
}

- (void)initData{
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    md[@"userid"] = [WTMallUserInfo shareUserInfo].ID;
    md[@"sessionid"] = [WTMallUserInfo shareUserInfo].sessionid;
    [self.afnetWork jsonMallPostDict:@"/api/member/memberProfile" JsonDict:md Tag:@"1" LoadingInView:self.view];
}

#pragma mark - dataSource
- (void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    if([type isEqualToString:@"1"]){
        [self.tableView.mj_header endRefreshing];
        [self.dataArray removeAllObjects];
        for (NSDictionary *dic in dict[@"data"]) {
            [self.dataArray addObject:[UserInfoModel yy_modelWithDictionary:dic]];
        }
        //造一条会员编号
        UserInfoModel *model = [UserInfoModel new];
        model.lable = @"会员编号";
        model.value = [WTMallUserInfo shareUserInfo].username;
        [self.dataArray insertObject:model atIndex:0];
        
        [self.tableView reloadData];
    }else{
        printAlert(dict[@"msg"], 1.f);
        [self.tableView.mj_header beginRefreshing];
    }

}

#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    @weakify(self)
    __block UpdateUserInfoPopView *InfoView = [[UpdateUserInfoPopView alloc] initWithFrame:CGRectMake(47, (ScreenHeight - Height_TabBar - Height_NavBar - 211)/2, ScreenWidth - 47 * 2, 211 + 54) updateUserInfoType:indexPath.row updateTextBlock:^(NSString * _Nonnull text,NSString * _Nonnull text2,NSString * _Nonnull text3) {
        @strongify(self)
        switch (InfoView.updateUserInfoType) {
            case UpdateUserInfoTypeName:
            {
                printAlert(@"姓名不可修改", 1.f);
//                NSMutableDictionary *md = [NSMutableDictionary dictionary];
//                md[@"userid"] = [WTUserInfo shareUserInfo].ID;
//                md[@"sessionid"] = [WTUserInfo shareUserInfo].sessionid;
//                md[@"username"] = [WTUserInfo shareUserInfo].username;
//                md[@"truename"] = text;
//
//                [self.afnetWork jsonPostDict:@"/api/member/saveprofile" JsonDict:md Tag:@"2" LoadingInView:self.view];
            }
                break;
            case UpdateUserInfoTypeLoginPwd:
            { 
                NSMutableDictionary *md = [NSMutableDictionary dictionary];
                md[@"userid"] = [WTMallUserInfo shareUserInfo].ID;
                md[@"sessionid"] = [WTMallUserInfo shareUserInfo].sessionid;
                md[@"oldpass"] = text;
                md[@"pass1"] = text2;
                md[@"pass1c"] = text3;
                [self.afnetWork jsonMallPostDict:@"/api/member/savepassword" JsonDict:md Tag:@"3" LoadingInView:self.view];
                break;
            }
            case UpdateUserInfoTypePayPwd:
            {
                NSMutableDictionary *md = [NSMutableDictionary dictionary];
                md[@"userid"] = [WTMallUserInfo shareUserInfo].ID;
                md[@"sessionid"] = [WTMallUserInfo shareUserInfo].sessionid;
                md[@"oldpass"] = text;
                md[@"pass2"] = text2;
                md[@"pass2c"] = text3;
                [self.afnetWork jsonMallPostDict:@"/api/member/savepassword2" JsonDict:md Tag:@"4" LoadingInView:self.view];
                break;
            }
            default: //手机
            {
                if([ToolUtil checkPhoneNumInput:text]){
                    NSString *truenameStr = @"";
                    for (UserInfoModel *model in self.dataArray) {
                       if([model.variable isEqualToString:@"truename"]){
                           truenameStr = model.value;
                       }
                    }
                    NSMutableDictionary *md = [NSMutableDictionary dictionary];
                    md[@"userid"] = [WTMallUserInfo shareUserInfo].ID;
                    md[@"sessionid"] = [WTMallUserInfo shareUserInfo].sessionid;
                    md[@"username"] = [WTMallUserInfo shareUserInfo].username;
                    md[@"truename"] = [truenameStr stringByReplacingOccurrencesOfString:@" " withString:@""];
                    md[@"mobile_phone"] = text;
                    md[@"validate_code"] = text2;
                    [self.afnetWork jsonMallPostDict:@"/api/member/saveprofile" JsonDict:md Tag:@"2"];
                }else{
                    printAlert(@"请输入正确的手机号", 1.f);
                }
            }
                break;
        }
        
        [self.popView dismiss];
        self.popView = nil;
    }];
    self.popView = [LSTPopView initWithCustomView:InfoView parentView:self.view popStyle:LSTPopStyleSpringFromTop dismissStyle:LSTDismissStyleCardDropToTop];
    InfoView.closePopViewBlock = ^{
        @strongify(self)
        [self.popView dismiss];
        self.popView = nil;
    };
    [self.popView pop];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    [self.tableView registerClass:[UserInfoCell class] forCellReuseIdentifier:identifier];
    UserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    UserInfoModel *model = self.dataArray[indexPath.row];
    cell.leftLabel.text = model.lable;
    cell.rightLabel.text = model.value;
    if(indexPath.row == 0 ||
       indexPath.row == 1){
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.userInteractionEnabled = NO;
    }else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.userInteractionEnabled = YES;
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

@end
