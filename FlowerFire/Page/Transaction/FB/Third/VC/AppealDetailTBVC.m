//
//  AppealDetailTBVC.m
//  FireCoin
//
//  Created by 王涛 on 2019/6/6.
//  Copyright © 2019 王涛. All rights reserved.
//  申诉详情

#import "AppealDetailTBVC.h"
#import "AppealSectionTwoCell.h"
#import "AppealSectionThreeCell.h"


@interface AppealDetailTBVC ()
{
    NSArray                 *sectionOneDataArray;
    AppealSectionThreeCell  *cell;
}
@property (nonatomic, assign)CGFloat marginTop;
@end

@implementation AppealDetailTBVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self setUpView];
}

#pragma mark - action 申诉


#pragma mark - netBack
-(void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    printAlert(dict[@"msg"], 1.f);
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - dataSource
-(void)initData{
    sectionOneDataArray = [self.dataArray copy];
    
    NSString *time;
    if([self.model.is_appeal isEqualToString:@"0"]){
        time = self.model.totime;
    }else{
        time = self.model.fromtime;
    }
    
    sectionOneDataArray = @[@{@"title":LocalizationKey(@"AppealTip2"),@"details":self.model.otcOrderId},
                            @{@"title":LocalizationKey(@"FiatOrderTip24"),@"details":self.model.price},
                            @{@"title":LocalizationKey(@"AppealTip3"),@"details":self.model.amount},
                            @{@"title":LocalizationKey(@"AppealTip4"),@"details":[NSString stringWithFormat:@"¥ %@",self.model.total_price]},
                            @{@"title":LocalizationKey(@"Date"),@"details":[HelpManager getTimeStr:time dataFormat:@"yyyy-MM-dd HH:mm:ss"]}];
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
    if([self.model.is_from isEqualToString:@"0"]){
        if(self.model.to_appeal_imgs.count == 0){
            return 2;
        }
    }else{
        if(self.model.from_appeal_imgs.count == 0){
            return 2;
        } 
    }
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if(!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
     //   cell.backgroundColor = navBarColor;
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
        AppealSectionTwoCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if(!cell){
            cell = [[AppealSectionTwoCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        }
        //是否发起者，0 显示to_content ， 1 显示from_content
        if([self.model.is_from isEqualToString:@"0"]){
            cell.detailText.text = self.model.to_content;
        }else{
            cell.detailText.text = self.model.from_content;
        }
        cell.detailText.userInteractionEnabled = NO;
        return cell;
    }else{
        cell = [tableView cellForRowAtIndexPath:indexPath];
        if(!cell){
            cell = [[AppealSectionThreeCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        }
        //是否发起者，0 显示to_content ， 1 显示from_content
        if([self.model.is_from isEqualToString:@"0"]){
            cell.photosArray = [NSMutableArray arrayWithArray:self.model.to_appeal_imgs];
        }else{
            cell.photosArray = [NSMutableArray arrayWithArray:self.model.from_appeal_imgs];
        }
       
        cell.isJumpDetails = YES;
        return cell;
    }
    
}
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
  //  headerBac.backgroundColor = navBarColor;
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
    
    self.tableView.frame = CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight - 0 - Height_NavBar);
    [self.view addSubview:self.tableView];
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView setTableHeaderView:headerBac];
}

@end
