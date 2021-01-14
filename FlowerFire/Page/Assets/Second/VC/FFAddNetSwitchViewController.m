//
//  FFAddNetSwitchViewController.m
//  FlowerFire
//
//  Created by 王涛 on 2020/8/25.
//  Copyright © 2020 Celery. All rights reserved.
//  添加网关

#import "FFAddNetSwitchViewController.h"

@interface FFAddNetSwitchViewController ()

@end

@implementation FFAddNetSwitchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavBar];
    [self createUI];
    [self initData];
}
   
-(void)netSwitchClick:(UISwitch*)uiSwitch{
    if(self.dataArray.count>0){
        NSIndexPath *indePath = [self getButtonConvertPoint:uiSwitch];
        NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:2];
        md[@"coin_id"] = self.dataArray[indePath.row][@"coin_id"];
        md[@"state"] = @(uiSwitch.isOn); //0取消,1开通
        [self.afnetWork jsonPostDict:@"/api/cc/buyGateWayCoin" JsonDict:md Tag:@"2"];
    }

}

- (void)createNavBar{
    self.gk_navigationItem.title = LocalizationKey(@"578Tip93");
}

- (void)createUI{
    self.tableView.frame = CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight - Height_NavBar);
    self.tableView.bounces = NO;
    self.tableView.rowHeight = 60;
    [self.view addSubview:self.tableView];
    
}

- (void)initData{
    [self.afnetWork jsonGetDict:@"api/cc/getGateWayCoins" JsonDict:nil Tag:@"1"];
    [self.tableView reloadData];
}

- (void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    switch ([type integerValue]) {
        case 1:
        {
            for (NSDictionary *dic in dict[@"data"][@"all_coins"]) {
                [self.dataArray addObject:dic];
            }
            
            NSMutableArray *twoDataArray = self.dataArray.mutableCopy;
            NSArray *existCoinArray = [NSArray arrayWithArray:dict[@"data"][@"exist_coin_ids"]];
            
            for (int i = 0; i<self.dataArray.count; i++) {
                NSDictionary *dic = self.dataArray[i];
                for (int j = 0; j<existCoinArray.count; j++) {
                    NSString *existID = existCoinArray[j];
                    if([NSStringFormat(@"%@",existID) isEqualToString:NSStringFormat(@"%@",dic[@"coin_id"])]){
                        NSMutableDictionary *md = [NSMutableDictionary dictionaryWithDictionary:twoDataArray[i]];
                        md[@"isOn"] = @"1";
                        twoDataArray[i] = md;
                    }
                }
            }
             
            self.dataArray = twoDataArray.mutableCopy;
            
            [self.tableView reloadData];
        }
            break;
        case 2:
        {
            printAlert(dict[@"msg"], 1.f);
        }
            break;
        default:
            break;
    }
}

- (void)dataErrorHandle:(NSDictionary *)dict type:(NSString *)type{
    printAlert(dict[@"msg"], 1.f);
    [self.tableView reloadData];
}

#pragma mark - tableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UISwitch *arrowImage = [[UISwitch alloc] init];
    arrowImage.onTintColor = MainColor;
    cell.accessoryView = arrowImage;
    arrowImage.tag = indexPath.row;
    [arrowImage addTarget:self action:@selector(netSwitchClick:) forControlEvents:UIControlEventValueChanged];
    
    if(self.dataArray.count>0){
        arrowImage.on = [self.dataArray[indexPath.row][@"isOn"] boolValue];
        cell.textLabel.text = self.dataArray[indexPath.row][@"symbol"];
        cell.imageView.image = [UIImage imageNamed:self.dataArray[indexPath.row][@"symbol"]];
    }
    cell.textLabel.font = tFont(15);
    
    return cell;
}
 
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *bacView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    bacView.backgroundColor = KWhiteColor;
    WTLabel *la = [[WTLabel alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, 0, ScreenWidth, 30) Text:LocalizationKey(@"578Tip94") Font:tFont(13) textColor:grayTextColor parentView:bacView];
    
    WTBacView *line = [[WTBacView alloc] initWithFrame:CGRectMake(la.left, bacView.height - 1, SCREEN_WIDTH -2 *OverAllLeft_OR_RightSpace, 1) backGroundColor:FlowerFirexianColor parentView:nil];
    [bacView addSubview:line];
    return bacView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (NSIndexPath *)getButtonConvertPoint:(UIView * _Nonnull)btn {
    CGPoint point = btn.center;
    point = [self.tableView convertPoint:point fromView:btn.superview];
    NSIndexPath  *indexpath = [self.tableView indexPathForRowAtPoint:point];
    return indexpath;
}

@end
