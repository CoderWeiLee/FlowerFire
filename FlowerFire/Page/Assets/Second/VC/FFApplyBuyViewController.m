//
//  FFApplyBuyViewController.m
//  FlowerFire
//
//  Created by 王涛 on 2020/8/25.
//  Copyright © 2020 Celery. All rights reserved.
//  认购

#import "FFApplyBuyViewController.h"
#import "SettingUpdateSubmitButton.h"
#import "SettingUpdateFormCell.h"
#import "SettingFundPwdViewController.h"
 
@interface FFApplyBuyViewController ()
{
    SettingUpdateSubmitButton *_bottomView;
    UITextField               *_SDNumField,*_usdtNumField,*_payPwdField;
    WTLabel                   *_maxBuyNumLabel,*_usdtBalanceLabel;
    NSString                  *_usdtBalance;
}

@property(nonatomic, strong)FFApplyBuyModel *ffApplyBuyModel;
@end

@implementation FFApplyBuyViewController

- (instancetype)initWithFFApplyBuyModel:(FFApplyBuyModel *)FFApplyBuyModel
{
    self = [super init];
    if (self) {
        self.ffApplyBuyModel = FFApplyBuyModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavBar];
    [self createUI];
    [self initData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if([HelpManager isBlankString:[WTUserInfo shareUserInfo].paypass]){
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:LocalizationKey(@"578Tip121") message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:LocalizationKey(@"Go to set") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            SettingFundPwdViewController *svc = [SettingFundPwdViewController new];
            [self.navigationController pushViewController:svc animated:YES];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:LocalizationKey(@"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self closeVC];
        }];
        [actionSheet addAction:action2];
        [actionSheet addAction:action1];
        [self presentViewController:actionSheet animated:YES completion:nil];
    } 
}

#pragma mark - action
/// 提交修改
-(void)submitClick{
    NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:2];
    md[@"amount"] = _SDNumField.text;
    md[@"password"] = _payPwdField.text;
    [self.afnetWork jsonPostDict:@"/api/user/bookingCoin" JsonDict:md Tag:@"2"];
}

-(void)allClick{
    double maxNum = _usdtBalance.doubleValue * self.ffApplyBuyModel.percentage.doubleValue;
    _SDNumField.text = [ToolUtil stringFromNumber:maxNum withlimit:8];
    
    [self SDNumMonitor:_SDNumField];
}

-(void)SDNumMonitor:(UITextField *)textField{
    _usdtNumField.text = [ToolUtil stringFromNumber:textField.text.doubleValue / self.ffApplyBuyModel.percentage.doubleValue withlimit:8];
}

- (void)createNavBar{
    self.gk_navigationItem.title = LocalizationKey(@"578Tip81");
}

- (void)createUI{
    self.tableView.frame = CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight - Height_NavBar);
    self.tableView.bounces = NO;
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 250)];
    
    WTLabel *tip = [[WTLabel alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, 30, ScreenWidth - 2 *OverAllLeft_OR_RightSpace, 100) Text:NSStringFormat(@"%@%@~%@;\n     %@",LocalizationKey(@"578Tip145"),@"",@"",LocalizationKey(@"578Tip146")) Font:tFont(13) textColor:KBlackColor parentView:bottomView];
    tip.numberOfLines = 0;
    
    if(self.ffApplyBuyModel){
        tip.text = NSStringFormat(@"%@%@~%@;\n     %@",LocalizationKey(@"578Tip145"),self.ffApplyBuyModel.start_time,self.ffApplyBuyModel.end_time,LocalizationKey(@"578Tip146"));
    }
    
    _bottomView = [[SettingUpdateSubmitButton alloc] initWithFrame:CGRectMake(0, tip.bottom, ScreenWidth, 150)];
    [_bottomView.submitButton setTitle:LocalizationKey(@"578Tip147") forState:UIControlStateNormal];
    [_bottomView.submitButton addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:_bottomView];
    self.tableView.tableFooterView = bottomView;
    [self.view addSubview:self.tableView];
    
}

