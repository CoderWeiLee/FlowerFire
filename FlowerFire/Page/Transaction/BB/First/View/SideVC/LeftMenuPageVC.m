//
//  LeftMenuPageVC.m
//  FireCoin
//
//  Created by 王涛 on 2019/6/5.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "LeftMenuPageVC.h"
#import "LeftMenuPageCell.h"
 
@interface LeftMenuPageVC ()


@end

@implementation LeftMenuPageVC

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.searchField resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.gk_navigationBar.hidden = YES;
    [self setUpView];
}

#pragma mark - action
-(void)changedTextField:(UITextField *)textField
{ 
    !self.searchBlock ? : self.searchBlock(textField.text);
}

-(void)cleanFieldClick{
    _searchField.text = @"";
    !self.searchBlock ? : self.searchBlock(@"");
}

#pragma mark - tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.searchField;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    [self.tableView registerClass:[LeftMenuPageCell class] forCellReuseIdentifier:identifier];
    LeftMenuPageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[LeftMenuPageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (self.modelArray.count >0) {
        [cell setCellData:self.modelArray[indexPath.row]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.modelArray.count == 0) {
        return;
    }
    QuotesTransactionPairModel *model = self.modelArray[indexPath.row];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"leftSymbol"] = model.from_symbol;
    dict[@"rightSymbol"] = model.to_symbol;
    dict[@"fromId"] = model.from;
//    dict[@"leftCoinId"] = model.from;
//    dict[@"rightCoinId"] = model.to;
    NSNotification *notification =[NSNotification notificationWithName:CURRENTSELECTED_SYMBOL object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
  
    !self.backRefreshBlock ? : self.backRefreshBlock();
}

#pragma mark - ui
-(void)setUpView{
    self.tableView.frame = CGRectMake(0, 0, ScreenWidth/3*2, ScreenHeight - (60+Height_StatusBar+50));
    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
    self.tableView.rowHeight = 55;
    self.tableView.bounces = NO;
    [self.view addSubview:self.tableView];
}

-(void)setModelArray:(NSArray *)modelArray{
    _modelArray = modelArray;
    [self.tableView reloadData];
}

-(UITextField *)searchField{
    if(!_searchField){
        _searchField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
        _searchField.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        _searchField.theme_textColor = THEME_TEXT_COLOR;
        _searchField.keyboardType = UIKeyboardTypeNamePhonePad;
        _searchField.layer.borderWidth = 1;
        _searchField.layer.theme_borderColor = THEME_LINE_TABLEVIEW_SEPARATOR_COLOR;
        _searchField.theme_attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSStringFormat(@"%@",LocalizationKey(@"Search")) attributes:@{ SDThemeForegroundColorAttributeName:THEME_TEXT_PLACEHOLDERCOLOR}];
        
        [_searchField addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
        
        UIView *leftView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        UIButton *leftView = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftView setImage:[UIImage imageNamed:@"search_symbol_search"] forState:UIControlStateNormal];
        leftView.frame = CGRectMake(0, 0, 40, 40);
        [leftView1 addSubview:leftView];
        _searchField.leftView = leftView1;
        _searchField.leftViewMode = UITextFieldViewModeAlways;
        
        UIView *rightView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 45, 40)];
        UIButton *rightView = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightView addTarget:self action:@selector(cleanFieldClick) forControlEvents:UIControlEventTouchUpInside];
        [rightView theme_setImage:@"total_balance_clear_normal" forState:UIControlStateNormal]; 
        rightView.frame = CGRectMake(0, 0, 40, 40);
        [rightView1 addSubview:rightView];
        _searchField.rightView = rightView1;
        _searchField.rightViewMode = UITextFieldViewModeWhileEditing;
    }
    return _searchField;
}

@end
