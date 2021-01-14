//
//  AboutUsViewController.m
//  FlowerFire
//
//  Created by 王涛 on 2020/5/13.
//  Copyright © 2020 Celery. All rights reserved.
//  关于我们

#import "AboutUsViewController.h"
#import "WTTableStyleValue1Cell.h"
#import "WTTableStyleValue2Cell.h"
#import "LanguageSettingsTBVC.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavBar];
    [self createUI];
    [self initData];
}

- (void)createNavBar{
    self.gk_navigationBar.hidden = NO;
    self.gk_navigationItem.title = LocalizationKey(@"aboutUsTip1");
}

- (void)createUI{
    self.tableView.bounces = NO;
    self.tableView.frame = CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight - Height_NavBar);
    [self.view addSubview:self.tableView];
}

- (void)initData{
    self.dataArray = @[@[@{@"title":LocalizationKey(@"578Tip51"),@"details":@"http:",},
                         @{@"title":LocalizationKey(@"578Tip52"),@"details":@"http:",},
                         @{@"title":LocalizationKey(@"578Tip53"),@"details":@"http:",},],
                       @[@{@"title":LocalizationKey(@"settingTip1"),},
                         @{@"title":LocalizationKey(@"aboutUsTip3"),@"details":CurrentAppVersion}]].copy;
    
    [self.afnetWork jsonGetDict:@"/api/article/aboutUs" JsonDict:nil Tag:@"1"];
}

- (void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    if(dict[@"data"]){
        NSString *details;
        if ([[ChangeLanguage userLanguage] isEqualToString:@"en"]) {
            details = @"English";
        }else if ([[ChangeLanguage userLanguage] isEqualToString:@"zh-Hans"])
        {
            details = @"简体中文";
        }
//        else if ([[ChangeLanguage userLanguage] isEqualToString:@"zh-Hant"])
//        {
//            details = @"繁體中文";
//        }
        
        self.dataArray = @[@[@{@"title":LocalizationKey(@"578Tip51"),@"details":dict[@"data"][@"block_url"],},
                             @{@"title":LocalizationKey(@"578Tip52"),@"details":dict[@"data"][@"open_source_url"],},
                             @{@"title":LocalizationKey(@"578Tip53"),@"details":dict[@"data"][@"developers_url"],},],
         
                           @[@{@"title":LocalizationKey(@"settingTip1"),@"details":details},
            @{@"title":LocalizationKey(@"aboutUsTip3"),@"details":CurrentAppVersion}]].copy;
        [self.tableView reloadData];
    }
}

#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 1){
        if(indexPath.row == 0){
            LanguageSettingsTBVC *lbc = [LanguageSettingsTBVC new];
            [self.navigationController pushViewController:lbc animated:YES];
        }
    }else{
        NSString *details = self.dataArray[indexPath.section][indexPath.row][@"details"];
        if([HelpManager isBlankString:details]){
            printAlert(LocalizationKey(@"578Tip144"), 1.f);
        }else{
            [[WTPageRouterManager sharedInstance] jumpToWebView:self.navigationController urlString:details];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            static NSString *identifier = @"cell1";
            [self.tableView registerClass:[WTTableStyleValue2Cell class] forCellReuseIdentifier:identifier];
            WTTableStyleValue2Cell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            cell.topLabel.text = self.dataArray[indexPath.section][indexPath.row][@"title"];
            cell.bottomLabel.text = self.dataArray[indexPath.section][indexPath.row][@"details"];
            cell.topLabel.font = tFont(15);
            cell.bottomLabel.font = tFont(15);
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }
            break;
        default:
        {
            static NSString *identifier = @"cell";
            [self.tableView registerClass:[WTTableStyleValue1Cell class] forCellReuseIdentifier:identifier];
            WTTableStyleValue1Cell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            cell.rightLabel.text = self.dataArray[indexPath.section][indexPath.row][@"details"];
            cell.leftLabel.text = self.dataArray[indexPath.section][indexPath.row][@"title"];
            cell.leftLabel.font = tFont(15);
            cell.rightLabel.font = tFont(15);
            
            return cell;
        }
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = self.dataArray[section];
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            return 70;
        default:
            return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 10;
        default:
            return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    footerView.backgroundColor = FlowerFirexianColor;
    return footerView;
}

@end
