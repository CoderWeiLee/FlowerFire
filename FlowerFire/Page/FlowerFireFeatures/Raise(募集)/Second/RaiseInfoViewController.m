//
//  RaiseInfoViewController.m
//  FlowerFire
//
//  Created by 王涛 on 2020/7/15.
//  Copyright © 2020 Celery. All rights reserved.
//  募集详情

#import "RaiseInfoViewController.h"
#import "ApplyCoinViewController.h"
#import "SettingUpdateSubmitButton.h"
#import "RaiseInfoHeaderView.h"
#import "WTTableStyleValue1Cell.h"

@interface RaiseInfoViewController ()
{
    SettingUpdateSubmitButton *_bottomView;
}

@property(nonatomic, strong)NSMutableArray *section1Array;
@end

@implementation RaiseInfoViewController

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
 
    }else{
        printAlert(dict[@"msg"], 1.f);
        [self closeVC];
    }
}

#pragma mark - initViewDelegate
- (void)createNavBar{
    self.gk_navigationItem.title = LocalizationKey(@"RaiseTip10");
    
    WTButton *recordButton = [[WTButton alloc] initWithFrame:CGRectMake(0, 0, 50, 40) titleStr:LocalizationKey(@"RaiseTip9") titleFont:tFont(15) titleColor:[UIColor redColor] parentView:nil];
    
    @weakify(self)
    [recordButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        @strongify(self)
        ApplyCoinViewController *avc = [ApplyCoinViewController new];
        [self.navigationController pushViewController:avc animated:YES];
    }];
    
    recordButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.gk_navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:recordButton];
}

- (void)createUI{
    self.tableView.bounces = NO;
    self.tableView.backgroundColor = KGrayBacColor;
    self.tableView.frame = CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight - Height_NavBar);
    
    RaiseInfoHeaderView *headerView = [[RaiseInfoHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100) coinName:self.coinName];
    self.tableView.tableHeaderView = headerView;
    
    _bottomView = [[SettingUpdateSubmitButton alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 150)];
    _bottomView.backgroundColor = KWhiteColor;
    
    [_bottomView.submitButton setTitle:LocalizationKey(@"RaiseTip25") forState:UIControlStateNormal];
    [_bottomView.submitButton addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    
    WTLabel *tip = [[WTLabel alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, OverAllLeft_OR_RightSpace, 200, 20) Text:LocalizationKey(@"RaiseTip24") Font:tFont(15) textColor:KBlackColor parentView:_bottomView];
     
    WTLabel *_info = [[WTLabel alloc] initWithFrame:CGRectMake(tip.left, tip.bottom + 10, ScreenWidth - 2 * OverAllLeft_OR_RightSpace, 0)];
    _info.numberOfLines = 0;
    
    [_bottomView addSubview:_info];
    
    NSString *str = @"XMZ简介：XMZ项目由国际数字资产中心主导，美国区块链研究室和联合国区块链基金会联合发起，一个安全，简便，面向社区的全球首家创新型区块链股票交易平台，由美国区块链实验室负责相关技术，与上市公司股东达成合作协议支撑起庞大的商业生态。它旨在解决当前市场面临的问题，而这些问题会导致创业公司及用户对数字资产行业的积极性降低。XMZ与多家上市公司和证券交易所、数字货币交易所达成战略合作协议，其平台数字通证Token 可用于直接兑换USDT与对应股权，实现币股同权、币股同筹，推动真正意义上的数字资产证券化。 依托于股票金融和强大的实体商业生态，在上市平台中数字资产锚定股票价格实现数字资产价值落地。目前 XMZ计划在日本、韩国、印度等国家上线，后期将陆续开放各个国家和地区的平台通道。";
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:str];
    text.yy_font = tFont(15);
    text.yy_color = [UIColor grayColor];
    
    YYTextContainer *container = [YYTextContainer new];
    container.size = CGSizeMake(ScreenWidth - 2 * OverAllLeft_OR_RightSpace, CGFLOAT_MAX);
    container.maximumNumberOfRows = 0;
    
    YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:text];
   
   // dispatch_async(dispatch_get_main_queue(), ^{
        _info.size = layout.textBoundingSize;
        _info.textLayout = layout;
        
        _bottomView.submitButton.top = _info.bottom + 30;
        _bottomView.height = _bottomView.submitButton.bottom + 30;
    
        self.tableView.tableFooterView = _bottomView;
       
  //  });
     
    [self.view addSubview:self.tableView];
     
}

