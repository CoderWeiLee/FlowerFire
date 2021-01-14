//
//  ChooseCoinTBVC.m
//  FireCoin
//
//  Created by 王涛 on 2019/7/31.
//  Copyright © 2019 王涛. All rights reserved.
//  选择币种

#import "ChooseCoinTBVC.h"
  
#import "RechargeCoinVC.h"
#import "WithdrawCoinTBVC.h"
#import "BMChineseSort.h"
@interface ChooseCoinTBVC ()
{
 
}
@property(nonatomic, strong)NSArray<ChooseCoinListModel *>  *searchArray;
@property(nonatomic, strong)UITableView                     *searchTableView;
@property(nonatomic, strong)UITextField                     *searchField;
@property(nonatomic, assign)ChooseCoinType                   chooseCoinType;
//排序后的出现过的拼音首字母数组
@property(nonatomic,strong)NSMutableArray                   *firstLetterArray;
//排序好的结果数组
@property(nonatomic,strong)NSMutableArray<NSMutableArray *> *sortedModelArr;
@end

@implementation ChooseCoinTBVC

-(instancetype)initWithChooseCoinType:(ChooseCoinType)chooseCoinType{
    self = [super init];
    if(self){
        self.chooseCoinType = chooseCoinType;
    }
    return self;
}

- (instancetype)init
{ 
    return [self initWithChooseCoinType:self.chooseCoinType];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.gk_navigationBar.hidden = YES;
    [self initDataSource];
    [self createTableView];
}

#pragma mark - action
-(void)changedTextField:(UITextField *)textField
{
    if(textField.text.length == 0){
        self.searchTableView.hidden = YES;
    }else{
        self.searchTableView.hidden = NO;
    }
    //  要求取出包含‘币名’的元素  [c]不区分大小写[d]不区分发音符号即没有重音符号[cd]既不区分大小写，也不区分发音符号。
    NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"symbol CONTAINS [cd] %@",textField.text];
    NSMutableArray *modelArray = [NSMutableArray array];
    for (NSArray * array in self.sortedModelArr) {
        for (ChooseCoinListModel * model in array) {
            [modelArray addObject:model];
        }
    }
    self.searchArray = [modelArray filteredArrayUsingPredicate:pred2];
    [self.searchTableView reloadData];
   
}

#pragma mark----CreatMyCustomTablevIew-----
- (void)createTableView
{
    self.view.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
    
    [self.view addSubview:self.searchField];
    [self.view  addSubview:self.tableView];
    [self.view addSubview:self.searchTableView];
    self.tableView.frame = CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight - Height_NavBar );
    self.tableView.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
    if([[SDThemeManager sharedInstance].themeName isEqualToString:WHITE_THEME]){
        self.tableView.sectionIndexColor = MainColor;
    }else{
        self.tableView.sectionIndexColor = KWhiteColor;
    }
    self.tableView.sectionIndexBackgroundColor= self.tableView.backgroundColor;
     
}

- (void)initDataSource
{
    [self.afnetWork jsonPostDict:@"/api/coin/getCoinList" JsonDict:@{@"type":Coin_Account} Tag:@"1"];
}

- (void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    for (NSDictionary *dic in dict[@"data"]) {
        ChooseCoinListModel *model = [ChooseCoinListModel yy_modelWithDictionary:dic];
        [self.dataArray addObject:model];
    }
    BMChineseSortSetting.share.sortMode = 2; // 1或2
    BMChineseSortSetting.share.logEable = NO;
    //排序 Person对象
    @weakify(self);
    [BMChineseSort sortAndGroup:self.dataArray key:@"symbol" finish:^(bool isSuccess, NSMutableArray *unGroupedArr, NSMutableArray *sectionTitleArr, NSMutableArray<NSMutableArray *> *sortedObjArr) {
        if (isSuccess) {
            @strongify(self)
            self.firstLetterArray = sectionTitleArr;
            self.sortedModelArr = sortedObjArr;
            [self.tableView reloadData];
        }
    }];
    
//    array = @[@"BTC", @"BTA",@"BTD",@"BTE",@"BTF",@"ETC", @"USDT", @"AAC",@"ABL",@"CDC",@"CHAT",@"CMT",@"DBC",@"DCR",@"FTR",@"GAS",@"KCASH",@"LBA",@"NCASH",@"NEXO",@"OGO",@"ONT",@"OST",@"PAI",@"PHX",@"PIZZA",@"QASH",@"QUN",@"RTC",@"SALT",@"SBTC",@"STK",@"TNT",@"TOP",@"USDK",@"UUU",@"VEN",@"WAN",@"XEM",@"XMR",@"XMX",@"ZEC",@"ZEN",@"18C",@"19A",];
//    NSArray  *indexArray= [self.dataArray arrayWithPinYinFirstLetterFormat];
//    self.dataArray = [NSMutableArray arrayWithArray:indexArray];
//
}