- (void)initData{
    self.dataArray = @[@{@"title":@"578Tip82",@"details":@"578Tip90",@"keyBoardType":@"2",@"rightBtnTitle":@"578Tip83"},
                       @{@"title":@"578Tip85",@"details":@"578Tip91",@"keyBoardType":@"2"},
                       @{@"title":@"578Tip87",@"details":@"578Tip92",@"keyBoardType":@"2",@"isSafeInput":@"1"} ,
    ].copy;
     
    //查下USDT钱包
    [self.afnetWork jsonGetDict:@"/api/account/getAccountByTypeCoin" JsonDict:@{@"account_type":Coin_Account,@"coin_id":@"3"} Tag:@"1"];
}

- (void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    if([type isEqualToString:@"1"]){
        _usdtBalance = dict[@"data"][@"money"];
        _usdtBalanceLabel.text = [NSString stringWithFormat:@"%@%@",_usdtBalance,@"USDT"];
    }else{
        printAlert(dict[@"msg"], 1.f);
        [self closeVC];
    }
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
    
    switch (indexPath.section) {
        case 0:
        {
            cell.loginInputView.userInteractionEnabled = YES;
            _SDNumField = cell.loginInputView;
            cell.loginInputView.keyboardType = UIKeyboardTypeDecimalPad;
            [cell.loginInputView addTarget:self action:@selector(SDNumMonitor:) forControlEvents:UIControlEventEditingChanged];
            [cell.rightButton addTarget:self action:@selector(allClick) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        case 1:
        {
            cell.loginInputView.userInteractionEnabled = NO;
            _usdtNumField = cell.loginInputView;
        }
            break;
        default:
        {
            cell.loginInputView.userInteractionEnabled = YES;
            _payPwdField = cell.loginInputView;
            cell.loginInputView.keyboardType = UIKeyboardTypeDefault;
        }
            break;
    }
    [cell.loginInputView addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
    cell.loginInputView.clearButtonMode = UITextFieldViewModeWhileEditing;
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == 2){
        return 0;
    }
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    switch (section) {
        case 0:
        {
            UIView *bac = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
            
            CGFloat width = [HelpManager getLabelWidth:13 labelTxt:LocalizationKey(@"578Tip84")].width;
            WTLabel *la = [[WTLabel alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, 0, width, 30) Text:LocalizationKey(@"578Tip84") Font:tFont(13) textColor:grayTextColor parentView:bac];
            
            _maxBuyNumLabel = [[WTLabel alloc] initWithFrame:CGRectMake(la.right+2, 0, ScreenWidth - la.right, 30) Text:@"SD" Font:tFont(13) textColor:qutesRedColor parentView:bac];
            
            if(self.ffApplyBuyModel){
                _maxBuyNumLabel.text = NSStringFormat(@"%@SD",self.ffApplyBuyModel.max_exchange_amount);
            }
            
            return bac;
        }
        case 1:
        {
            UIView *bac = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
            CGFloat width = [HelpManager getLabelWidth:13 labelTxt:LocalizationKey(@"578Tip86")].width;
            WTLabel *la = [[WTLabel alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, 0, width, 30) Text:LocalizationKey(@"578Tip86") Font:tFont(13) textColor:grayTextColor parentView:bac];
            
            _usdtBalanceLabel = [[WTLabel alloc] initWithFrame:CGRectMake(la.right+2, 0, ScreenWidth - la.right, 30) Text:@"--USDT" Font:tFont(13) textColor:qutesRedColor parentView:bac];
            
            return bac;
        }
            break;
        default:
            return nil;
    }
}
   
- (void)textFieldWithText:(UITextField *)textField
{
    if(_SDNumField.text.length && _usdtNumField.text.length && _payPwdField.text.length){
        _bottomView.submitButton.enabled = YES;
    }else{
        _bottomView.submitButton.enabled = NO;
    }
}
 


@end
