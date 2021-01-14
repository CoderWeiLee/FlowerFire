//
//  SettingViewController.m
//  531Mall
//
//  Created by 王涛 on 2020/5/22.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "SettingViewController.h"
#import "UIImage+jianbianImage.h"
#import "WTTableStyleValue1Cell.h"

@interface SettingViewController ()
{
    BOOL _hasNewVersion; //有新版本
}
/// 客服手机号
@property(nonatomic, strong)NSString     *customerPhoneNumber;
/// appStore下载地址
@property(nonatomic, strong)NSString     *AppStoreDownloadAddress;
@property(nonatomic, strong)UIImageView  *accImage;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self createNavBar];
    [self createUI];
    [self initData];
}

- (void)createNavBar{
    self.gk_statusBarStyle = UIStatusBarStyleDefault;
    self.gk_navBackgroundColor = rgba(250, 250, 250, 1);
    self.gk_navigationItem.title = @"设置";
}
 
- (void)createUI{
    self.view.backgroundColor = KWhiteColor;
    self.tableView.backgroundColor = KWhiteColor;
    self.tableView.bounces = NO;
    self.tableView.frame = CGRectMake(0, Height_NavBar, ScreenWidth,  20 +  50 * 3);
    [self.view addSubview:self.tableView];
    
    UIButton *addAddressButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addAddressButton.titleLabel setFont:tFont(15)];
    [addAddressButton setTitle:@"退出当前账号" forState:UIControlStateNormal];
    addAddressButton.frame = CGRectMake(OverAllLeft_OR_RightSpace, self.tableView.ly_maxY + 45, ScreenWidth - 2 * OverAllLeft_OR_RightSpace, 45);
    [addAddressButton setBackgroundImage:[UIImage gradientColorImageFromColors:MaingradientColor gradientType:GradientTypeLeftToRight imgSize:addAddressButton.size] forState:UIControlStateNormal];
    [self.view addSubview:addAddressButton];
    addAddressButton.layer.shadowOffset = CGSizeMake(0,2);
    addAddressButton.layer.shadowOpacity = 1;
    addAddressButton.layer.shadowRadius = 4;
    addAddressButton.layer.cornerRadius = 5;
    addAddressButton.layer.masksToBounds = YES;
    [addAddressButton addTarget:self action:@selector(exitLoginClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initData{
    NSString *versionStr = [UIApplication sharedApplication].appVersion;
    self.dataArray = @[@{@"title":@"当前版本",@"details":versionStr},
                         @{@"title":@"检查更新",@"details":@"去AppStore"},
                         @{@"title":@"联系客服",@"details":@"",@"accView":@"jiantou"},
                      ].copy;
    
    [self.afnetWork jsonMallPostDict:@"/api/login/system_info" JsonDict:nil Tag:@"1"];
    [self.afnetWork jsonMallPostDict:@"/api/login/getversion" JsonDict:nil Tag:@"2"];

    
}

#pragma mark - action
-(void)exitLoginClick{
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    md[@"userid"] = [WTMallUserInfo shareUserInfo].ID;
    [self.afnetWork jsonMallPostDict:@"/api/login/logout" JsonDict:md Tag:@"3"];
}

#pragma mark -netData
- (void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    [self.tableView.mj_header endRefreshing];
    if([type isEqualToString:@"1"]){
        self.customerPhoneNumber = NSStringFormat(@"%@",dict[@"data"][@"tels"]);
    }else if([type isEqualToString:@"2"]){
        self.AppStoreDownloadAddress = NSStringFormat(@"%@",dict[@"data"][@"iphone"]);
        NSString *newVersion = NSStringFormat(@"%@",dict[@"data"][@"ios_version"]);
        
        NSString *currentVersion = [UIApplication sharedApplication].appVersion;//当前用户版本
        BOOL result = [currentVersion compare:newVersion] == NSOrderedAscending;
        if (result) {
            _hasNewVersion = YES;
        } else {//已经是最新版；
            self.dataArray = @[@{@"title":@"当前版本",@"details":currentVersion},
                                 @{@"title":@"检查更新",@"details":@"已是最新版"},
                                 @{@"title":@"联系客服",@"details":@"",@"accView":@"jiantou"},
                              ].copy;
            [self.tableView reloadData];
        }
    }else{ //退出登录
        printAlert(dict[@"msg"], 1.f);
        [WTMallUserInfo logout];
        [[WTPageRouterManager sharedInstance] jumpMallTabBarController:0];

        [self jumpLogin];
     
    }
    
}

//@"itms-apps://itunes.apple.com/cn/app/id1329918420?mt=8";
-(void)creatAlterView:(NSString *)appStoreUrlStr{
    UIAlertController *alertText = [UIAlertController alertControllerWithTitle:@"更新提醒" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertText addAction:[UIAlertAction actionWithTitle:@"我再想想" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }]];
    [alertText addAction:[UIAlertAction actionWithTitle:@"立即更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appStoreUrlStr] options:@{} completionHandler:nil];
    }]];
    [self.navigationController presentViewController:alertText animated:YES completion:nil];
}
   