#pragma mark--- UITableViewDataSource and UITableViewDelegate Methods---
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.isSwitchCoin){ //是已经在提币和充币页面里面了，进行切换币的回调
        if(tableView == self.searchTableView){
            if(self.searchArray[indexPath.row].is_recharge == 1){
                !self.switchCoinBlock ? : self.switchCoinBlock(self.searchArray[indexPath.row]);
            }else{
                [self showBanAlert:YES coinName:self.searchArray[indexPath.row].symbol];
            }
        }else{
            ChooseCoinListModel *model = self.sortedModelArr[indexPath.section][indexPath.row];
            if(model.is_recharge == 1){
                !self.switchCoinBlock ? : self.switchCoinBlock(model);
            }else{
                [self showBanAlert:YES coinName:model.symbol];
            }
        }
        [self closeVC];
    }else{
        switch (self.chooseCoinType) {
            case ChooseCoinTypeDeposit:
            {
                if(tableView == self.searchTableView){
                    if(self.searchArray[indexPath.row].is_recharge == 1){
                        RechargeCoinVC *rvc =[RechargeCoinVC new];
                        rvc.coinListModel = self.searchArray[indexPath.row];
                        [self jumpVC:rvc];
                    }else{
                        [self showBanAlert:YES coinName:self.searchArray[indexPath.row].symbol];
                    }
                }else{
                    ChooseCoinListModel *model = self.sortedModelArr[indexPath.section][indexPath.row];
                    if(model.is_recharge == 1){
                        RechargeCoinVC *rvc =[RechargeCoinVC new];
                        rvc.coinListModel = model;
                        [self jumpVC:rvc];
                    }else{
                        [self showBanAlert:YES coinName:model.symbol];
                    }
                }
            }
                break;
            default:
            {
                if(tableView == self.searchTableView){
                    if(self.searchArray[indexPath.row].is_withdraw == 1){
                        WithdrawCoinTBVC *wvc = [WithdrawCoinTBVC new];
                        wvc.coinListModel = self.searchArray[indexPath.row];
                        [self jumpVC:wvc];
                    }else{
                        [self showBanAlert:NO coinName:self.searchArray[indexPath.row].symbol];
                    }
                }else{
                    ChooseCoinListModel *model = self.sortedModelArr[indexPath.section][indexPath.row];
                    if(model.is_withdraw == 1){
                        WithdrawCoinTBVC *wvc = [WithdrawCoinTBVC new];
                        wvc.coinListModel = model;
                        [self jumpVC:wvc];
                    }else{
                        [self showBanAlert:NO coinName:model.symbol];
                    }
                }
            }
                break;
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView == self.searchTableView){
        return 1;
    }
    return [self.firstLetterArray count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.searchTableView){ 
        return self.searchArray.count;
    }else{
        if(section == 0)
        {
            return 1;
        }else{
            return [self.sortedModelArr[section] count];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.searchTableView){ //搜索结果列表
        NSString *identifier1 = @"cell1";
        [self.searchTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier1];
        UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:identifier1 forIndexPath:indexPath];
        if(self.searchArray.count >0){
            ChooseCoinListModel *model = self.searchArray[indexPath.row];
            cell.textLabel.text = model.symbol;
        }
        [self setCellStyle:cell];
        return cell;
    }else{
        NSString *identifier = @"cell";
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier ];
        UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        if(self.sortedModelArr.count > 0){
            NSMutableArray *array = self.sortedModelArr[indexPath.section];
            ChooseCoinListModel *model = array[indexPath.row];
            cell.textLabel.text = model.symbol;
        }
        [self setCellStyle:cell]; 
        return cell;
    }
}

-(void)setCellStyle:(UITableViewCell *)cell{
    cell.textLabel.font = tFont(15);
    cell.textLabel.theme_textColor = THEME_TEXT_COLOR;
    cell.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
    cell.textLabel.backgroundColor = cell.backgroundColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(tableView == self.searchTableView){
        return 0;
    }else{
        return 40;
    }
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(tableView == self.searchTableView){
        return nil;
    }else{
        //自定义Header标题
        UIView* myView = [[UIView alloc] init];
        myView.theme_backgroundColor = THEME_LINE_TABLEVIEW_HEADER_COLOR;
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = MainBlueColor;
        titleLabel.text= [self.firstLetterArray objectAtIndex:section];
        titleLabel.theme_backgroundColor = THEME_LINE_TABLEVIEW_HEADER_COLOR;
        titleLabel.layer.masksToBounds = YES;
        [myView  addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(OverAllLeft_OR_RightSpace);
            make.centerY.mas_equalTo(myView.mas_centerY);
        }];
        
        return myView;
    }
   
}

