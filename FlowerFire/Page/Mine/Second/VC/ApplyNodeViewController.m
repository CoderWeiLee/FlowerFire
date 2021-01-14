//
//  ApplyNodeViewController.m
//  FlowerFire
//
//  Created by 王涛 on 2020/8/24.
//  Copyright © 2020 Celery. All rights reserved.
//  申请节点

#import "ApplyNodeViewController.h"
#import "SettingUpdateSubmitButton.h"
#import "SettingUpdateFormCell.h"

@interface ApplyNodeViewController ()
{
    SettingUpdateSubmitButton *_bottomView;
    NSString        *_accountName,*_email,*_nodeClaim;
}
@end

@implementation ApplyNodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     
    [self createNavBar];
    [self createUI];
    [self initData];
}

/// 提交修改
-(void)submitClick{
    if(![[UniversalViewMethod sharedInstance] checkEmail:_email]){
        printAlert(LocalizationKey(@"changeEmailTip5"), 1.f);
        return;
    }
    NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:2];
    md[@"email"] = _email;
    md[@"description"] = _nodeClaim;
    [self.afnetWork jsonPostDict:@"/api/user/applyNode" JsonDict:md Tag:@"1"];
    
}

- (void)createNavBar{
    self.gk_navigationItem.title = LocalizationKey(@"578Tip19");
}

- (void)createUI{
    self.tableView.frame = CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight - Height_NavBar);
    self.tableView.bounces = NO;
    
    _bottomView = [[SettingUpdateSubmitButton alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 150)];
    [_bottomView.submitButton setTitle:LocalizationKey(@"578Tip26") forState:UIControlStateNormal];
    [_bottomView.submitButton addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = _bottomView;
    [self.view addSubview:self.tableView];
     
}

- (void)initData{
    self.dataArray = @[@{@"title":@"578Tip20",@"details":@"578Tip21"},
                       @{@"title":@"578Tip22",@"details":@"578Tip23",@"keyBoardType":@"1"},
    @{@"title":@"578Tip24",@"details":@"578Tip25"} ,
    ].copy;
    
    [self.tableView reloadData];
}

- (void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    printAlert(dict[@"msg"], 1.f);
    [self closeVC];
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
    if(indexPath.section == 0){
        cell.loginInputView.text = [WTUserInfo shareUserInfo].username;
        cell.loginInputView.userInteractionEnabled = NO;
    }else{
        cell.loginInputView.text = @"";
        cell.loginInputView.userInteractionEnabled = YES;
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
   
- (void)textFieldWithText:(UITextField *)textField
{
    switch (textField.tag) {
        case 0:
            _accountName = textField.text;
            break;
        case 1:
            _email = textField.text;
            break;
        default:
            _nodeClaim = textField.text;
            break;
    }
    if(_email.length && _nodeClaim.length){
        _bottomView.submitButton.enabled = YES;
    }else{
        _bottomView.submitButton.enabled = NO;
    }
}



@end
