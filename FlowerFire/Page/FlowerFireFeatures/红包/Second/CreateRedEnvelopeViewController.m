//
//  CreateRedEnvelopeViewController.m
//  FlowerFire
//
//  Created by 王涛 on 2020/7/14.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "CreateRedEnvelopeViewController.h"
#import "SettingUpdateFormCell.h"
#import "SettingUpdateSubmitButton.h"
#import "RedEnvelopeRecordViewController.h"

@interface CreateRedEnvelopeViewController ()
{
    NSString *_money;
    NSString *_num;
    SettingUpdateSubmitButton *_bottomView;
    
    WTLabel  *_allNum;
}
@end

@implementation CreateRedEnvelopeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self createNavBar];
    [self createUI];
    [self initData];
}

#pragma mark - action 
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
    self.gk_navigationItem.title = LocalizationKey(@"RedEnvelopeTip7");
    
    WTButton *recordButton = [[WTButton alloc] initWithFrame:CGRectMake(0, 0, 50, 40) titleStr:LocalizationKey(@"RedEnvelopeTip9") titleFont:tFont(15) titleColor:[UIColor redColor] parentView:nil];
    
    @weakify(self)
    [recordButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        @strongify(self)
        RedEnvelopeRecordViewController *rvc = [RedEnvelopeRecordViewController new];
        [self.navigationController pushViewController:rvc animated:YES];
    }];
    
    recordButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.gk_navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:recordButton];
}

- (void)createUI{
    self.tableView.frame = CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight - Height_NavBar);
    
    _bottomView = [[SettingUpdateSubmitButton alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 150)];
    [_bottomView.submitButton setTitle:LocalizationKey(@"RedEnvelopeTip8") forState:UIControlStateNormal];
    [_bottomView.submitButton addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = _bottomView;
    [self.view addSubview:self.tableView];
     
}

- (void)theme_didChanged{
     self.gk_navLineHidden = NO;
}
 
- (void)initData{
    self.dataArray = @[@{@"title":@"RedEnvelopeTip1",@"details":@"RedEnvelopeTip2",@"rightBtnTitle":@"HDU"},
    @{@"title":@"RedEnvelopeTip3",@"details":@"RedEnvelopeTip4",@"rightBtnTitle":@"RedEnvelopeTip5"},
     
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
    cell.loginInputView.keyboardType = UIKeyboardTypeNumberPad;
    cell.loginInputView.tag = indexPath.section;
    [cell.loginInputView addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
  
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 0){
        WTBacView *bac = [[WTBacView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30) backGroundColor:KWhiteColor parentView:nil];
        _allNum = [[WTLabel alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, 10, ScreenWidth - OverAllLeft_OR_RightSpace, 20) Text:[NSString stringWithFormat:@"%@ 0.005HDU",LocalizationKey(@"RedEnvelopeTip6")] Font:tFont(15) textColor:grayTextColor parentView:bac];
        return bac;
    }else{
        return nil;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return 30;
    }
    return 0;
}

- (void)textFieldWithText:(UITextField *)textField
{
    switch (textField.tag) {
        case 0:
            _money = textField.text;
            break;
        default:
            _num = textField.text;
            break;
    }
    if(_money.length && _num.length){
        _bottomView.submitButton.enabled = YES;
    }else{
        _bottomView.submitButton.enabled = NO;
    }
}

@end
