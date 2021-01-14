//
//  SwitchPaymentMethodView.m
//  FireCoin
//
//  Created by 王涛 on 2019/5/29.
//  Copyright © 2019 王涛. All rights reserved.
//  切换支付方式

#import "SwitchPaymentMethodView.h"
#import "SwitchPaymentCell.h"
#import "AppealTBVC.h"


@interface SwitchPaymentMethodView ()<UITableViewDelegate,UITableViewDataSource>
{
   
}
@property(nonatomic, strong) NSArray     *dataArray;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UIButton    *payMent;

@end

@implementation SwitchPaymentMethodView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = KWhiteColor;
        self.layer.cornerRadius = 5;
        
        [self addSubview:self.payMent];
        [self.payMent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(OverAllLeft_OR_RightSpace);
            make.top.mas_equalTo(self.mas_top).offset(15);
            make.size.mas_equalTo(CGSizeMake(100, 30));
        }];
       
        
        UIButton *switchImage = [UIButton buttonWithType:UIButtonTypeCustom];
        [switchImage setImage:[UIImage imageNamed:@"account_item_arrow_right"] forState:UIControlStateNormal];
        [self addSubview:switchImage];
        [switchImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.payMent.mas_centerY);
            make.right.mas_equalTo(self.mas_right).offset(-OverAllLeft_OR_RightSpace);
            make.size.mas_equalTo(CGSizeMake(12, 17));
        }];
        
        UIButton *switchTip = [UIButton buttonWithType:UIButtonTypeCustom];
        [switchTip setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [switchTip setTitle:LocalizationKey(@"FiatOrderTip28") forState:UIControlStateNormal];
        switchTip.titleLabel.font = tFont(18);
        [self addSubview:switchTip];
        [switchTip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.payMent.mas_centerY);
            make.right.mas_equalTo(switchImage.mas_left).offset(-5);
        }];
        [switchTip sizeToFit];
        
        UIView *line = [UIView new];
        line.backgroundColor = rgba(233, 235, 237, 1);
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(OverAllLeft_OR_RightSpace);
            make.top.mas_equalTo(switchTip.mas_bottom).offset(15);
            make.size.mas_equalTo(CGSizeMake(ScreenWidth - 80, 1));
        }];
        
        [switchImage addTarget:self action:@selector(switchPayMentClick) forControlEvents:UIControlEventTouchUpInside];
        [self.payMent addTarget:self action:@selector(switchPayMentClick) forControlEvents:UIControlEventTouchUpInside];
        [switchTip addTarget:self action:@selector(switchPayMentClick) forControlEvents:UIControlEventTouchUpInside];
        

        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.estimatedRowHeight = 60;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(line.mas_bottom);
            make.left.mas_equalTo(self.mas_left);
            make.width.mas_equalTo(self.mas_width);
            make.height.mas_equalTo(60 * 4);
        }];
        
        line = [UIView new];
        line.backgroundColor = rgba(233, 235, 237, 1);
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(OverAllLeft_OR_RightSpace);
            make.top.mas_equalTo(self.tableView.mas_bottom).offset(15);
            make.size.mas_equalTo(CGSizeMake(ScreenWidth - 80, 1));
        }];
        
        UILabel *tip = [UILabel new];
        tip.text = LocalizationKey(@"FiatOrderTip29");
        tip.numberOfLines = 0;
        [tip adjustsFontSizeToFitWidth];
        tip.textColor = rgba(43, 139, 212, 1);
        [self addSubview:tip];
        [tip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(OverAllLeft_OR_RightSpace);
            make.right.mas_equalTo(self.mas_right).offset(-OverAllLeft_OR_RightSpace);
            make.top.mas_equalTo(line.mas_bottom).offset(15);
        }];
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn setTitle:LocalizationKey(@"FiatOrderTip30") forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = tFont(15);
        [cancelBtn setTitleColor:rgba(60, 69, 93, 1) forState:UIControlStateNormal];
        [cancelBtn setBackgroundColor:rgba(227, 227, 227, 1)];
        cancelBtn.layer.cornerRadius = 3;
        [self addSubview:cancelBtn];
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(OverAllLeft_OR_RightSpace);
            make.top.mas_equalTo(tip.mas_bottom).offset(15);
            make.size.mas_equalTo(CGSizeMake((ScreenWidth - 60 - 7.5) /4 * 1, 50));
        }];
        cancelBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
   
        UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [submitBtn setTitle:LocalizationKey(@"FiatOrderTip31") forState:UIControlStateNormal];
        [submitBtn setBackgroundColor:rgba(86, 112, 143, 1)];
        submitBtn.titleLabel.font = tFont(16);
        submitBtn.layer.cornerRadius = 3;   
        [self addSubview:submitBtn];
        [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).offset(-OverAllLeft_OR_RightSpace);
            make.top.mas_equalTo(tip.mas_bottom).offset(15);
            make.size.mas_equalTo(CGSizeMake((ScreenWidth - 60 - 7.5) /4 * 3, 50));
        }];
        submitBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        
        self.leftBtn = cancelBtn;
        self.rightBtn = submitBtn;
        
        self.bottomView = submitBtn;
        
        [cancelBtn addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
        [submitBtn addTarget:self action:@selector(submitClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

#pragma mark - tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
 

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    [self.tableView registerClass:[SwitchPaymentCell class] forCellReuseIdentifier:identifier];
    SwitchPaymentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[SwitchPaymentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setCellData:self.dataArray[indexPath.row]];
    return cell;
}

#pragma mark - netWork
-(void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    if([type isEqualToString:@"1"]){ //付款确认
        !self.backRefreshBlock ? : self.backRefreshBlock();
    }else{  //确认取消交易
        !self.backRefreshBlock ? : self.backRefreshBlock();
    }
    printAlert(dict[@"msg"], 1);
}

#pragma mark - action
-(void)submitClick:(UIButton *)btn{
    if([btn.titleLabel.text isEqualToString:LocalizationKey(@"FiatOrderTip31")]){
        UIAlertController *ua = [UIAlertController alertControllerWithTitle:LocalizationKey(@"FiatOrderTip32") message:LocalizationKey(@"FiatOrderTip33") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *bank = [UIAlertAction actionWithTitle:LocalizationKey(@"confirm") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self.afnetWork jsonPostDict:@"/api/otc/payOtcOrder" JsonDict:@{@"otc_order_id":self.model.otcOrderId} Tag:@"1"];
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:LocalizationKey(@"cancel") style:UIAlertActionStyleCancel handler:nil];
        [ua addAction:bank];
        [ua addAction:cancel];
        [[self viewController]. navigationController presentViewController:ua animated:YES completion:nil];
    }
}

-(void)cancelClick:(UIButton *)btn{
    if([btn.titleLabel.text isEqualToString:LocalizationKey(@"FiatOrderTip30")]){
        UIAlertController *ua = [UIAlertController alertControllerWithTitle:LocalizationKey(@"FiatOrderTip34") message:LocalizationKey(@"FiatOrderTip35") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *bank = [UIAlertAction actionWithTitle:LocalizationKey(@"confirm") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self.afnetWork jsonPostDict:@"/api/otc/cancelOtcOrder" JsonDict:@{@"otc_order_id":self.model.otcOrderId} Tag:@"2"];
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:LocalizationKey(@"FiatOrderTip36") style:UIAlertActionStyleCancel handler:nil];
        [ua addAction:bank];
        [ua addAction:cancel];
        [[self viewController]. navigationController presentViewController:ua animated:YES completion:nil];
    }else{
        AppealTBVC *avc = [AppealTBVC new];
        avc.model = self.model;
       
        [[self viewController].navigationController pushViewController:avc animated:YES];
    }
    
}

/**
 "pay_list": [
 {
 "id": 1,
 "user_id": 2,
 "type_id": 1,
 "true_name": "",
 "account": "6221222255556666",
 "bank_address": "",
 "qrcode": "",
 "status": 1,
 "createtime": 1556633365
 }
 ],
 */
-(void)switchPayMentClick{
    UIAlertController *ua = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    NSString *actionTitle ;
    
    for (payMethodModel *model in self.model.pay_list) {
      
        if([model.type_id isEqualToString:@"1"]){
            actionTitle = LocalizationKey(@"Bank card");
        }else if ([model.type_id isEqualToString:@"2"]){
            actionTitle = LocalizationKey(@"Alipay");
        }else{
            actionTitle = LocalizationKey(@"WChat");
        }
        UIAlertAction *bank = [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if([model.type_id isEqualToString:@"1"]){
                 self.switchPaymentMethodType = SwitchPaymentMethodTypeBank;
            }else if ([model.type_id isEqualToString:@"2"]){
                self.switchPaymentMethodType = SwitchPaymentMethodTypeAliPay ;
            }else{
                self.switchPaymentMethodType = SwitchPaymentMethodTypeWeChat;
            }
            
        }];
        [ua addAction:bank];
    }
  
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:LocalizationKey(@"cancel") style:UIAlertActionStyleCancel handler:nil];
    [ua addAction:cancel];
    [[self viewController]. navigationController presentViewController:ua animated:YES completion:nil];
}

