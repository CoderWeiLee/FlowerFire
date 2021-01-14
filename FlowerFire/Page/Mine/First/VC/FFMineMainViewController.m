//
//  FFMineMainViewController.m
//  FlowerFire
//
//  Created by 王涛 on 2020/8/22.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "FFMineMainViewController.h"
#import "FFMineHeaderView.h"
#import "WTTableStyleValue1Cell.h"
#import "InvitationActivateViewController.h"
#import "ActivateMinerViewController.h"
#import "ApplyNodeViewController.h"
#import "FFAcountManagerViewController.h"
#import "SecurityCenterTableViewController.h"
#import "AboutUsViewController.h"
#import "FFFeedbackViewController.h"
#import "FFShareFriendViewController.h"

@interface FFMineMainViewController ()
{
    WTButton *_rightBarItemButon;
}
@property(nonatomic,strong)NSArray<UIViewController *> *viewControllers;
@property(nonatomic, strong)FFMineHeaderView *headerView;
@end

@implementation FFMineMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createNavBar];
    [self createUI];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self initData];
}

- (void)createNavBar{
    self.gk_statusBarStyle = UIStatusBarStyleLightContent;
    self.gk_navigationItem.title = LocalizationKey(@"tabbar6");
    self.gk_navTitleColor = KWhiteColor;
    self.gk_navBarAlpha = 0;
}

- (void)createUI{
    [self.view addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, -Height_StatusBar, ScreenWidth, ScreenHeight - Height_TabBar + Height_StatusBar);
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.bounces = NO;
    self.tableView.rowHeight = 50;
       
    _rightBarItemButon = [[WTButton alloc] initWithFrame:CGRectMake(0, 0, 100, 30) titleStr:@"" titleFont:tFont(14) titleColor:KWhiteColor buttonImage:[[UIImage imageNamed:@"node_wit_ic"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] parentView:nil];
    _rightBarItemButon.tintColor = KWhiteColor;
    _rightBarItemButon.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _rightBarItemButon.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 5);
    _rightBarItemButon.adjustsImageWhenHighlighted = NO;
    self.gk_navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBarItemButon];
}

- (void)initData{
    /*
     @{@"title":LocalizationKey(@"578Tip9"),@"image":@"wda6",@"isCheckActivationStatus":@"0"},
     */
    
    self.dataArray = @[@{@"title":LocalizationKey(@"578Tip4"),@"image":@"mining_ic"},
                       @{@"title":LocalizationKey(@"578Tip5"),@"image":@"miner_ic"},
                       @{@"title":LocalizationKey(@"578Tip6"),@"image":@"ist_ic"},
                       @{@"title":LocalizationKey(@"578Tip7"),@"image":@"node_ic"},
                       @{@"title":LocalizationKey(@"578Tip8"),@"image":@"share_ic"},
                   
                       @{@"title":LocalizationKey(@"578Tip10"),@"image":@"safety_ic"},
                       @{@"title":LocalizationKey(@"578Tip11"),@"image":@"tickling_ic",@"isCheckActivationStatus":@"0"},
                       @{@"title":LocalizationKey(@"578Tip12"),@"image":@"us_ic",@"isCheckActivationStatus":@"0"},].copy;
    
    
    //控制器数组
    //          [FFAcountManagerViewController class],  //账号管理

    self.viewControllers = @[
         [NSObject class],
         [InvitationActivateViewController class], //激活矿工
         [ActivateMinerViewController class], //激活矿工列表
         [ApplyNodeViewController class], //申请节点
         [FFShareFriendViewController class],          //分享
         [SecurityCenterTableViewController class], //安全中心
         [FFFeedbackViewController class],      //意见反馈
         [AboutUsViewController class],//关于我们
    ];
    
    [self.tableView reloadData];
    
    NSString *title = @"";
    /// 10 是开启节点,1是未开启     node_wit_ic
    if([[WTUserInfo shareUserInfo].level isEqualToString:@"10"]){
        title = LocalizationKey(@"578Tip115");
        [_rightBarItemButon setImage:[UIImage imageNamed:@"node_wit_ic"] forState:0];
    }else{
        title = LocalizationKey(@"578Tip116");
        [_rightBarItemButon setImage:[UIImage imageNamed:@"node_wit_ic"] forState:0];
    }
    [_rightBarItemButon setTitle:title forState:UIControlStateNormal];
}

#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    id viewControllerClass = self.viewControllers[indexPath.row];
    
    if ([viewControllerClass isSubclassOfClass:[UIViewController class]]) {
        if(![self.dataArray[indexPath.row][@"isCheckActivationStatus"] isEqualToString:@"0"]){
            [[UniversalViewMethod sharedInstance] activationStatusCheck:self];
        }
        
        if([WTUserInfo isLogIn]){
            [self.navigationController pushViewController:[viewControllerClass alloc] animated:YES];
        }else{
            [self jumpLogin];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    [self.tableView registerClass:[WTTableStyleValue1Cell class] forCellReuseIdentifier:identifier];
    WTTableStyleValue1Cell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if(indexPath.row == 0){
        if([[WTUserInfo shareUserInfo].activation_status isEqualToString:@"1"]){
            cell.rightLabel.text = LocalizationKey(@"578Tip142");
        }else{
            cell.rightLabel.text = LocalizationKey(@"578Tip143");
        }
    }else{
        UIImageView *arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xyy"]];
        arrowImage.frame = CGRectMake(0, 0, 15, 15);
        cell.accessoryView = arrowImage;
    }
    if(self.dataArray.count>0){
        cell.textLabel.text = self.dataArray[indexPath.row][@"title"];
        cell.imageView.image = [UIImage imageNamed:self.dataArray[indexPath.row][@"image"]];
    }
    cell.textLabel.font = tFont(15);
    
    return cell;
}
 

#pragma mark - lazyInit
- (FFMineHeaderView *)headerView{
    if(!_headerView){
        _headerView = [[FFMineHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 115 + SafeIS_IPHONE_X + 23 )];
        @weakify(self)
        [_headerView.duplicateCodeButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            @strongify(self)
            if(![HelpManager isBlankString:self.headerView.code.text]){
                UIPasteboard * pastboard = [UIPasteboard generalPasteboard];
                pastboard.string = self.headerView.code.text;
                printAlert(LocalizationKey(@"Successful copy"), 1.f);
            }else{
                printAlert(LocalizationKey(@"578Tip122"), 1.f);
            }

        }];
    }
    return _headerView;
}

@end
