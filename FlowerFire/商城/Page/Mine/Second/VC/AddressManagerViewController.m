//
//  AddressViewController.m
//  531Mall
//
//  Created by 王涛 on 2020/5/20.
//  Copyright © 2020 Celery. All rights reserved.
//  地址管理

#import "AddressManagerViewController.h"
#import "UIImage+jianbianImage.h"
#import "AddressManagerCell.h"
#import "EditAddressViewController.h"


@interface AddressManagerViewController ()<AddressManagerCellDelegate>

@end

@implementation AddressManagerViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self initData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self createNavBar];
    [self createUI];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if(self.dataArray.count == 0){
        !self.noHasAddressBlock ? : self.noHasAddressBlock();
    }
}

- (void)createNavBar{
    self.gk_statusBarStyle = UIStatusBarStyleDefault;
    self.gk_navBackgroundColor = rgba(250, 250, 250, 1);
    self.gk_navigationItem.title = @"地址管理";
    
    if(self.ismodalPresentation){
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton addTarget:self action:@selector(backItemClick:) forControlEvents:UIControlEventTouchUpInside];
        backButton.frame = CGRectMake(OverAllLeft_OR_RightSpace, SafeIS_IPHONE_X, 10.5, 18.85);
        [self.view addSubview:backButton];
        [backButton setImage:[UIImage gk_imageNamed:@"btn_back_black"] forState:UIControlStateNormal];
        self.gk_navLeftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        [backButton addTarget:self action:@selector(closeVC) forControlEvents:UIControlEventTouchUpInside];
        self.gk_navItemLeftSpace = OverAllLeft_OR_RightSpace; 
    }
}

- (void)createUI{
    self.view.backgroundColor = self.gk_navBackgroundColor;
    [self.tableView ly_startLoading];
    self.tableView.backgroundColor = self.gk_navBackgroundColor;
    self.tableView.frame = CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight - Height_NavBar - 45 - SafeAreaBottomHeight);
    [self.view addSubview:self.tableView];
    self.tableView.ly_emptyView = [LYEmptyView emptyViewWithImage:[UIImage imageNamed:@"wudizhi"] titleStr:@"" detailStr:@"暂无收货地址"];
    [self setOnlyReFresh];
    
    UIButton *addAddressButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addAddressButton.titleLabel setFont:tFont(15)];
    [addAddressButton setTitle:@"添加新地址" forState:UIControlStateNormal];
    addAddressButton.frame = CGRectMake(0, ScreenHeight - SafeAreaBottomHeight - 45, ScreenWidth, 45);
    [addAddressButton setBackgroundImage:[UIImage gradientColorImageFromColors:MaingradientColor gradientType:GradientTypeLeftToRight imgSize:addAddressButton.size] forState:UIControlStateNormal];
    [self.view addSubview:addAddressButton];
    [addAddressButton addTarget:self action:@selector(addAddressClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initData{

    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    md[@"userid"] = [WTMallUserInfo shareUserInfo].ID;
    md[@"sessionid"] = [WTMallUserInfo shareUserInfo].sessionid;
    [self.afnetWork jsonMallPostDict:@"/api/order/addressList" JsonDict:md Tag:@"1" LoadingInView:self.view];
}

- (void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    [self.tableView ly_endLoading];
    [self.tableView.mj_header endRefreshing];
    if([type isEqualToString:@"1"]){
        self.dataArray = [NSMutableArray array];
        for (NSDictionary *dic in dict[@"data"][@"infos"]) {
            [self.dataArray addObject:[AddressInfoModel yy_modelWithDictionary:dic]];
        }
           
        [self.tableView reloadData];
    }else if([type isEqualToString:@"2"]){//删除收货地址
        printAlert(dict[@"msg"], 1.f);
        [self initData];
    }

    
}

#pragma mark -action
-(void)addAddressClick{
    EditAddressViewController *editvc = [EditAddressViewController new];
    editvc.addressManagerType = AddressManagerTypeAddNew;
    [self.navigationController pushViewController:editvc animated:YES];
}

#pragma mark - AddressManagerCellDelegate
-(void)defaultAddressClick:(UIButton *)btn indexPath:(NSIndexPath *)indexPath{
 
    AddressInfoModel *model = self.dataArray[indexPath.row];
    NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:3];
    md[@"userid"] = [WTMallUserInfo shareUserInfo].ID;
    md[@"sessionid"] = [WTMallUserInfo shareUserInfo].sessionid;
    md[@"id"] = model.AddressId;
     
    [MBManager showLoading];
    [[ReqestHelpManager share] requestMallPost:@"/api/order/setDefaultAddress" andHeaderParam:md finish:^(NSDictionary *dicForData, ReqestType flag) {
        [MBManager hideAlert];
        if([dicForData[@"status"] integerValue] == 1){
            for (AddressInfoModel *model in self.dataArray) {
                if([model.is_default isEqualToString:@"1"]){
                    model.is_default = @"0";
                }
            }
               
            model.is_default = @"1";
            [self.tableView reloadData];
        }else if([dicForData[@"status"] integerValue] == 9){
            [self jumpLogin];
            [WTMallUserInfo logout];
        }else{
            printAlert(dicForData[@"msg"], 1.f);
        }
    }];
    
}

-(void)editAddressClick:(UIButton *)btn indexPath:(NSIndexPath *)indexPath{
    EditAddressViewController *editvc = [EditAddressViewController new];
    editvc.addressManagerType = AddressManagerTypeEdit;
    AddressInfoModel *model = self.dataArray[indexPath.row];
    editvc.addressInfoModel = model;
    [self.navigationController pushViewController:editvc animated:YES];
}

- (void)deleteAddressClick:(UIButton *)btn indexPath:(NSIndexPath *)indexPath{
    UIAlertController *ua = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否删除此收货地址" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ua1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *ua2 = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        AddressInfoModel *model = self.dataArray[indexPath.row];
        NSMutableDictionary *md = [NSMutableDictionary dictionary];
        md[@"userid"] = [WTMallUserInfo shareUserInfo].ID;
        md[@"sessionid"] = [WTMallUserInfo shareUserInfo].sessionid;
        md[@"id"] = model.AddressId;
        [self.afnetWork jsonMallPostDict:@"/api/order/delAddress" JsonDict:md Tag:@"2" LoadingInView:self.view];
    }];
    [ua addAction:ua1];
    [ua addAction:ua2];
    [self presentViewController:ua animated:YES completion:nil];
}

#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.dataArray.count > 0){
        AddressInfoModel *model =  self.dataArray[indexPath.row];
        !self.didSelectedAddressBlock ? : self.didSelectedAddressBlock(model);
        if(self.ismodalPresentation){
            [self closeVC];
        }
    } 
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *idenitifier = @"cell";
    [self.tableView registerClass:[AddressManagerCell class] forCellReuseIdentifier:idenitifier];
    AddressManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:idenitifier forIndexPath:indexPath];
    cell.backgroundColor = self.gk_navBackgroundColor;
    cell.indexPath = indexPath;
    cell.delegate = self;
    
    if(self.dataArray.count > 0){
        AddressInfoModel *model =  self.dataArray[indexPath.row];
        if([model.is_default isEqualToString:@"1"]){
            cell.defultAddressButton.selected = YES;
        }else{
            cell.defultAddressButton.selected = NO;
        }
        [cell setCellData:model];
    }
    

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

@end
