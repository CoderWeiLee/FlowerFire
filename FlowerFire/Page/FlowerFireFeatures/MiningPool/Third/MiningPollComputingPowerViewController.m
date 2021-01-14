//
//  MiningPollComputingPowerViewController.m
//  FlowerFire
//
//  Created by 王涛 on 2020/7/14.
//  Copyright © 2020 Celery. All rights reserved.
//  矿工算力

#import "MiningPollComputingPowerViewController.h"
#import "FFMinerTableViewController.h"
#import "WTTableStyleValue1Cell.h"
#import "MiningPollIncomRecordViewController.h"
#import "FFBuyRecordHidtoryRecordModel.h"
#import "AnnouncementViewController.h"
@interface MiningPollComputingPowerViewController ()
{
    WTLabel *_incomNum;
    MiningPollComputingHeaderView *_headerView;
}
@property(nonatomic, strong)MiningPollDetailModel *model;
@property(nonatomic, strong)NSMutableArray        *sectionTwoArray;
@end

@implementation MiningPollComputingPowerViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.coinName = @"SD";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self createNavBar];
    [self createUI];
    [self initData];
}

- (void)createNavBar{
    self.gk_statusBarStyle = UIStatusBarStyleLightContent;
    self.gk_navBackgroundColor = MainColor;
    self.gk_navTitleColor = KWhiteColor;
    self.gk_backStyle = GKNavigationBarBackStyleWhite;
    self.gk_navigationItem.title = [self.coinName stringByAppendingString:LocalizationKey(@"578Tip62")];
    
    WTButton *incomeButton = [[WTButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40) titleStr:LocalizationKey(@"578Tip167") titleFont:tFont(15) titleColor:KWhiteColor parentView:nil];
    [incomeButton addTarget:self action:@selector(jumpIncomRecordClick) forControlEvents:UIControlEventTouchUpInside];
    incomeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
   // self.gk_navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:incomeButton];
}

-(void)jumpIncomRecordClick{
    MiningPollIncomRecordViewController *mvc = [MiningPollIncomRecordViewController new];
    [self.navigationController pushViewController:mvc animated:YES];
}

- (void)initData{
    [self.afnetWork jsonGetDict:@"/api/bonus/detail" JsonDict:nil Tag:@"1"];
   // [self.afnetWork jsonGetDict:@"/api/bonus/weekRecords" JsonDict:nil Tag:@"2"];
    /*
     "578Tip689" = "Effective amount";
     "578Tip6899" = "Queuing amount";
     "578Tip68999" = "Balance pool coefficient";
     "578Tip689999" = "Balance pool completion coefficient";
     */
    self.dataArray = @[@{@"title":LocalizationKey(@"578Tip66"),@"details":@"0"},
                       @{@"title":LocalizationKey(@"578Tip67"),@"details":@"0"},
                    //   @{@"title":LocalizationKey(@"578Tip68"),@"details":@"0"},
                       @{@"title":LocalizationKey(@"578Tip689"),@"details":@"0"},
                       @{@"title":LocalizationKey(@"578Tip6899"),@"details":@"0"},
                       @{@"title":LocalizationKey(@"578Tip68999"),@"details":@"0"},
                       @{@"title":LocalizationKey(@"578Tip689999"),@"details":@"0"},
                       @{@"title":LocalizationKey(@"578Tip69")}].copy;
}

- (void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    if([type isEqualToString:@"1"]){
        self.model = [MiningPollDetailModel yy_modelWithDictionary:dict[@"data"]];
        
        /*
         @{@"title":LocalizationKey(@"578Tip689"),@"details":@"0"},
         @{@"title":LocalizationKey(@"578Tip6899"),@"details":@"0"},
         @{@"title":LocalizationKey(@"578Tip68999"),@"details":@"0"},
         @{@"title":LocalizationKey(@"578Tip689999"),@"details":@"0"},
         */
        NSString *details1 = @"0SD";
        NSString *details2 = @"0SD";
        NSString *details3 = @"0SD";
        
        NSString *details4 = @"0SD";
        NSString *details5 = @"0SD";
        NSString *details6 = @"0SD";
        NSString *details7 = @"0SD";
        
        if(self.model){
            [_headerView setHeaderData:self.model];
            details1 = [self.model.best_power stringByAppendingString:@"SD"];
            details2 = [self.model.lowest_power stringByAppendingString:@"SD"];
            details3 = [self.model.total_coins stringByAppendingString:@"SD"];
            
            details4 = [self.model.locking_money stringByAppendingString:@"SD"];
            details5 = [self.model.lock_money stringByAppendingString:@"SD"];
            details6 = [self.model.today_total stringByAppendingString:@""];
            details7 = [self.model.lock_total stringByAppendingString:@""];
            
        }
        if([HelpManager isBlankString:details1]){
            details1 = @"0SD";
        }
        if([HelpManager isBlankString:details2]){
            details2 = @"0SD";
        }
        if([HelpManager isBlankString:details3]){
            details3 = @"0SD";
        }
        /*
         "578Tip689" = "生效金额";
         "578Tip6899" = "排队金额";
         "578Tip68999" = "平衡池系数";
         "578Tip689999" = "平衡池完成系数";
         */
        self.dataArray = @[@{@"title":LocalizationKey(@"578Tip66"),@"details":details1},
                           @{@"title":LocalizationKey(@"578Tip67"),@"details":details2},
                         //  @{@"title":LocalizationKey(@"578Tip68"),@"details":details3},
                           @{@"title":LocalizationKey(@"578Tip689"),@"details":[NSString stringWithFormat:@"%@",details4]},
                           @{@"title":LocalizationKey(@"578Tip6899"),@"details":[NSString stringWithFormat:@"%@",details5]},
                           @{@"title":LocalizationKey(@"578Tip68999"),@"details":[NSString stringWithFormat:@"%@",details6]},
                           @{@"title":LocalizationKey(@"578Tip689999"),@"details":[NSString stringWithFormat:@"%@",details7]},
                           
                           
                           @{@"title":LocalizationKey(@"578Tip69")}].copy;
        [self.tableView reloadData];
    }else{
        self.sectionTwoArray = [NSMutableArray array];
        for (NSDictionary *dic in dict[@"data"]) {
            FFBuyRecordHidtoryRecordModel *model = [FFBuyRecordHidtoryRecordModel yy_modelWithDictionary:dic];
            [self.sectionTwoArray addObject:model];
        } 
         
        [self.tableView reloadData];
    }
    
}

