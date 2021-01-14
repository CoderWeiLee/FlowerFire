//
//  FFMinerTableViewController.m
//  FlowerFire
//
//  Created by 王涛 on 2020/8/25.
//  Copyright © 2020 Celery. All rights reserved.
//  矿工列表

#import "FFMinerTableViewController.h"
#import "WTTableStyleValue1Cell.h"
#import "FFMinerHeaderModel.h"
#import "FFMinerListModel.h"

@interface FFMinerTableViewController ()
{
    WTLabel *_la1,*_la2,*_la3,*_la4,*_la5;
    UIView  *_bacView;
}
@end

@implementation FFMinerTableViewController

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
    self.gk_navigationItem.title = LocalizationKey(@"578Tip71");
}

- (void)createUI{
    _bacView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 120)];
    _bacView.backgroundColor = MainColor;
    self.tableView.frame = CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight - Height_NavBar);
    self.tableView.tableHeaderView = _bacView;
    [self.view addSubview:self.tableView];
      
}

- (void)initData{
    //头部接口
    [self.afnetWork jsonPostDict:@"/api/user/downCount" JsonDict:nil Tag:@"1"];
    
    //activation_status    string    是    是否激活状态，1为激活，0为未激活，all为所有，默认为all
    NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:1];
    md[@"activation_status"] = @"all";
    [self.afnetWork jsonPostDict:@"/api/user/downUsers" JsonDict:md Tag:@"2"];
}

- (void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    switch ([type integerValue]) {
        case 1:
        {
//            FFMinerHeaderModel *model = [FFMinerHeaderModel yy_modelWithDictionary:dict[@"data"]];
//            CGFloat singleWidth = (SCREEN_WIDTH-2*OverAllLeft_OR_RightSpace)/5;
//            
//            _la1 = [self createLabel:CGRectMake(OverAllLeft_OR_RightSpace, _bacView.height/2 - 20, singleWidth, 40) topStr:LocalizationKey(@"578Tip72") bottomStr:model.day_user_count parentView:_bacView];
//            
//            _la2 = [self createLabel:CGRectMake(_la1.right, _bacView.height/2 - 20, singleWidth, 40) topStr:LocalizationKey(@"578Tip73") bottomStr:model.day_equipment_count parentView:_bacView];
//            
//            _la3 = [self createLabel:CGRectMake(_la2.right, _bacView.height/2 - 20, singleWidth, 40) topStr:LocalizationKey(@"578Tip74") bottomStr:model.all_user_count parentView:_bacView];
//            
//            _la4 = [self createLabel:CGRectMake(_la3.right, _bacView.height/2 - 20, singleWidth, 40) topStr:LocalizationKey(@"578Tip75") bottomStr:model.all_equipment_count parentView:_bacView];
//            
//            _la5 = [self createLabel:CGRectMake(_la4.right, _bacView.height/2 - 20, singleWidth, 40) topStr:LocalizationKey(@"578Tip76") bottomStr:model.effective_equipment_count parentView:_bacView];
//            

        }
            break;
        default:
        {
            for (NSDictionary *dic in dict[@"data"][@"list"]) {
                [self.dataArray addObject:[FFMinerListModel yy_modelWithDictionary:dic]];
            }
            [self.tableView reloadData];
        }
            break;
    }
}

#pragma mark - tableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    [self.tableView registerClass:[WTTableStyleValue1Cell class] forCellReuseIdentifier:identifier];
    WTTableStyleValue1Cell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if(self.dataArray.count>0){
        FFMinerListModel *model = self.dataArray[indexPath.row];
        cell.leftLabel.text = model.username;
        cell.rightLabel.text = model.team_money;
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    WTBacView *bacView = [[WTBacView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 80) backGroundColor:KWhiteColor parentView:nil];
    WTLabel *_incomeTip = [[WTLabel alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, OverAllLeft_OR_RightSpace, 150, 25) Text:LocalizationKey(@"578Tip77") Font:[UIFont boldSystemFontOfSize:18] textColor:KBlackColor parentView:bacView];
    
    WTLabel *tip = [[WTLabel alloc] initWithFrame:CGRectMake(_incomeTip.left, _incomeTip.bottom + 10, SCREEN_WIDTH - OverAllLeft_OR_RightSpace, 20) Text:LocalizationKey(@"578Tip78") Font:tFont(13) textColor:grayTextColor parentView:bacView];
    
    WTLabel *ti2 = [[WTLabel alloc] initWithFrame:CGRectZero Text:LocalizationKey(@"578Tip79") Font:tFont(13) textColor:grayTextColor parentView:bacView];
    [ti2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(tip.mas_centerY);
        make.right.mas_equalTo(bacView.mas_right).offset(-OverAllLeft_OR_RightSpace);
    }];
     
    return bacView;
}
 
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 80;
}
 
#pragma mark - privateMethod
-(WTLabel *)createLabel:(CGRect)frame topStr:(NSString *)topStr bottomStr:(NSString *)bottomStr parentView:(UIView *)parentView{
    WTLabel *la = [[WTLabel alloc] initWithFrame:frame Text:NSStringFormat(@"%@\n%@",topStr,bottomStr) Font:tFont(10) textColor:KWhiteColor parentView:parentView];
    
    NSMutableAttributedString *ma = [[NSMutableAttributedString alloc] initWithString:la.text];
    [ma yy_setFont:tFont(10) range:[la.text rangeOfString:topStr]];
    [ma yy_setFont:[UIFont boldSystemFontOfSize:13] range:[la.text rangeOfString:bottomStr]];
    [ma setYy_lineSpacing:5];
    [ma setYy_color:KWhiteColor];
    la.attributedText = ma;
    la.textAlignment = NSTextAlignmentCenter;
    la.numberOfLines = 2;
    return la;
}
 

@end
