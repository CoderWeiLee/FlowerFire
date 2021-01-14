//
//  AccountReceivableDetailsTBVC.m
//  FireCoin
//
//  Created by 王涛 on 2019/7/13.
//  Copyright © 2019 王涛. All rights reserved.
//  收款账户详情

#import "AccountReceivableDetailsTBVC.h"
#import "AccountReceivableDetailsCell.h"
#import "AddAccountsReceivableSendVerificationCodeModalVC.h"

@interface AccountReceivableDetailsTBVC ()
{
    UIImageView *_qrCodeImage;
    UILabel *_qrCodeTitle;
}
@property(nonatomic, strong) NSArray *dataArray;
@property(nonatomic, strong) UIView  *footerView;
@end

@implementation AccountReceivableDetailsTBVC

@synthesize dataArray = _dataArray;

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self initData];
    [self setUpView];
}

#pragma mark - action
-(void)deleteClick{
    AddAccountsReceivableSendVerificationCodeModalVC *mvc = [AddAccountsReceivableSendVerificationCodeModalVC new];
    mvc.sendVerificationCodeWhereJump = SendVerificationCodeWhereJumpDeletePayAccount;
    mvc.sendVerificationCodeType = SendVerificationCodeTypeDeleteAcounts;
    mvc.netDic = [NSMutableDictionary dictionaryWithDictionary:@{@"pay_id":self.dataDic[@"id"]}];
    mvc.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    mvc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self presentViewController:mvc animated:YES completion:nil];
    
    @weakify(self)
    mvc.backRefreshBlock = ^{
        @strongify(self)
        [self closeVC];
    };
    
}

#pragma mark - DataSource
-(void)initData{
    if([self.dataDic[@"type_id"] intValue] == 1){
        self.dataArray = @[@{@"title":LocalizationKey(@"account type"),@"details":self.dataDic[@"type_name"]},
                           @{@"title":LocalizationKey(@"TrueName"),@"details":self.dataDic[@"true_name"]},
                           @{@"title":LocalizationKey(@"Bank card number"),@"details":self.dataDic[@"account"]},
                           @{@"title":LocalizationKey(@"Bank Account"),@"details":self.dataDic[@"bank_address"]},
                           ];
    }else if ([self.dataDic[@"type_id"] intValue] == 2){
        self.dataArray = @[@{@"title":LocalizationKey(@"account type"),@"details":LocalizationKey(@"Alipay")},
                           @{@"title":LocalizationKey(@"Name"),@"details":self.dataDic[@"true_name"]},
                           @{@"title":LocalizationKey(@"Alipay Account"),@"details":self.dataDic[@"account"]},
                           ];
        if(![HelpManager isBlankString:self.dataDic[@"qrcode"]]){
            self.tableView.tableFooterView = self.footerView;
            _qrCodeTitle.text = LocalizationKey(@"Alipay collection code");
            [_qrCodeImage sd_setImageWithURL:[NSURL URLWithString:self.dataDic[@"qrcode"]]];
        }
    }else{
        self.dataArray = @[@{@"title":LocalizationKey(@"account type"),@"details":LocalizationKey(@"WChat")},
                           @{@"title":LocalizationKey(@"TrueName"),@"details":self.dataDic[@"true_name"]},
                           @{@"title":LocalizationKey(@"WChat Account"),@"details":self.dataDic[@"account"]},
                           ];
        if(![HelpManager isBlankString:self.dataDic[@"qrcode"]]){
            self.tableView.tableFooterView = self.footerView;
            _qrCodeTitle.text = LocalizationKey(@"WeChat collection code");
            [_qrCodeImage sd_setImageWithURL:[NSURL URLWithString:self.dataDic[@"qrcode"]]];
        }
    }
    
}

#pragma mark -tableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    [self.tableView registerClass:[AccountReceivableDetailsCell class] forCellReuseIdentifier:identifier];
    AccountReceivableDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[AccountReceivableDetailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if(self.dataArray.count > 0){
        [cell setCellData:self.dataArray[indexPath.row]];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}


#pragma mark - ui
-(void)setUpView{
    self.gk_navigationItem.title = LocalizationKey(@"Collection account details");
    
    UITextView *tip = [UITextView new];
    tip.backgroundColor = rgba(254, 247, 227, 1);
    tip.textColor = rgba(236,147, 37, 1);
    tip.font = tFont(13);
    tip.bounces = NO;
    tip.editable = NO;
    tip.textContainerInset = UIEdgeInsetsMake(10, OverAllLeft_OR_RightSpace, 10, OverAllLeft_OR_RightSpace);
    tip.text = LocalizationKey(@"accountdetailsTip");
    [self.view addSubview:tip];
    CGFloat tipHeight = [HelpManager getMultiLineWithFont:13 andText:tip.text textWidth:ScreenWidth - 20];
    
    tip.frame = CGRectMake(0, 0, ScreenWidth, tipHeight + 20);
    self.tableView.frame = CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight - Height_NavBar - 70 - Height_NavBar);
    [self.view addSubview:self.tableView];
    self.tableView.theme_backgroundColor = THEME_LINE_TABLEVIEW_HEADER_COLOR;
    self.view.theme_backgroundColor = THEME_LINE_TABLEVIEW_HEADER_COLOR;
    [self.tableView setTableHeaderView:tip];
    [self.tableView setBounces:NO];
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteBtn setTitle:LocalizationKey(@"Delete this account") forState:UIControlStateNormal];
    deleteBtn.layer.cornerRadius = 3;
    deleteBtn.layer.masksToBounds = YES;
    [deleteBtn setBackgroundColor:qutesRedColor];
    [self.view addSubview:deleteBtn];
    deleteBtn.frame = CGRectMake(OverAllLeft_OR_RightSpace, ScreenHeight  - 20 - 45, ScreenWidth - OverAllLeft_OR_RightSpace * 2, 45);
    [deleteBtn addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
}

-(UIView *)footerView{
    if(!_footerView){
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 200)];
        _footerView.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
        line.theme_backgroundColor = THEME_LINE_TABLEVIEW_HEADER_COLOR;
        [_footerView addSubview:line];
        
        _qrCodeTitle = [[UILabel alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, CGRectGetMaxY(line.frame)+ 15, ScreenWidth, 20)];
        _qrCodeTitle.theme_textColor = THEME_TEXT_COLOR;
        _qrCodeTitle.font = tFont(15);
        _qrCodeTitle.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        _qrCodeTitle.layer.masksToBounds = YES;
        [_footerView addSubview:_qrCodeTitle];
        
        CGFloat imageWidth = _footerView.height - line.height - _qrCodeTitle.height - 25 - 15;
        
        _qrCodeImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_qrCodeTitle.frame)+25, imageWidth, imageWidth)];
        [_qrCodeImage setContentMode:UIViewContentModeScaleAspectFit];
        [_footerView addSubview:_qrCodeImage];
        _qrCodeImage.center = CGPointMake(_footerView.center.x, _qrCodeImage.center.y);
    }
    return _footerView;
}
@end
