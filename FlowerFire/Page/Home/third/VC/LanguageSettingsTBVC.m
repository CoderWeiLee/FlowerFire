//
//  LanguageSettingsTBVC.m
//  FireCoin
//
//  Created by 王涛 on 2019/7/27.
//  Copyright © 2019 王涛. All rights reserved.
//  语言设置

#import "LanguageSettingsTBVC.h"
#import "WTMainRootViewController.h"

@interface LanguageSettingsTBVC ()
{
}
@property(nonatomic, strong) NSArray *dataArray;

@end

@implementation LanguageSettingsTBVC

@synthesize dataArray = _dataArray;

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavBar];
    [self setUpView];
    [self initData];
    
}

- (void)createNavBar{
    self.gk_navigationItem.title = LocalizationKey(@"settingTip5");
}

#pragma mark - dataSource
-(void)initData{
    NSString *details;
    if ([[ChangeLanguage userLanguage] isEqualToString:@"en"]) {
        details = @"English";
    }else if ([[ChangeLanguage userLanguage] isEqualToString:@"zh-Hans"])
    {
        details = @"简体中文";
    }
//    else if ([[ChangeLanguage userLanguage] isEqualToString:@"zh-Hant"])
//    {
//        details = @"繁體中文";
//    }
    self.dataArray = @[@{@"title":@"English",@"details":details},
                       @{@"title":@"简体中文",@"details":details},
                       ];
    [self.tableView reloadData];
}

#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        [ChangeLanguage setUserlanguage:@"en"];
    }else  if(indexPath.row == 1){
        [ChangeLanguage setUserlanguage:@"zh-Hans"];
    }else{
        [ChangeLanguage setUserlanguage:@"zh-Hant"];
    }
    [self initData];
     
//    WTMainRootViewController *tabBarController = (WTMainRootViewController*)[UIApplication sharedApplication].delegate.window.rootViewController;
//    [tabBarController createNewTabBarWithContext:nil];
//    
    WTMainRootViewController *view=[[WTMainRootViewController alloc]init];
    UIWindow * window = [UIApplication sharedApplication].delegate.window;
    window.rootViewController = view;
    [window makeKeyAndVisible];
     
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.dataArray[indexPath.row][@"title"];
    cell.textLabel.font = tFont(15);
    cell.textLabel.theme_textColor = THEME_TEXT_COLOR;
    cell.textLabel.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
    cell.textLabel.layer.masksToBounds = YES;
    cell.tintColor = MainColor;
    if([self.dataArray[indexPath.row][@"details"] isEqualToString:self.dataArray[indexPath.row][@"title"]]){
         cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
   
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

#pragma mark - ui
-(void)setUpView{
    self.tableView.tableFooterView = [UIView new];
    self.tableView.bounces = NO;
    self.view.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
    self.tableView.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.theme_separatorColor = THEME_LINE_INPUTBORDERCOLOR;
    
}



@end
