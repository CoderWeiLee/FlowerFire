//
//  FinancialRecordDetailTBVC.m
//  FireCoin
//
//  Created by 王涛 on 2019/6/24.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "FinancialRecordDetailTBVC.h"
#import "FinancialRecordDetailCell.h"

@interface FinancialRecordDetailTBVC ()
{
    
}
@property(nonatomic, strong) NSArray<NSDictionary *> *dataArray;
@end

@implementation FinancialRecordDetailTBVC

@synthesize dataArray = _dataArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpView];
    [self initData];
}

#pragma mark - dataSource
-(void)initData{
    if([self.model.money containsString:@"-"]){
        _money.text = [NSString stringWithFormat:@"%@ %@",self.model.money,self.coinName];
    }else{
        _money.text = [NSString stringWithFormat:@"+%@ %@",self.model.money,self.coinName];
    }
    
    self.dataArray = @[@{@"title":LocalizationKey(@"Type"),@"type":self.model.cate_name,@"memo":self.model.memo},
                       @{@"title":LocalizationKey(@"Status"),@"type":self.model.status_name,@"memo":@""},
                       @{@"title":LocalizationKey(@"Date"),@"type":self.model.createtime,@"memo":@""}];
}

#pragma mark - tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    [self.tableView registerClass:[FinancialRecordDetailCell class] forCellReuseIdentifier:identifier];
    FinancialRecordDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[FinancialRecordDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setCellData:self.dataArray[indexPath.row]];
    return cell;
}

#pragma mark - ui
-(void)setUpView{
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    [self.view addSubview:self.tableView];
    
    UIView  *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 80)];
    _money = [UILabel new];
    _money.theme_backgroundColor = THEME_MAIN_BACKGROUNDCOLOR;
    _money.layer.masksToBounds = YES;
    _money.theme_textColor = THEME_TEXT_COLOR;
    _money.font = [UIFont boldSystemFontOfSize:25];
    [headerView addSubview:_money];
    [_money mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(headerView.mas_bottom).offset(-20);
        make.left.mas_equalTo(headerView.mas_left).offset(OverAllLeft_OR_RightSpace);
        make.width.mas_equalTo(ScreenWidth - 30);
    }];
    _money.adjustsFontSizeToFitWidth = YES;
    
    self.tableView.tableHeaderView = headerView;
    
}

@end