- (void)theme_didChanged{
     self.gk_navLineHidden = NO;
}
 
- (void)initData{
    self.section1Array = @[@{@"title":LocalizationKey(@"RaiseTip12"),@"details":@"2020-05-01"},
        @{@"title":LocalizationKey(@"RaiseTip13"),@"details":@"21.5USDT"},
        @{@"title":LocalizationKey(@"RaiseTip14"),@"details":@"USDT"},
        @{@"title":LocalizationKey(@"RaiseTip15"),@"details":@"新用户(1:14)老用户(1:14)"},
        @{@"title":LocalizationKey(@"RaiseTip16"),@"details":@"不在项目方网体中"},
        @{@"title":LocalizationKey(@"RaiseTip17"),@"details":@"在项目方网体中"},].copy;
    
    self.dataArray = @[@{@"title":@"RaiseTip19",@"details":@"2020-04-30"},
                       @{@"title":@"RaiseTip20",@"details":@"1,000,000,000"},
                       @{@"title":@"RaiseTip21",@"details":@"稍后更新"},
                       @{@"title":@"RaiseTip22",@"details":@"稍后更新"},
                       @{@"title":@"RaiseTip23",@"details":@"稍后更新"},
     
    ].copy;
}

#pragma mark - tableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        static NSString *identifier = @"cell";
        [self.tableView registerClass:[WTTableStyleValue1Cell class] forCellReuseIdentifier:identifier];
        WTTableStyleValue1Cell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        NSDictionary *dic = self.section1Array[indexPath.row];
        NSString *text = [NSString stringWithFormat:@"%@ %@",LocalizationKey(dic[@"title"]),LocalizationKey(dic[@"details"])];
        
        NSMutableAttributedString *ma = [[NSMutableAttributedString alloc] initWithString:text];
        [ma setYy_font:tFont(15)];
        [ma yy_setColor:[UIColor grayColor] range:[text rangeOfString:LocalizationKey(dic[@"title"])]];
        [ma yy_setColor:KBlackColor range:[text rangeOfString:LocalizationKey(dic[@"details"])]];
        cell.leftLabel.attributedText = ma;
        
        
        return cell;
    }else{
        static NSString *identifier = @"cell1";
        [self.tableView registerClass:[WTTableStyleValue1Cell class] forCellReuseIdentifier:identifier];
        WTTableStyleValue1Cell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        cell.leftLabel.text = LocalizationKey(self.dataArray[indexPath.row][@"title"]);
        cell.rightLabel.text = self.dataArray[indexPath.row][@"details"];
      
        return cell;
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return self.section1Array.count;
    }
    return self.dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
  
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 1){
        WTBacView *bac = [[WTBacView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 80) backGroundColor:KWhiteColor parentView:nil];
        WTLabel *tip = [[WTLabel alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, OverAllLeft_OR_RightSpace, 100, 20) Text:LocalizationKey(@"RaiseTip18") Font:tFont(16) textColor:KBlackColor parentView:bac];
        
        WTLabel *_allNum = [[WTLabel alloc]  initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, tip.bottom + 10, ScreenWidth - OverAllLeft_OR_RightSpace, 20) Text:@"募集开始时间:2020/05/01 17:00 -- 2020/05/01 20:00" Font:tFont(15) textColor:grayTextColor parentView:nil];
        [bac addSubview:_allNum];
        
        WTBacView *line = [[WTBacView alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, bac.height - 1, SCREEN_WIDTH - 2 * OverAllLeft_OR_RightSpace, 1) backGroundColor:[UIColor whiteColor] parentView:bac];
        line.theme_backgroundColor = THEME_LINE_TABLEVIEW_SEPARATOR_COLOR;
        
        return bac;
    }else{
        return nil;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 1){
        return 80;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    WTBacView *bac = [[WTBacView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10) backGroundColor:KGrayBacColor parentView:nil];
    return bac;
}
 
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}


@end