#pragma mark - tableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    [self.tableView registerClass:[WTTableStyleValue1Cell class] forCellReuseIdentifier:identifier];
    WTTableStyleValue1Cell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
   
    if([self.dataArray[indexPath.row][@"accView"] isEqualToString:@"jiantou"]){
        cell.accessoryView = [self accImage];
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.leftLabel.text = self.dataArray[indexPath.row][@"title"];
    cell.rightLabel.text = self.dataArray[indexPath.row][@"details"];
    cell.leftLabel.font = tFont(13);
    cell.rightLabel.font = tFont(13);
    [cell.leftLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(cell.mas_left).offset(12.5+OverAllLeft_OR_RightSpace);
    }];
    [cell.rightLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(cell.mas_right).offset(-10.5-OverAllLeft_OR_RightSpace);
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 1:
        {
            if(_hasNewVersion){
                if([HelpManager isBlankString:self.AppStoreDownloadAddress]){
                    printAlert(@"获取Appstore下载地址失败,请返回重试", 1.f);
                    return;
                }//@"https://itunes.apple.com/cn/app/apple-store/id ItunesAppleID
                //需要更新
                [self creatAlterView:self.AppStoreDownloadAddress];
            }else{
                printAlertInView(@"已是最新版本", 1.f, self.view);
            } 
        }
            break;
        case 2: //客服
        {
            if([HelpManager isBlankString:self.customerPhoneNumber]){
                printAlert(@"未设置客服电话,请返回重试", 1.f);
                return;
            }
            NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",self.customerPhoneNumber];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:nil];
            break;
        }
        default:
            break;
    }
}
 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{ 
    return  self.dataArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
    v.backgroundColor = self.view.backgroundColor;
    return v;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // 圆角角度
    CGFloat radius = 5;
    // 设置cell 背景色为透明
    cell.backgroundColor = UIColor.clearColor;
    // 创建两个layer
    CAShapeLayer *normalLayer = [[CAShapeLayer alloc] init];
    CAShapeLayer *selectLayer = [[CAShapeLayer alloc] init];
    // 获取显示区域大小
    CGRect bounds = CGRectInset(cell.bounds, 15, 0);
    // cell的backgroundView
    UIView *normalBgView = [[UIView alloc] initWithFrame:bounds];
    // 获取每组行数
    NSInteger rowNum = [tableView numberOfRowsInSection:indexPath.section];
    // 贝塞尔曲线
    UIBezierPath *bezierPath = nil;
    
    if (rowNum == 1) {
        // 一组只有一行（四个角全部为圆角）
        bezierPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, radius)];
        normalBgView.clipsToBounds = NO;
    }else { 
        if (indexPath.row == 0) {
            normalBgView.frame = UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(-5, 0, 0, 0));
            CGRect rect = UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(5, 0, 0, 0));
            // 每组第一行（添加左上和右上的圆角）
            bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight) cornerRadii:CGSizeMake(radius, radius)];
            normalBgView.clipsToBounds = YES;
        }else if (indexPath.row == rowNum - 1) {
            normalBgView.frame = UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(0, 0, -5, 0));
            CGRect rect = UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(0, 0, 5, 0));
            // 每组最后一行（添加左下和右下的圆角）
            bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight) cornerRadii:CGSizeMake(radius, radius)];
            normalBgView.clipsToBounds = NO;
        }else {
            // 每组不是首位的行不设置圆角
            bezierPath = [UIBezierPath bezierPathWithRect:bounds];
            normalBgView.clipsToBounds = YES;
            
        }
    }
    
    // 阴影
    normalLayer.shadowColor = [UIColor colorWithRed:153/255.0 green:174/255.0 blue:223/255.0 alpha:0.2].CGColor;
    normalLayer.shadowOffset = CGSizeMake(0,5);
    normalLayer.shadowOpacity = 1;
    normalLayer.shadowRadius = 9;
    normalLayer.cornerRadius = 5;
    normalLayer.shadowPath = bezierPath.CGPath;
    
    // 把已经绘制好的贝塞尔曲线路径赋值给图层，然后图层根据path进行图像渲染render
    normalLayer.path = bezierPath.CGPath;
    selectLayer.path = bezierPath.CGPath;
    
    // 设置填充颜色
    normalLayer.fillColor = [UIColor whiteColor].CGColor;
    // 添加图层到nomarBgView中
    [normalBgView.layer insertSublayer:normalLayer atIndex:0];
    normalBgView.backgroundColor = UIColor.clearColor;
    cell.backgroundView = normalBgView;
    
   
}

-(UIImageView *)accImage{
    if(!_accImage){
        _accImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
        _accImage.image = [UIImage imageNamed:@"9"];
    }
    return _accImage;
}

@end
