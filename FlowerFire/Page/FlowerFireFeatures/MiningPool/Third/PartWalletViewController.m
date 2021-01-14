//
//  PartWalletViewController.m
//  FlowerFire
//
//  Created by 王涛 on 2020/7/14.
//  Copyright © 2020 Celery. All rights reserved.
//  分钱包

#import "PartWalletViewController.h"
#import "SettingUpdateFormCell.h"
#import "SettingUpdateSubmitButton.h"
#import "ScanCodeViewController.h" 
#import "LedgerViewController.h"

@interface PartWalletViewController ()
{
    NSString *_acount;
    NSString *_num;
    NSString *_fee;
    SettingUpdateSubmitButton *_bottomView;
    
    WTLabel  *_allNum;
}
@end

@implementation PartWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self createNavBar];
    [self createUI];
    [self initData];
}

#pragma mark - action
-(void)jumpQRCodeVC:(UIButton *)button{
    ScanCodeViewController *svc = [[ScanCodeViewController alloc] init];
    [self.navigationController pushViewController:svc animated:YES];
//    button.selected = !button.selected;
//    for (UIView* next = [button superview]; next; next = next.superview) {
//        if([next isMemberOfClass:[SettingUpdateFormCell class]]){
//           SettingUpdateFormCell * cell = (SettingUpdateFormCell *)next;
//           cell.loginInputView.secureTextEntry = cell.rightButton.isSelected;
//        }
//    }
   
}

-(void)selectedAllClick:(UIButton *)button{
    button.selected = !button.selected;
    for (UIView* next = [button superview]; next; next = next.superview) {
        if([next isMemberOfClass:[SettingUpdateFormCell class]]){
           SettingUpdateFormCell * cell = (SettingUpdateFormCell *)next;
           cell.loginInputView.text = @"0.05";
        }
    }
   
}

-(void)jumpLedgerViewControllerClick{
    LedgerViewController *jvc = [LedgerViewController new];
    [self.navigationController pushViewController:jvc animated:YES];
}

/// 提交修改
-(void)submitClick{
    [self closeVC];
}

- (void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    if([type isEqualToString:@"1"]){
        SettingUpdateFormCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0]];
        [[HelpManager sharedHelpManager] sendVerificationCode:cell.rightButton];
    }else{
        printAlert(dict[@"msg"], 1.f);
        [self closeVC];
    }
}

#pragma mark - initViewDelegate
- (void)createNavBar{
    self.gk_navigationItem.title = LocalizationKey(@"MiningPollTip9");
    
    WTButton *button = [[WTButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40) titleStr:@"记录" titleFont:tFont(15) titleColor:[UIColor grayColor] parentView:nil];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [button addTarget:self action:@selector(jumpLedgerViewControllerClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.gk_navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)createUI{
    self.tableView.bounces = NO;
    self.tableView.frame = CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight - Height_NavBar);
    
    _bottomView = [[SettingUpdateSubmitButton alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 150)];
    [_bottomView.submitButton setTitle:LocalizationKey(@"MiningPollTip8") forState:UIControlStateNormal];
    [_bottomView.submitButton addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = _bottomView;
    [self.view addSubview:self.tableView];
     
}

- (void)theme_didChanged{
     self.gk_navLineHidden = NO;
}

//"MiningPollTip1" = "接受账户";
//"MiningPollTip2" = "请输入分钱帐户";
//"MiningPollTip3" = "数量";
//"MiningPollTip4" = "请输入数量";
//"MiningPollTip5" = "全部";
//"MiningPollTip6" = "可用";
//"MiningPollTip7" = "矿工费";
- (void)initData{
    self.dataArray = @[@{@"title":@"MiningPollTip1",@"details":@"MiningPollTip2",@"customNormalImage":@"img34"},
    @{@"title":@"MiningPollTip3",@"details":@"MiningPollTip4",@"rightBtnTitle":@"MiningPollTip5"},
    @{@"title":@"MiningPollTip7",@"details":@"0.01",@"rightBtnTitle":self.coinName} ,
    ].copy;
}

#pragma mark - tableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    [self.tableView registerClass:[SettingUpdateFormCell class] forCellReuseIdentifier:identifier];
    SettingUpdateFormCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if(self.dataArray.count>0){
        [cell setCellData:self.dataArray[indexPath.section]];
    }
    cell.loginInputView.tag = indexPath.section;
    [cell.loginInputView addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
    if(indexPath.section==0){
        [cell.rightButton addTarget:self action:@selector(jumpQRCodeVC:) forControlEvents:UIControlEventTouchUpInside];
        cell.loginInputView.keyboardType = UIKeyboardTypeDefault;
    }else if(indexPath.section==1){
        [cell.rightButton addTarget:self action:@selector(selectedAllClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.loginInputView.keyboardType = UIKeyboardTypeNumberPad ;
    }else{
        cell.loginInputView.keyboardType = UIKeyboardTypeNumberPad ;
    }
     
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 91;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(section == 1){
        WTBacView *bac = [[WTBacView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30) backGroundColor:KWhiteColor parentView:nil];
        _allNum = [[WTLabel alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, 10, ScreenWidth - OverAllLeft_OR_RightSpace, 20) Text:[@"可用0.005" stringByAppendingString:self.coinName] Font:tFont(15) textColor:grayTextColor parentView:bac];
        return bac;
    }else{
        return nil;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == 1){
        return 30;
    }
    return 0;
}

- (void)textFieldWithText:(UITextField *)textField
{
    switch (textField.tag) {
        case 0:
            _acount = textField.text;
            break;
        case 1:
            _num = textField.text;
            break;
        default:
            _fee = textField.text;
            break;
    }
    if(_acount.length && _num.length && _fee.length){
        _bottomView.submitButton.enabled = YES;
    }else{
        _bottomView.submitButton.enabled = NO;
    }
}


@end