#pragma mark---tableView索引相关设置----
//添加索引栏标题数组
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if(tableView == self.searchTableView){
        return nil;
    }else{
        self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
        return self.firstLetterArray;
    }
}


//点击索引栏标题时执行
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if(tableView == self.searchTableView){
        return 0;
    }else{
        //这里是为了指定索引index对应的是哪个section的，默认的话直接返回index就好。其他需要定制的就针对性处理
        if ([title isEqualToString:UITableViewIndexSearch])
        {
            [tableView setContentOffset:CGPointZero animated:NO];//tabview移至顶部
            return NSNotFound;
        }
        else
        {
            return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index] - 1; // -1 添加了搜索标识
        }
    }
}

#pragma mark - privateMethod
//跳转下一个页面前关闭自己页面
-(void)jumpVC:(UIViewController *)vc{
    NSArray *vcs = self.navigationController.viewControllers;
    NSMutableArray *newVCS = [NSMutableArray array];
    if ([vcs count] > 0) {
        for (int i=0; i < [vcs count]-1; i++) {
            [newVCS addObject:[vcs objectAtIndex:i]];
        }
    }
    [newVCS addObject:vc];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController setViewControllers:newVCS animated:YES];
}

/**
 禁止提币充币弹窗

 @param isDeposit 是否时充币
 @param coinName  币名
 */
-(void)showBanAlert:(BOOL)isDeposit coinName:(NSString *)coinName{
    if(isDeposit){
        [[UniversalViewMethod sharedInstance] alertShowMessage:nil WhoShow:self CanNilTitle:[coinName stringByAppendingString:LocalizationKey(@"WithdrawTip7")]];
    }else{
        [[UniversalViewMethod sharedInstance] alertShowMessage:nil WhoShow:self CanNilTitle:[coinName stringByAppendingString:LocalizationKey(@"WithdrawTip8")]];
    }
}

#pragma mark - lazyInit
-(UITextField *)searchField{
    if(!_searchField){
        _searchField = [[UITextField alloc] initWithFrame:CGRectMake(0,Height_StatusBar, ScreenWidth, 40)];
        _searchField.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
    //    _searchField.placeholder = LocalizationKey(@"Search");
        _searchField.theme_textColor = THEME_TEXT_COLOR;
        _searchField.keyboardType = UIKeyboardTypeNamePhonePad;  
    //    [_searchField setValue:THEME_TEXT_PLACEHOLDERCOLOR forKeyPath:@"_placeholderLabel.theme_textColor"];
        _searchField.theme_attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSStringFormat(@"%@",LocalizationKey(@"Search")) attributes:@{ SDThemeForegroundColorAttributeName:THEME_TEXT_PLACEHOLDERCOLOR}];
        [_searchField addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
        
        UIView *leftView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        UIButton *leftView = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftView setImage:[UIImage imageNamed:@"search_symbol_search"] forState:UIControlStateNormal];
        leftView.frame = CGRectMake(0, 0, 40, 40);
        [leftView1 addSubview:leftView];
        _searchField.leftView = leftView1;
        _searchField.leftViewMode = UITextFieldViewModeAlways;
        
        UIView *rightView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
        UIButton *rightView = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightView addTarget:self action:@selector(closeVC) forControlEvents:UIControlEventTouchUpInside];
        [rightView setTitle:LocalizationKey(@"cancel") forState:UIControlStateNormal];
        rightView.titleLabel.font = tFont(15);
        [rightView setTitleColor:ContractDarkBlueColor forState:UIControlStateNormal];
        rightView.frame = CGRectMake(0, 0, 80, 40);
        [rightView1 addSubview:rightView];
        _searchField.rightView = rightView1;
        _searchField.rightViewMode = UITextFieldViewModeAlways;
    }
    return _searchField;
}

-(UITableView *)searchTableView{
    if(!_searchTableView){
        _searchTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight - Height_NavBar) style:UITableViewStylePlain];
        _searchTableView.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        _searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _searchTableView.delegate = self;
        _searchTableView.dataSource = self;
        _searchTableView.hidden = YES;
    }
    return _searchTableView;
}
//common_empty_icon_in_otc_card  LocalizationKey(@"Not records")


@end
