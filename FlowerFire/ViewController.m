//
//  ViewController.m
//  BaseDevelopmentFramework
//
//  Created by 王涛 on 2019/11/4.
//  Copyright © 2019 Celery. All rights reserved.
//

#import "ViewController.h"
#import "WTWebViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.gk_navigationItem.title = @"123";
    //[self.view addSubview:self.tableView];
    UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(self.view.center.x - 30, self.view.center.y - 140, 60, 80)];
    [self.view addSubview:la];
    la.text = LocalizationKey(@"tabbar1");
    self.view.backgroundColor = [UIColor systemBlueColor];
    
    la.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] init];
    @weakify(self)
    [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        @strongify(self)
        WTWebViewController *webview = [[WTWebViewController alloc] initWithURLString:@"http://piaofang.baidu.com" ];
        [self.navigationController pushViewController:webview animated:YES];
    }];
    [la addGestureRecognizer:tap];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"换肤" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    btn.frame = CGRectMake(la.center.x-40, CGRectGetMaxY(la.frame)+20, 80, 40);
    static BOOL isSwith = NO;
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        isSwith ? [[SDThemeManager sharedInstance] changeTheme:WHITE_THEME] : [[SDThemeManager sharedInstance] changeTheme:BLACK_THEME];
        isSwith = !isSwith;
        
    }];
    
     UIButton *btn1  = [UIButton buttonWithType:UIButtonTypeCustom];
       [btn1 setTitle:@"跳导航页面" forState:UIControlStateNormal];
       [btn1 setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
       [self.view addSubview:btn1];
       btn1.frame = CGRectMake(la.center.x-40, CGRectGetMaxY(btn.frame)+20, 80, 40);
    [btn1 sizeToFit];
    
       [[btn1 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
             
           @strongify(self)
               [self.navigationController pushViewController:[ViewController new]  animated:YES];
          
           
       }];
    
//    [MBManager showBriefAlert:@"网络连接超时" time:2.f inView:self.view];
    // [self.afnetWork jsonGetDict:@"https://www.google.com/search?q=a&oq=a&aqs=chrome..69i57j5l3j69i60l2.321j0j8&sourceid=chrome&ie=UTF-8" JsonDict:@{} Tag:@"1" LoadingInView:self.view];
//    UIImage *image = [UIImage imageNamed:@"fishpond_highlight"];
//    NSData *date = UIImagePNGRepresentation(image);
//     [self.afnetWork uploadDataPost:date parameters:nil urlString:@"/123123" LoadingInView:self.view];
//    [self modeSwitchingExample];
   
}
- (void)modeSwitchingExample {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view
                                              animated:YES];

    // Set some text to show the initial status.
    hud.label.text = NSLocalizedString(@"Preparing...", @"HUD preparing title");
    // Will look best, if we set a minimum size.
    hud.minSize = CGSizeMake(150.f, 100.f);

    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        // Do something useful in the background and update the HUD periodically.
        [self doSomeWorkWithMixedProgress];
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
    });
}

- (void)doSomeWorkWithMixedProgress {
    // HUDForView: 找到顶层视图上的 HUD
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.navigationController.view];
    // 不确定模式
    sleep(2);
    // 异步主线程，切换到确定模式
    dispatch_async(dispatch_get_main_queue(), ^{
        hud.mode = MBProgressHUDModeDeterminate;
        hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
    });
    float progress = 0.0f;
    while (progress < 1.0f) {
        progress += 0.01f;
        dispatch_async(dispatch_get_main_queue(), ^{
            hud.progress = progress;
        });
        usleep(50000);
    }
    
    // 同步主线程，自定义视图
    dispatch_sync(dispatch_get_main_queue(), ^{
        UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        hud.customView = imageView;
        hud.mode = MBProgressHUDModeCustomView;
        hud.label.text = NSLocalizedString(@"Completed", @"HUD completed title");
    });
    sleep(2);
}

- (void)getHttpData:(NSDictionary *)dict response:(Response)flag{
    
}
//
//#pragma mark - -------------- TableView DataSource -----------------
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return [self.dataArray count];
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 52;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 10 + 44 + 10;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 10;
//}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    static NSString *iden = @"cellIden";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
//    }
//
//    cell.textLabel.text = self.dataArray[indexPath.row];
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//
//    return cell;
//}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//}

- (void)getHttpData_array:(NSDictionary *)dict response:(Response)flag and:(NSString *)type{
    
}

- (void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    
}

@end
