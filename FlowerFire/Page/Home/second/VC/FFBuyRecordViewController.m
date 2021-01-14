//
//  FFBuyRecordViewController.m
//  FlowerFire
//
//  Created by 王涛 on 2020/8/25.
//  Copyright © 2020 Celery. All rights reserved.
//。委托，订单记录，历史记录

#import "FFBuyRecordViewController.h"
#import "FFBuyRecordCell.h"
#import "FFBuyRecordCommissionModel.h"
#import "FFBuyRecordHidtoryRecordModel.h"
#import "CurrencyTransactionCurrentCommissionCell.h"
#import "CurrencyTransactionModel.h"
#import "suocangcell.h"
@interface FFBuyRecordViewController ()<UIAlertViewDelegate>
@property(nonatomic, assign)NSString *password;
@property(nonatomic, assign)NSString *ID;

@property(nonatomic, assign)FFBuyRecordType FFBuyRecordType;
@end

@implementation FFBuyRecordViewController

- (instancetype)initWithFFBuyRecordType:(FFBuyRecordType)FFBuyRecordType
{
    self = [super init];
    if (self) {
        self.FFBuyRecordType = FFBuyRecordType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavBar];
    [self createUI];
    [self initData];
}

- (void)createNavBar{
    switch (self.FFBuyRecordType) {
        case FFBuyRecordTypeCommission:
            self.gk_navigationItem.title = LocalizationKey(@"578Tip96");
            break;
        case FFBuyRecordTypeOrderRecord:
            self.gk_navigationItem.title = LocalizationKey(@"578Tip97");
            break;
        case suo:
            self.gk_navigationItem.title = LocalizationKey(@"homeButtonTip22suodan");
            break;
        default:
            self.gk_navigationItem.title = LocalizationKey(@"578Tip98");
            break;
    }
    
}

- (void)createUI{
    self.tableView.frame = CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight - Height_NavBar);
   
    [self.view addSubview:self.tableView];
    
    switch (self.FFBuyRecordType) {
        case FFBuyRecordTypeCommission:
            break;
        case FFBuyRecordTypeOrderRecord:
            self.tableView.rowHeight = 150;
            break;
        case suo:
            self.tableView.rowHeight = 100;
            break;
        default:
            self.tableView.rowHeight = 70;
            break;
    }
      
    [self setMjFresh];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
     UITextField *passwordText = [alertView textFieldAtIndex:0];
     self.password = [NSString stringWithFormat:@"%@",passwordText.text];
    if (buttonIndex == 1) {
        [self.afnetWork jsonPostDict:@"/api/lock/unlock" JsonDict:@{
                        @"paypass":[NSString stringWithFormat:@"%@",self.password],
                            @"id":self.ID
        } Tag:@"109"];

    }
 }

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return;
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    UIAlertController *alerVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"提前解锁会扣除15%" preferredStyle:1];
    
    [alerVc addAction:[UIAlertAction  actionWithTitle:@"取消" style:0 handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alerVc addAction:[UIAlertAction  actionWithTitle:@"解锁" style:0 handler:^(UIAlertAction * _Nonnull action) {
        
        switch (self.FFBuyRecordType) {
                
            case suo:
            {
                
                NSDictionary *dic = self.dataArray[indexPath.row];
                NSString *status = [NSString stringWithFormat:@"%@",dic[@"status"]];
                if ([status isEqual:@"1"]) {

                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"请输入密码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                       alertView.alertViewStyle = UIAlertViewStyleSecureTextInput;
                    [alertView show];
                    
                    
                    self.ID = [NSString stringWithFormat:@"%@",dic[@"id"]];
                   
                }
                         
            }
                break;
            default:{
                
            }
                break;
                
        }

        
    }]];

    [self presentViewController:alerVc animated:YES completion:nil];
    
    
    
    /*
     "coin_id" = 21;
     createtime = 1607164931;
     id = 6;
     "lock_day" = 30;
     locktime = 0;
     money = "10.00000000";
     "multiple_rate" = "1.20";
     status = 0;
     "total_money" = "0.00000000";
     type = 1;
     "unlock_rate" = "15.00";
     updatetime = 0;
     "user_id" = 11274;
 }
     */
}
- (void)initData{
    switch (self.FFBuyRecordType) {
        case FFBuyRecordTypeCommission:
        {   //委托[获取SD买卖记录] /api/cc/SDList
            NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:3];
            md[@"type"] = @"all"; // 类型 all 全部 0 买入 1 卖出
            md[@"order_status"] = @"all"; //订单状态 all=全部 -1=已撤销 0=挂售中 1=已完成
            md[@"page"] = [NSString stringWithFormat:@"%ld", (long)self.pageIndex];
            [self.afnetWork jsonPostDict:@"/api/cc/SDList" JsonDict:md Tag:@"1"];
        }
            break;
        case FFBuyRecordTypeHidtoryRecord:
        {
            NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:1];
            md[@"page"] = [NSString stringWithFormat:@"%ld", (long)self.pageIndex];
            [self.afnetWork jsonPostDict:@"/api/cc/walletList" JsonDict:md Tag:@"1"];
        }
            break;
        case suo:
        {
            NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:2];
            md[@"day"] = @"0";
            md[@"status"] = @"all";
            [self.afnetWork jsonPostDict:@"/api/lock/data" JsonDict:md Tag:@"1"];
        }
            break;
        default:
        case FFBuyRecordTypeOrderRecord:
        {
            //订单记录[获取vbg买卖记录] /api/cc/vbgList
            NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:3];
            md[@"type"] = @"all"; // 类型 all 全部 0 买入 1 卖出
            md[@"order_status"] = @"all"; //订单状态 all=全部 -1=已撤销 0=挂售中 =已完成
            md[@"page"] = [NSString stringWithFormat:@"%ld", (long)self.pageIndex];
            [self.afnetWork jsonPostDict:@"/api/cc/vbgList" JsonDict:md Tag:@"1"];
        }
            break;
    }
    
    [self.tableView reloadData];
}