#pragma mark - lazyInit
-(OrderRecordModel *)model{
    if(!_model){
        _model = [OrderRecordModel new];
    }
    return _model;
}

-(void)setSwitchPaymentMethodType:(SwitchPaymentMethodType)switchPaymentMethodType{
    _switchPaymentMethodType = switchPaymentMethodType;
   
    switch (switchPaymentMethodType) {
        case SwitchPaymentMethodTypeBank:
        {
            [self getPayment:@"1"];
        }
            break;
        case SwitchPaymentMethodTypeAliPay:
        {
            [self getPayment:@"2"];
        }
            break;
        default:
        {
            [self getPayment:@"3"];
        }
            break;
    }
}

-(void)getPayment:(NSString *)payMentId{
    for (int i = 0; i<self.model.pay_list.count; i++) {
        payMethodModel *model = self.model.pay_list[i];
        
        if(![model.type_id isEqualToString:payMentId]){
            continue;
        }
        if([model.type_id isEqualToString:@"1"]){
            self.dataArray = @[@{@"leftText":LocalizationKey(@"Bank card"),@"rightText":self.model.pay_list[i].bank_address,@"showLeftBtn":@"0",@"showRightBtn":@"0"},
                               @{@"leftText":LocalizationKey(@"FiatOrderTip38"),@"rightText":self.model.pay_list[i].true_name,@"showLeftBtn":@"0",@"showRightBtn":@"1"},
                               @{@"leftText":LocalizationKey(@"Bank card number"),@"rightText":self.model.pay_list[i].account,@"showLeftBtn":@"0",@"showRightBtn":@"1"},
                               @{@"leftText":LocalizationKey(@"FiatOrderTip37"),@"rightText":self.model.otcOrderId,@"showLeftBtn":@"1",@"showRightBtn":@"1"}];
            [self.payMent setTitle:LocalizationKey(@"Bank card") forState:UIControlStateNormal];
            [self.payMent setImage:[UIImage imageNamed:@"mycenter_4"] forState:UIControlStateNormal]; 
        }else if ([model.type_id isEqualToString:@"3"]){
            self.dataArray = @[@{@"leftText":LocalizationKey(@"FiatOrderTip38"),@"rightText":self.model.pay_list[i].true_name,@"showLeftBtn":@"0",@"showRightBtn":@"0"},
                               @{@"leftText":LocalizationKey(@"WChat Account"),@"rightText":self.model.pay_list[i].account,@"showLeftBtn":@"0",@"showRightBtn":@"1"},
                               @{@"leftText":LocalizationKey(@"FiatOrderTip39"),@"rightText":self.model.pay_list[i].qrcode,@"showLeftBtn":@"0",@"showRightBtn":@"1"},
                               @{@"leftText":LocalizationKey(@"FiatOrderTip37"),@"rightText":self.model.otcOrderId,@"showLeftBtn":@"1",@"showRightBtn":@"1"}];
            [self.payMent setTitle:LocalizationKey(@"WChat") forState:UIControlStateNormal];
            [self.payMent setImage:[UIImage imageNamed:@"mycenter_7"] forState:UIControlStateNormal];
        }else{
            self.dataArray = @[@{@"leftText":LocalizationKey(@"FiatOrderTip38"),@"rightText":self.model.pay_list[i].true_name,@"showLeftBtn":@"0",@"showRightBtn":@"0"},
                               @{@"leftText":LocalizationKey(@"Alipay Account"),@"rightText":self.model.pay_list[i].account,@"showLeftBtn":@"0",@"showRightBtn":@"1"},
                               @{@"leftText":LocalizationKey(@"FiatOrderTip39"),@"rightText":self.model.pay_list[i].qrcode,@"showLeftBtn":@"0",@"showRightBtn":@"1"},
                               @{@"leftText":LocalizationKey(@"FiatOrderTip37"),@"rightText":self.model.otcOrderId,@"showLeftBtn":@"1",@"showRightBtn":@"1"}];
            [self.payMent setTitle:LocalizationKey(@"Alipay") forState:UIControlStateNormal];
            [self.payMent setImage:[UIImage imageNamed:@"mycenter_5"] forState:UIControlStateNormal];
            
        }
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(60 * self.dataArray.count);
        }];
        [self.tableView reloadData];
    }
}

-(UIButton *)payMent{
    if(!_payMent){
        _payMent = [UIButton buttonWithType:UIButtonTypeCustom];
        [_payMent setTitleColor:KBlackColor forState:UIControlStateNormal];
        _payMent.titleLabel.font = tFont(16);
        _payMent.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
        _payMent.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return _payMent;
}


@end
