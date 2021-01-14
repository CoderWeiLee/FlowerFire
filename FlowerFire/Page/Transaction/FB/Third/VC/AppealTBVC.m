//
//  AppealTBVC.m
//  FireCoin
//
//  Created by 王涛 on 2019/6/3.
//  Copyright © 2019 王涛. All rights reserved.
//  申诉

#import "AppealTBVC.h"
#import "AppealSectionTwoCell.h"
#import "AppealSectionThreeCell.h"

@interface AppealTBVC ()
{
    NSArray                 *sectionOneDataArray;
    AppealSectionThreeCell  *cell;
    AppealSectionTwoCell    *cell1;
}
@property (nonatomic, assign)CGFloat marginTop;
@end

@implementation AppealTBVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self setUpView];
}

#pragma mark - action 申诉提交
//申诉订单，未收到款项申请客服处理
-(void)submitClick{
    if(cell && cell1){
    //    if(cell.photosArray.count > 0){。凭证不必填
            if(![HelpManager isBlankString:cell1.detailText.text]){
                NSString *photo = [cell.photosArray componentsJoinedByString:@","];
                [self.afnetWork jsonPostDict:@"/api/otc/appealOtcOrder" JsonDict:@{@"otc_order_id":self.model.otcOrderId,
                                                                                   @"content":cell1.detailText.text,
                                                                                   @"appeal_img":photo
                                                                                   } Tag:@"1"];
            }else{
                printAlert(LocalizationKey(@"AppealTip1"), 1);
            }
     //   }else{
    //        printAlert(@"请上传凭证", 1);
     //   }
    }
}

#pragma mark - netBack
-(void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    printAlert(dict[@"msg"], 1.f);
   
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - dataSource
-(void)initData{
    sectionOneDataArray = [self.dataArray copy];
    sectionOneDataArray = @[@{@"title":LocalizationKey(@"AppealTip2"),@"details":self.model.otcOrderId},
                       @{@"title":LocalizationKey(@"FiatOrderTip24"),@"details":self.model.price},
                       @{@"title":LocalizationKey(@"AppealTip3"),@"details":self.model.amount},
                       @{@"title":LocalizationKey(@"AppealTip4"),@"details":[NSString stringWithFormat:@"¥ %@",self.model.total_price]}];
}

#pragma mark tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return sectionOneDataArray.count;
        case 1:
            return 1;
        default:
            return 1;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if(!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
      //  cell.backgroundColor = navBarColor;
        
        [cell setTheme_backgroundColor:THEME_CELL_BACKGROUNDCOLOR];
        cell.textLabel.font = tFont(15);
        cell.detailTextLabel.font = tFont(15);
        cell.textLabel.text = sectionOneDataArray[indexPath.row][@"title"];
        cell.detailTextLabel.text = sectionOneDataArray[indexPath.row][@"details"];
        cell.textLabel.textColor = rgba(115, 126, 149, 1);
        if(indexPath.row == 3){
            cell.detailTextLabel.textColor = MainColor;
            cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:18];
        }else{
            cell.detailTextLabel.textColor = rgba(115, 126, 149, 1);
        }
        return cell;
    }else if(indexPath.section == 1){
        cell1 = [tableView cellForRowAtIndexPath:indexPath];
        if(!cell1){
            cell1 = [[AppealSectionTwoCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        }
//        static NSString *identifier = @"cell";
//        [self.tableView registerClass:[AppealSectionTwoCell class] forCellReuseIdentifier:identifier];
//        cell1 = [tableView dequeueReusableCellWithIdentifier:identifier];
//        if(!cell1){
//             cell1 = [[AppealSectionTwoCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
//        }
        return cell1;
    }else{
//        static NSString *identifier1 = @"cell1";
//        [self.tableView registerClass:[AppealSectionThreeCell class] forCellReuseIdentifier:identifier1];
//        cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
//        if(!cell){
//            cell = [[AppealSectionThreeCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
//        }

//
        cell = [tableView cellForRowAtIndexPath:indexPath];
        if(!cell){
            cell = [[AppealSectionThreeCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        }
        
        return cell;
    }
    
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    switch (indexPath.section) {
//        case 0:
//            return 44;
//        case 1:
//            return 100;
//        default:
//            return 300;
//    }
//}

#pragma mark ScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // 实时监测scrollView.contentInset.top， 系统优化以及手动设置contentInset都会影响contentInset.top。
    if (self.marginTop != self.tableView.contentInset.top) {
        self.marginTop = self.tableView.contentInset.top;
    }
    
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat newoffsetY = offsetY + self.marginTop;
    
    // 临界值150，向上拖动时变透明
    if (newoffsetY >= 0 && newoffsetY <= -80) {
        self.gk_navigationItem.title = @"";
    }else if (newoffsetY > 80){
        self.gk_navigationItem.title = LocalizationKey(@"FiatOrderTip11");
    }else{
        self.gk_navigationItem.title = @"";
    }
}

#pragma mark - ui
-(void)setUpView{
    UIView *headerBac = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 80)];
   // headerBac.backgroundColor = navBarColor;
    [headerBac setTheme_backgroundColor:THEME_CELL_BACKGROUNDCOLOR];
    UILabel *topLabel = [UILabel new];
    topLabel.text = LocalizationKey(@"FiatOrderTip11");
    topLabel.theme_textColor = THEME_TEXT_COLOR;
    topLabel.font = [UIFont boldSystemFontOfSize:30];
    [headerBac addSubview:topLabel];
    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(headerBac.mas_centerY).offset(0);
        make.left.mas_equalTo(headerBac.mas_left).offset(OverAllLeft_OR_RightSpace);
    }];
    
    self.tableView.frame = CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight - 90 - Height_NavBar);
    [self.view addSubview:self.tableView];
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView setTableHeaderView:headerBac];
    
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setTitle:LocalizationKey(@"VerificationSettingTip7") forState:UIControlStateNormal];
    addBtn.backgroundColor = rgba(219, 106, 119, 1);
    addBtn.layer.cornerRadius = 3;
    addBtn.layer.masksToBounds = YES;
    [addBtn addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-20);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth - 40, 50));
    }];
}

@end