#pragma mark - netdate
- (void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    if ([type isEqualToString:@"109"]) {
        
        
        
    }
    if([type isEqualToString:@"1"]){
        if(self.isRefresh){
            self.dataArray=[[NSMutableArray alloc]init];
        }
        
        switch (self.FFBuyRecordType) {
            case FFBuyRecordTypeCommission:
            {
                for (NSDictionary *dic in dict[@"data"][@"list"]) {
                    CurrencyTransactionModel *model = [CurrencyTransactionModel yy_modelWithDictionary:dic];
                     [self.dataArray addObject:model];
                }
            }
                break;
            case FFBuyRecordTypeHidtoryRecord:
            {
                for (NSDictionary *dic in dict[@"data"][@"list"]) {
                   // FFBuyRecordHidtoryRecordModel *model = [FFBuyRecordHidtoryRecordModel yy_modelWithDictionary:dic];
                    [self.dataArray addObject:dic];
                }
            }
                break;
            case suo:
            {
                for (NSDictionary *dic in dict[@"data"][@"list"]) {
                    [self.dataArray addObject:dic];
                }
            }
                break;
            default:
            {
                for (NSDictionary *dic in dict[@"data"][@"list"]) {
                    CurrencyTransactionModel *model = [CurrencyTransactionModel yy_modelWithDictionary:dic];
                     [self.dataArray addObject:model];
                }
            }
                break;
        }
        self.allPages = [dict[@"data"][@"allPage"] integerValue];
    }
    [self.tableView reloadData];
}
 
