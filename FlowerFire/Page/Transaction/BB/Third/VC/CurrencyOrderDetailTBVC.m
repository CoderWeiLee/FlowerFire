
//
//  CurrencyOrderDetailTBVC.m
//  FireCoin
//
//  Created by 王涛 on 2019/6/17.
//  Copyright © 2019 王涛. All rights reserved.
//  币币交易委托单明细

#import "CurrencyOrderDetailTBVC.h"
#import "CurrencyTransactionModel.h"

#define  CurrentCommissionGrayTextColor rgba(161, 164, 171, 1)

extern int FROMSCALE;
extern int TOSCALE;
extern int PRICESCALE;
@interface CurrencyOrderDetailTBVC ()
{
    
    NSArray *detailsArray;
    UILabel *typeLabel,*price,*amount,*trueTotalPrice,*priceNum, *amountNum, *totalPriceNum,*pairName,*feeNum,*feeTip;
}
@property(nonatomic, strong) UIView *headerView;
@end

@implementation CurrencyOrderDetailTBVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpView];
    [self initData];
}

#pragma mark - dataSource
-(void)initData{
    if(![HelpManager isBlankString:self.trade_id]){
        [self.afnetWork jsonPostDict:@"/api/cc/myCcInfo" JsonDict:@{@"trade_id":self.trade_id} Tag:@"1"];
    }
}

-(void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    CurrencyTransactionModel *model = [CurrencyTransactionModel yy_modelWithDictionary:dict[@"data"]];
   
    if([model.order_type isEqualToString:@"0"]){
        typeLabel.textColor = qutesGreenColor;
        typeLabel.text = LocalizationKey(@"BUY");
    }else{
        typeLabel.textColor = qutesRedColor;
        typeLabel.text = LocalizationKey(@"SELL");
    }
    
    //限价
    if([model.price_type isEqualToString:@"1"]){
         priceNum.text = model.total_amount;
    }else{
         priceNum.text = LocalizationKey(@"market");
    }
    amountNum.text = [ToolUtil stringFromNumber:[model.deal_price doubleValue] withlimit:PRICESCALE];
    totalPriceNum.text = [ToolUtil stringFromNumber:[model.deal_amount doubleValue] withlimit:FROMSCALE];
    

    pairName.text = [NSString stringWithFormat:@"%@/%@",model.from_symbol,model.to_symbol];
    price.text = [NSString stringWithFormat:@"%@%@",LocalizationKey(@"ccTip13"),model.to_symbol];
    amount.text = [NSString stringWithFormat:@"%@%@",LocalizationKey(@"ccTip14"),model.to_symbol];
    trueTotalPrice.text = [NSString stringWithFormat:@"%@%@",LocalizationKey(@"ccTip15"),model.from_symbol];
    feeTip.text = [NSString stringWithFormat:@"%@%@",LocalizationKey(@"ccTip16"),model.from_symbol];
    
  
    feeNum.text = model.fee_amount;
    
    NSString *time = [HelpManager getTimeStr:model.finishtime dataFormat:@"HH:mm MM/dd"];
    
    detailsArray = @[@{@"title":LocalizationKey(@"ccTip17"),@"detail":time},
                     @{@"title":LocalizationKey(@"ccTip18"),@"detail":[model.price_type isEqualToString:@"1"] ? [NSString stringWithFormat:@"%@ %@",[ToolUtil stringFromNumber:[model.price doubleValue] withlimit:PRICESCALE],model.to_symbol] : LocalizationKey(@"market")},
                     @{@"title":LocalizationKey(@"ccTip15"),@"detail":[NSString stringWithFormat:@"%@ %@",[ToolUtil stringFromNumber:[model.deal_amount doubleValue] withlimit:FROMSCALE],model.from_symbol]},
                     @{@"title":LocalizationKey(@"ccTip16"),@"detail":[NSString stringWithFormat:@"%@ %@",model.fee_amount,model.from_symbol]}];
    
    
    [self.tableView reloadData];
}

#pragma mark - tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return detailsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
    UITableViewCell *cell;// = [tableView cellForRowAtIndexPath:indexPath];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    cell.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
    cell.textLabel.text = detailsArray[indexPath.row][@"title"];
    cell.detailTextLabel.text = detailsArray[indexPath.row][@"detail"];
    cell.textLabel.theme_textColor = THEME_TEXT_COLOR;
    cell.textLabel.font = tFont(15);
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    cell.detailTextLabel.font = tFont(15);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *bac = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    bac.theme_backgroundColor = THEME_LINE_TABLEVIEW_HEADER_COLOR;
    return bac;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