- (void)createUI{
    self.tableView.bounces = NO;
    self.tableView.frame = CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight - Height_NavBar);
    [self.view addSubview:self.tableView];
    self.view.backgroundColor = KWhiteColor;
    self.tableView.backgroundColor = self.view.backgroundColor;
    
    _headerView = [[MiningPollComputingHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 170) coinName:self.coinName];
    self.tableView.tableHeaderView = _headerView;
  
}

#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        if (indexPath.row == 0) {
            //超链接到公告
            AnnouncementViewController *avc =[AnnouncementViewController new];
            avc.dataArray = self.dataSource;
            [self.navigationController pushViewController:avc animated:YES];
        }
        if(indexPath.row == 6){
            FFMinerTableViewController *fvc = [FFMinerTableViewController new];
            [self.navigationController pushViewController:fvc animated:YES];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            static NSString *identifier = @"cell";
            [self.tableView registerClass:[WTTableStyleValue1Cell class] forCellReuseIdentifier:identifier];
            WTTableStyleValue1Cell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            cell.leftLabel.text = self.dataArray[indexPath.row][@"title"];
            cell.rightLabel.text =  self.dataArray[indexPath.row][@"details"];
            if(indexPath.row == 6){
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }else{
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            return cell;
        }
            break;
        default:
        {
            static NSString *identifier = @"cell2";
            [self.tableView registerClass:[WTTableStyleValue1Cell class] forCellReuseIdentifier:identifier];
            WTTableStyleValue1Cell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            if(self.sectionTwoArray.count>0){
                FFBuyRecordHidtoryRecordModel *model = self.sectionTwoArray[indexPath.row];
                cell.leftLabel.text = model.createtime;
                cell.rightLabel.text = NSStringFormat(@"%@SD",model.money);
            } 
            return cell;
        }
            break;
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return self.dataArray.count;
        default:
            return self.sectionTwoArray.count;
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    WTBacView *bacView = [[WTBacView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 80) backGroundColor:KWhiteColor parentView:nil];
    WTLabel *_incomeTip = [[WTLabel alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, OverAllLeft_OR_RightSpace, 150, 25) Text:LocalizationKey(@"578Tip70") Font:[UIFont boldSystemFontOfSize:18] textColor:KBlackColor parentView:bacView];
    
    _incomNum = [[WTLabel alloc] initWithFrame:CGRectMake(_incomeTip.left, _incomeTip.bottom + 10, SCREEN_WIDTH - OverAllLeft_OR_RightSpace, 20) Text:LocalizationKey(@"578Tip168") Font:tFont(15) textColor:grayTextColor parentView:bacView];
      
    WTButton *rightButton = [[WTButton alloc] initWithFrame:CGRectMake(ScreenWidth - 100 - OverAllLeft_OR_RightSpace, _incomNum.centerY - 20, 100, 40) titleStr:LocalizationKey(@"578Tip169") titleFont:tFont(15) titleColor:grayTextColor parentView:bacView];
    rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    return bacView;
}
 
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 0;
        default:
            return 80;
    }
}
 

@end

@interface MiningPollComputingHeaderView ()
{
    WTLabel *_tip1;
    WTLabel *_sumNum;
    WTBacView *_topBac,*_bottomBac,*_centBac,*_lineView;
    WTLabel *_leftNum,*_rightNum;
}
@property(nonatomic,strong)NSString *coinName;

@end

@implementation MiningPollComputingHeaderView

- (instancetype)initWithFrame:(CGRect)frame coinName:(nonnull NSString *)coinName
{
    self = [super initWithFrame:frame];
    if (self) {
        self.coinName = coinName;
        
        [self createUI];
        [self layoutSubview];
    }
    return self;
}