#pragma mark - tableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (self.FFBuyRecordType) {
        case FFBuyRecordTypeCommission:
        {
            static NSString *identifier = @"cell";
            [self.tableView registerClass:[CurrencyTransactionCurrentCommissionCell class] forCellReuseIdentifier:identifier];
            CurrencyTransactionCurrentCommissionCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if(!cell){
                cell = [[CurrencyTransactionCurrentCommissionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            if(self.dataArray.count >0){
                [cell setCellData:self.dataArray[indexPath.row] fromScale:0 toScale:0 priceScale:0];
            }
            __weak typeof(self) weakSelf = self;
            cell.cancelBlcok = ^(UITableViewCell *cell) {
                 [weakSelf.tableView.mj_header beginRefreshing];
            };
            return cell;
        }
            
        case FFBuyRecordTypeHidtoryRecord:
        {
            static NSString *identifier = @"cell1";
            [self.tableView registerClass:[FFBuyRecordCell class] forCellReuseIdentifier:identifier];
            FFBuyRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            
            if(self.dataArray.count>0){
//                FFBuyRecordHidtoryRecordModel *model = self.dataArray[indexPath.row];
//                cell.topLabel.text = NSStringFormat(@"%@%@",model.memo,model.symbol);
//                cell.bottomLabel.text = model.createtime;
//                cell.centerLabel.text = model.money;
                NSDictionary *dic = self.dataArray[indexPath.row];
                cell.topLabel.text = NSStringFormat(@"%@%@",dic[@"memo"],dic[@"symbol"]);
                cell.bottomLabel.text = [HelpManager getTimeStr:NSStringFormat(@"%@",dic[@"createtime"]) dataFormat:@"yyyy-MM-dd HH:mm:ss"] ;
                cell.centerLabel.text = NSStringFormat(@"%@",dic[@"money"]);
            }
            return cell;
        }
            break;
        case suo:
        {
            
            suocangcell *cell = [suocangcell cellwithtableview:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if(self.dataArray.count>0){
                NSDictionary *dic = self.dataArray[indexPath.row];
//                cell.labelday.text = NSStringFormat(@"%@",dic[@"day"]);
                cell.labelday.text = [NSString stringWithFormat:@"%@",dic[@"lock_day"]];
                cell.label1.text = dic[@"money"];
                
                cell.labeltime.text =  [HelpManager getTimeStr:NSStringFormat(@"%@",dic[@"createtime"]) dataFormat:@"yyyy-MM-dd HH:mm:ss"];
                cell.labenbtn.layer.masksToBounds = YES;
                cell.labenbtn.layer.cornerRadius = 17.5;
                cell.labenbtn.layer.borderWidth = 1.0;
                cell.labenbtn.layer.borderColor = [UIColor colorWithRed:139/255.0 green:179/255.0 blue:226/255.0 alpha:1].CGColor;
                NSString *status = [NSString stringWithFormat:@"%@",dic[@"status"]];
                // 1可以解锁 0为排队，2为已产出完成，3为用户提前解锁
                if ([status isEqual:@"1"]) {
                    
                    cell.labenbtn.userInteractionEnabled = NO;
                }else if ([status isEqual:@"0"]){
                    cell.labenbtn.userInteractionEnabled = NO;
                    [cell.labenbtn setTitle:@"排队中" forState:0];
                }else if ([status isEqual:@"2"]){
                    cell.labenbtn.userInteractionEnabled = NO;
                    [cell.labenbtn setTitle:@"已产出完成" forState:0];
                }else if ([status isEqual:@"3"]){
                    cell.labenbtn.userInteractionEnabled = NO;
                    [cell.labenbtn setTitle:@"提前解锁" forState:0];
                }
                
                
            }
            return cell;
        }
            break;
            
        default:
        {
            static NSString *identifier = @"cell";
            [self.tableView registerClass:[CurrencyTransactionCurrentCommissionCell class] forCellReuseIdentifier:identifier];
            CurrencyTransactionCurrentCommissionCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if(!cell){
                cell = [[CurrencyTransactionCurrentCommissionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            if(self.dataArray.count >0){
                [cell setCellData:self.dataArray[indexPath.row] fromScale:0 toScale:0 priceScale:0];
            }
            __weak typeof(self) weakSelf = self;
            cell.cancelBlcok = ^(UITableViewCell *cell) {
                 [weakSelf.tableView.mj_header beginRefreshing];
            };
            return cell;
        }
    }
    
    
//    if(self.dataArray.count>0){
//        switch (self.FFBuyRecordType) {
//            case FFBuyRecordTypeCommission:
//            {
//                FFBuyRecordCommissionModel *model = self.dataArray[indexPath.row];
//                cell.topLabel.text = NSStringFormat(@"%@%@",model.order_type_name,@"SD");
//                cell.bottomLabel.text = model.addtime;
//            }
//                break;
//            case FFBuyRecordTypeHidtoryRecord:
//            {
//
//            }
//                break;
//            default:
//                break;
//        }
//    }
    
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
}
 



@end