#pragma mark - ui
-(void)setUpView{
    self.title = LocalizationKey(@"ccTip12");
    
    self.tableView.estimatedRowHeight = 44;
    self.tableView.bounces = NO;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headerView;

}

-(UIView *)headerView{
    if(!_headerView){
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 195)];
        _headerView.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        
        typeLabel  = [UILabel new];
        typeLabel.text = @"--";
        typeLabel.textColor = qutesGreenColor;
        typeLabel.font = [UIFont boldSystemFontOfSize:18];
        [_headerView addSubview:typeLabel];
        [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_headerView.mas_top).offset(15);
            make.left.mas_equalTo(_headerView.mas_left).offset(OverAllLeft_OR_RightSpace);
        }];
        
        pairName = [UILabel new];
        pairName.text = @"--/--";
        pairName.textColor = CurrentCommissionGrayTextColor;
        pairName.font = [UIFont boldSystemFontOfSize:18];
        [_headerView addSubview:pairName];
        [pairName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(typeLabel.mas_centerY).offset(0);
            make.left.mas_equalTo(typeLabel.mas_right).offset(5);
        }];
        
        price = [UILabel new];
        price.text = @"成交总额  (--)";
        price.textColor = CurrentCommissionGrayTextColor;
        price.font = tFont(14);
        [_headerView addSubview:price];
        [price mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(typeLabel.mas_bottom).offset(20);
            make.left.mas_equalTo(_headerView.mas_left).offset(20);
        }];
        
        amount = [UILabel new];
        amount.text = @"成交量 --";
        amount.textColor = CurrentCommissionGrayTextColor;
        amount.font = tFont(14);
        [_headerView addSubview:amount];
        [amount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(price.mas_centerY).offset(0);
            make.centerX.mas_equalTo(_headerView.mas_centerX).offset(0);
        }];
       
        trueTotalPrice = [UILabel new];
        trueTotalPrice.text = @"实际量 --";
        trueTotalPrice.textColor = CurrentCommissionGrayTextColor;
        trueTotalPrice.font = tFont(14);
        [_headerView addSubview:trueTotalPrice];
        [trueTotalPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(price.mas_centerY).offset(0);
            make.right.mas_equalTo(_headerView.mas_right).offset(-OverAllLeft_OR_RightSpace);
        }];
        
        priceNum = [UILabel new];
        priceNum.text = @"0000";
        priceNum.theme_textColor = THEME_TEXT_COLOR;
        priceNum.textAlignment = NSTextAlignmentLeft;
        priceNum.font = tFont(15);
        [_headerView addSubview:priceNum];
        [priceNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(price.mas_bottom).offset(10);
            make.left.mas_equalTo(price.mas_left).offset(0);
      //      make.bottom.mas_equalTo(_headerView.mas_bottom).offset(-25);
        }];

        amountNum = [UILabel new];
        amountNum.text = @"0000";
        amountNum.theme_textColor = THEME_TEXT_COLOR;
        amountNum.font = tFont(15);
        [_headerView addSubview:amountNum];
        [amountNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(priceNum.mas_centerY).offset(0);
            make.centerX.mas_equalTo(amount.mas_centerX).offset(0);
        }];
        
        totalPriceNum = [UILabel new];
        totalPriceNum.text = @"0000";
        totalPriceNum.theme_textColor = THEME_TEXT_COLOR;
        totalPriceNum.textAlignment = NSTextAlignmentRight;
        totalPriceNum.font = tFont(15);
        [_headerView addSubview:totalPriceNum];
        [totalPriceNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(priceNum.mas_centerY).offset(0);
            make.right.mas_equalTo(trueTotalPrice.mas_right).offset(0);
        }];
        
        feeTip = [UILabel new];
        feeTip.text = @"手续费 --";
        feeTip.textColor = CurrentCommissionGrayTextColor;
        feeTip.textAlignment = NSTextAlignmentCenter;
        feeTip.font = tFont(14);
        [_headerView addSubview:feeTip];
        [feeTip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(priceNum.mas_bottom).offset(20);
            make.left.mas_equalTo(price.mas_left).offset(0);
        }];
        
        feeNum = [UILabel new];
        feeNum.text = @"0000";
        feeNum.theme_textColor = THEME_TEXT_COLOR;
        feeNum.font = tFont(15);
        [_headerView addSubview:feeNum];
        [feeNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(feeTip.mas_bottom).offset(10);
            make.left.mas_equalTo(feeTip.mas_left).offset(0);
        }];
    }
    return _headerView;
}


@end
