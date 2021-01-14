//
//  FFAddAcountViewController.m
//  FlowerFire
//
//  Created by 王涛 on 2020/8/24.
//  Copyright © 2020 Celery. All rights reserved.
//  添加账户

#import "FFAddAcountViewController.h"
#import "SettingUpdateSubmitButton.h"
#import "SettingUpdateFormCell.h"
#import "FFRegisteredParamsModel.h"
#import "FFSaveMnemonicViewController.h"

@interface FFAddAcountViewController ()
{
    NSString *_userName,*_pwd1,*_pwd2;
    SettingUpdateSubmitButton *_bottomView;
}
@end

@implementation FFAddAcountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavBar];
    [self createUI];
    [self initData];
}

/// 提交修改
-(void)submitClick{
    if([[UniversalViewMethod sharedInstance] checkIsHaveNumAndLetter:_userName] == 3){
        //获取一波助记词
         NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:1];
         md[@"username"] = _userName;
         [self.afnetWork jsonPostDict:@"/api/user/getMnemonic" JsonDict:md Tag:@"1"];
    }else{
        printAlert(LocalizationKey(@"578Tip44"), 1.f);
    }

}

- (void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    if([type isEqualToString:@"1"]){
        NSString *mnemonic = dict[@"data"][@"mnemonic"];
        if(![HelpManager isBlankString:mnemonic]){
            FFRegisteredParamsModel *model = [FFRegisteredParamsModel new];
            model.username = _userName;
            model.mnemonic = mnemonic;
            FFSaveMnemonicViewController *r = [FFSaveMnemonicViewController new];
            r.registeredParamsModel = model;
            [self.navigationController pushViewController:r animated:YES];
        }
    }
}
 
- (void)createNavBar{
    self.gk_navigationItem.title = LocalizationKey(@"578Tip43");
}

- (void)createUI{
    self.tableView.frame = CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight - Height_NavBar);
    self.tableView.bounces = NO;
    
    _bottomView = [[SettingUpdateSubmitButton alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 150)];
    [_bottomView.submitButton setTitle:LocalizationKey(@"578Tip50") forState:UIControlStateNormal];
    [_bottomView.submitButton addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = _bottomView;
    [self.view addSubview:self.tableView];
     
}

- (void)initData{
    self.dataArray = @[@{@"title":@"578Tip44",@"details":@"578Tip47"} ,
    ].copy;
    
    [self.tableView reloadData];
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
   
- (void)textFieldWithText:(UITextField *)textField
{
    switch (textField.tag) {
        case 0:
            _userName = textField.text;
            break;
    }
    if(_userName.length){
        _bottomView.submitButton.enabled = YES;
    }else{
        _bottomView.submitButton.enabled = NO;
    }
}


 


@end
