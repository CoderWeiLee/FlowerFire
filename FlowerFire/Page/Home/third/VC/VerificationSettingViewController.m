//
//  VerificationSettingViewController.m
//  FlowerFire
//
//  Created by 王涛 on 2020/5/13.
//  Copyright © 2020 Celery. All rights reserved.
//。验证设置

#import "VerificationSettingViewController.h"
#import "WTTableStyleValue1Cell.h"

@interface VerificationSettingViewController ()

@property(nonatomic, strong)NSMutableArray *selectedArray;
@end

@implementation VerificationSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavBar];
    [self initData];
    [self createUI];
}

-(void)submitClick{
    [self closeVC];
}

- (void)createNavBar{
    switch (self.verificationSettingType) {
        case VerificationSettingTypeTransaction:
            self.gk_navigationItem.title = LocalizationKey(@"VerificationSettingTip1");
            break;
        case VerificationSettingTypePay:
            self.gk_navigationItem.title = LocalizationKey(@"VerificationSettingTip2");
            break;
        default:
            self.gk_navigationItem.title = LocalizationKey(@"VerificationSettingTip3");
            break;
    }
}

- (void)createUI{
    self.tableView.frame = CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight - Height_NavBar);
    self.tableView.bounces = NO;
    [self.view addSubview:self.tableView];
    
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.titleLabel.font = tFont(15);
    submitButton.backgroundColor = MainColor;
    submitButton.layer.cornerRadius = 5;
    [submitButton setTitle:LocalizationKey(@"VerificationSettingTip7") forState:UIControlStateNormal];
    [self.view addSubview:submitButton];
    submitButton.frame = CGRectMake(OverAllLeft_OR_RightSpace, ScreenHeight - SafeAreaBottomHeight - 10 - 50, ScreenWidth - 2 * OverAllLeft_OR_RightSpace, 50);
    [submitButton addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initData{
    self.selectedArray = [NSMutableArray array];
    switch (self.verificationSettingType) {
        case VerificationSettingTypeTransaction:
        {
            self.dataArray = @[LocalizationKey(@"VerificationSettingTip4")].copy;
            [self.selectedArray addObject:LocalizationKey(@"VerificationSettingTip4")];
        }
            break;
        case VerificationSettingTypePay:
        {
            self.dataArray = @[LocalizationKey(@"VerificationSettingTip5")].copy;
            [self.selectedArray addObject:LocalizationKey(@"VerificationSettingTip5")];
        }
            break;
        default:
        {
            self.dataArray = @[LocalizationKey(@"VerificationSettingTip6")].copy;
            [self.selectedArray addObject:LocalizationKey(@"VerificationSettingTip6")];
        }
            break;
    }
}

#pragma mark - tableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    [self.tableView registerClass:[WTTableStyleValue1Cell class] forCellReuseIdentifier:identifier];
    WTTableStyleValue1Cell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.leftLabel.text = self.dataArray[indexPath.row];
    cell.leftLabel.font = tFont(15);
    cell.leftLabel.textColor = KBlackColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.tintColor = MainColor;
    if([self.selectedArray containsObject:cell.leftLabel.text]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedArray = [NSMutableArray array];
    [self.selectedArray addObject:self.dataArray[indexPath.row]];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

@end