- (void)createUI{
    _topBac = [[WTBacView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 130) backGroundColor:MainColor parentView:self];
    
    _centBac = [[WTBacView alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, self.height - 80 - 10, SCREEN_WIDTH - 2 * OverAllLeft_OR_RightSpace, 80) backGroundColor:KWhiteColor parentView:self];
    _centBac.layer.cornerRadius = 5;
    
    _tip1 = [[WTLabel alloc] initWithFrame:CGRectMake(0, _topBac.top + 15, ScreenWidth, 20) Text:[LocalizationKey(@"578Tip62") stringByAppendingFormat:@"(%@)",self.coinName] Font:tFont(13) textColor:KWhiteColor parentView:self];
    _tip1.textAlignment = NSTextAlignmentCenter;
    
    _sumNum = [[WTLabel alloc] initWithFrame:CGRectMake(0, _tip1.bottom + 5, ScreenWidth, 25) Text:@"13122842.4554" Font:[UIFont boldSystemFontOfSize:18] textColor:KWhiteColor parentView:self];
    _sumNum.textAlignment = NSTextAlignmentCenter;
    
    _leftNum = [[WTLabel alloc] initWithFrame:CGRectMake(0, 0, _centBac.width/2, _centBac.height-0) Text:NSStringFormat(@"\n%@",LocalizationKey(@"578Tip62")) Font:tFont(15) textColor:KBlackColor parentView:_centBac];
    _leftNum.numberOfLines = 0;
    
    _lineView = [[WTBacView alloc] initWithFrame:CGRectMake(_centBac.centerX-0.5, _centBac.centerY - 10, 1, 20) backGroundColor:FlowerFirexianColor parentView:self];
    
    _rightNum = [[WTLabel alloc] initWithFrame:CGRectMake(_lineView.right, 0, _centBac.width/2, _centBac.height-0) Text:NSStringFormat(@"\n%@",LocalizationKey(@"578Tip63")) Font:tFont(15) textColor:KBlackColor parentView:_centBac];
    _rightNum.numberOfLines = 0;
    _rightNum.textAlignment = NSTextAlignmentCenter;
    
    
    _bottomBac = [[WTBacView alloc] initWithFrame:CGRectMake(0, self.height - 70, ScreenWidth, 70) backGroundColor:KGrayBacColor parentView:self];
    
    [self insertSubview:_bottomBac belowSubview:_centBac];
    
   
    NSMutableAttributedString *ma = [[NSMutableAttributedString alloc] initWithString: NSStringFormat(@"0\n%@",LocalizationKey(@"578Tip112"))];
    [ma yy_setColor:KBlackColor range:[[ma string]rangeOfString:@"0"]];
    [ma yy_setFont:tFont(15) range:[[ma string]rangeOfString:@"0"]];
    [ma yy_setColor:grayTextColor range:[[ma string]rangeOfString:LocalizationKey(@"578Tip112")]];
    _leftNum.attributedText = ma;
    
    NSMutableAttributedString *ma2 = [[NSMutableAttributedString alloc] initWithString:NSStringFormat(@"0\n%@",LocalizationKey(@"578Tip113"))];
    [ma2 yy_setColor:KBlackColor range:[[ma2 string]rangeOfString:@"0"]];
    [ma2 yy_setFont:tFont(15) range:[[ma2 string]rangeOfString:@"0"]];
    [ma2 yy_setColor:grayTextColor range:[[ma2 string]rangeOfString:LocalizationKey(@"578Tip113")]];
    _rightNum.attributedText = ma2;
    
    _leftNum.textAlignment = NSTextAlignmentCenter;
    _rightNum.textAlignment = NSTextAlignmentCenter;
}

- (void)layoutSubview{
    
}

- (void)setHeaderData:(MiningPollDetailModel *)model{
    _sumNum.text = model.day_coins;
    
    NSMutableAttributedString *ma = [[NSMutableAttributedString alloc] initWithString: NSStringFormat(@"%@\n%@",model.hold_rank,LocalizationKey(@"578Tip112"))];
    [ma yy_setColor:KBlackColor range:[[ma string]rangeOfString:model.hold_rank]];
    [ma yy_setFont:tFont(15) range:[[ma string]rangeOfString:model.hold_rank]];
    [ma yy_setColor:grayTextColor range:[[ma string]rangeOfString:LocalizationKey(@"578Tip112")]];
    _leftNum.attributedText = ma;
    
    NSMutableAttributedString *ma2 = [[NSMutableAttributedString alloc] initWithString:NSStringFormat(@"%@\n%@",model.recommend_power,LocalizationKey(@"578Tip113"))];
    [ma2 yy_setColor:KBlackColor range:[[ma2 string]rangeOfString:model.recommend_power]];
    [ma2 yy_setFont:tFont(15) range:[[ma2 string]rangeOfString:model.recommend_power]];
    [ma2 yy_setColor:grayTextColor range:[[ma2 string]rangeOfString:LocalizationKey(@"578Tip113")]];
    _rightNum.attributedText = ma2;
    
    _leftNum.textAlignment = NSTextAlignmentCenter;
    _rightNum.textAlignment = NSTextAlignmentCenter;
}

@end
