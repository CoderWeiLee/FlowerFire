//
//  SwitchGoogleVerificationViewController.m
//  FireCoin
//
//  Created by 王涛 on 2019/12/3.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "SwitchGoogleVerificationViewController.h"
#import "SendVerificationCodeModalVC.h"
#import "BaseNavigationController.h"

@interface SwitchGoogleVerificationViewController ()

@property(nonatomic, strong)UISwitch *gooleCodeSwitch;
@end

@implementation SwitchGoogleVerificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpView];
    [self initData];
}

-(void)setUpView{
    self.gk_navigationItem.title = LocalizationKey(@"securityTip5");
    [self.view addSubview:self.tableView];
}

#pragma mark - action
-(void)gooleCodeSwitchClick:(UISwitch *)sender{
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    md[@"is_googleauth"] = sender.on ? @"1" : @"2"; //是否开启谷歌验证 2 关闭 1 开启
    SendVerificationCodeModalVC *mvc = [SendVerificationCodeModalVC new];
    mvc.sendVerificationCodeWhereJump = SendVerificationCodeWhereJumpSwitchGoogleCode;
    mvc.sendCodeNetDic = md;
    mvc.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    BaseNavigationController * nav = [BaseNavigationController rootVC:mvc];
    nav.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
       
    nav.modalPresentationStyle = UIModalPresentationOverFullScreen;
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    [self presentViewController:nav animated:YES completion:nil];
     
      
    @weakify(self)
    mvc.backRefreshBlock = ^{
        @strongify(self)
        [self closeVC];
        //成功后存为绑定成功
        NSInteger status;
        if(sender.isOn){
            status = 1; //开启的
        }else{
            status = 2; //关闭的
        }
        WTUserInfo *userInfo = [WTUserInfo shareUserInfo];
        userInfo.is_googleauth = NSStringFormat(@"%ld",(long)status);
        [WTUserInfo saveUser:userInfo];
    };
    mvc.dissmissVCBlock = ^{
       sender.on = !sender.on;
    };
}

- (void)initData{
    self.dataArray = @[@{@"title":LocalizationKey(@"googleVerificationTip1")},
     @{@"title":LocalizationKey(@"googleVerificationTip11")},].copy;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    cell.textLabel.text = self.dataArray[indexPath.row][@"title"];
    cell.textLabel.font = tFont(16);
    cell.textLabel.theme_textColor = THEME_TEXT_COLOR;
    cell.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
      
    if(indexPath.row == 0){
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.detailTextLabel.text = LocalizationKey(@"googleVerificationTip10");
        cell.detailTextLabel.textColor = [UIColor  grayColor];
        cell.detailTextLabel.font = tFont(15);
    }else{
        cell.accessoryView = self.gooleCodeSwitch;
    }
    
    return cell;
}
 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
 
-(UISwitch *)gooleCodeSwitch{
    if(!_gooleCodeSwitch){
        _gooleCodeSwitch = [[UISwitch alloc] init];
        _gooleCodeSwitch.onTintColor = MainColor;
        [_gooleCodeSwitch addTarget:self action:@selector(gooleCodeSwitchClick:) forControlEvents:UIControlEventValueChanged];
        if([[WTUserInfo shareUserInfo].is_googleauth integerValue] == 1){
            _gooleCodeSwitch.on = YES;
        }else{
            _gooleCodeSwitch.on = NO;
        }
    }
    return _gooleCodeSwitch;
}

@end
