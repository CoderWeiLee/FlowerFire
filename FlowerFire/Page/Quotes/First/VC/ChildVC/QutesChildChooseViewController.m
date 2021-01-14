//
//  QutesChildChooseViewController.m
//  FlowerFire
//
//  Created by 王涛 on 2020/4/29.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "QutesChildChooseViewController.h"
#import "QuotesPageCell.h"
#import "QutesSortView.h"
#import <MagicalRecord/MagicalRecord.h>
#import "OptionalSymbol+CoreDataClass.h"
#import "KLlineViewController.h"

NSNotificationName const ChooseCustomSymbol = @"ChooseCustomSymbol";

@interface QutesChildChooseViewController ()<UITableViewDataSource,UITableViewDelegate,QutesSortViewDelegate,KLlineViewControllerDelegate>
{
     int _selectIndexName,_selectIndexPrice,_selectIndexChange;
}

@property(nonatomic, strong)QutesSortView *qutesSortView;

@end

@implementation QutesChildChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self createNavBar];
    [self createUI];
}

#pragma mark - action
-(void)addCustomChoose{
    [[NSNotificationCenter defaultCenter] postNotificationName:ChooseCustomSymbol object:nil];
}

#pragma mark - QutesSortViewDelegate
/**
 名字排序
 */
-(void)sortByName:(UIButton *)btn{
    
    if(_selectIndexName == 0){
        _selectIndexName++;
    }else if (_selectIndexName == 1){
        _selectIndexName++;
    }else if (_selectIndexName == 2){
        _selectIndexName = 0;
    }
    self.sortType = 0;
    self.sortDirection = _selectIndexName;
    [self changeBtnImage:_selectIndexName btn:btn];
    [self changeBtnImage:0 btn:self.qutesSortView.sortBtn1];
    [self changeBtnImage:0 btn:self.qutesSortView.sortBtn2];
    [self startSortData:self model:nil];
}

/**
 最新价排序
 */
-(void)sortByPrice:(UIButton *)btn{
    if(_selectIndexPrice == 0){
        _selectIndexPrice++;
    }else if (_selectIndexPrice == 1){
        _selectIndexPrice++;
    }else if (_selectIndexPrice == 2){
        _selectIndexPrice = 0;
    }
    self.sortType = 1;
    self.sortDirection = _selectIndexPrice;
    [self changeBtnImage:_selectIndexPrice btn:btn];
    [self changeBtnImage:0 btn:self.qutesSortView.sortBtn];
    [self changeBtnImage:0 btn:self.qutesSortView.sortBtn2];
    [self startSortData:self model:nil];
}

/**
 涨跌幅排序
 */
-(void)sortByChange:(UIButton *)btn{
    if(_selectIndexChange == 0){
        _selectIndexChange++;
    }else if (_selectIndexChange == 1){
        _selectIndexChange++;
    }else if (_selectIndexChange == 2){
        _selectIndexChange = 0;
    }
    self.sortType = 2;
    self.sortDirection = _selectIndexChange;
    [self changeBtnImage:_selectIndexChange btn:btn];
    [self changeBtnImage:0 btn:self.qutesSortView.sortBtn1];
    [self changeBtnImage:0 btn:self.qutesSortView.sortBtn];
    
    [self startSortData:self model:nil];
}

-(void)changeBtnImage:(int)Index btn:(UIButton *)btn{
    switch (Index) {
        case 0:
            [btn theme_setImage:@"market_selected_default" forState:UIControlStateNormal];
            break;
        case 1:
            [btn theme_setImage:@"market_selected_up_light" forState:UIControlStateNormal];
            break;
        default:
            [btn theme_setImage:@"market_selected_down_light" forState:UIControlStateNormal];
            break;
    }
}

#pragma mark - ui
- (void)createNavBar{
    self.gk_navigationBar.hidden = YES;
}

- (void)createUI{
    
    [self.tableView setEmptyViewContentViewY:(ScreenHeight - Height_NavBar - 50 - Height_TabBar)/2];
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.qutesSortView;
}

#pragma mark - ui
-(QutesSortView *)qutesSortView{
    if(!_qutesSortView){ 
        _qutesSortView = [[QutesSortView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
        _qutesSortView.delegate = self;
    }
    return _qutesSortView;
}

#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    [self.tableView registerClass:[QuotesPageCell class] forCellReuseIdentifier:identifier];
    QuotesPageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    QuotesTradingZoneModel *model = self.modelArray[indexPath.row];
    if (self.modelArray.count >0) {
        [cell setCellData:model.list[0]];
    }
//    if (self.modelArray.count >0) {
//        [cell setCellData:self.modelArray[indexPath.row]];
//    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.modelArray.count > 0){
        QuotesTransactionPairModel *model = self.modelArray[indexPath.row];
        KLlineViewController *klVC = [KLlineViewController new];
        klVC.fromScale = model.from_dec;
        klVC.toScale = model.to_dec;
        klVC.priceScale = model.dec;
        klVC.delegate = self;
        klVC.fromId = model.from;
        klVC.TransactionPairName = model.display_name;
        ((AppDelegate *)[UIApplication sharedApplication].delegate).marketId = model.market_id;
        [self.navigationController pushViewController:klVC animated:YES];
    }
}

#pragma mark - klineDelegate
-(void)didTrade:(UIButton *)btn TransactionPairName:(nonnull NSString *)TransactionPairName fromId:(nonnull NSString *)fromId{ //0买 1卖
      
    NSDictionary *dic;
    
    NSArray *nameArray = [TransactionPairName componentsSeparatedByString:@"/"];
    
    if(btn.tag == 0){
        dic=[NSDictionary dictionaryWithObjectsAndKeys:nameArray[0],@"leftSymbol",nameArray[1],@"rightSymbol",@"buy",@"kind",fromId,@"fromId",nil];
    }else{
        dic=[NSDictionary dictionaryWithObjectsAndKeys:nameArray[0],@"leftSymbol",nameArray[1],@"rightSymbol",@"sell",@"kind",fromId,@"fromId",nil];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:CURRENTSELECTED_SYMBOL object:nil userInfo:dic];
}


#pragma mark - netBack 自选先查本地设置
- (void)netDateHandle:(NSArray *)titleArray{
   self.modelArray = [NSMutableArray array];
   NSArray<OptionalSymbol *> *sqliteArray = [OptionalSymbol MR_findAll];
   for (int i = 0; i<self.dataArray.count; i++) {
       QuotesTradingZoneModel *zoneModel = self.dataArray[i];
       if(sqliteArray.count>0){
           for (int j = 0; j<sqliteArray.count; j++) {
              OptionalSymbol *optionSymbol = sqliteArray[j];
              for (QuotesTransactionPairModel *pairModel in zoneModel.list) {
                  if([pairModel.market_id integerValue] == optionSymbol.marketID){
                      [self.modelArray addObject:pairModel];
                      self.sortAfterModelArray = self.modelArray;
                  }
              }
           }
       }else{//自选都删除后清空残存的旧数据
           self.sortAfterModelArray = self.modelArray;
       }
        
    }
    [self startSortData:self model:nil];
}

 -(WTTableView *)tableView{
     if(!_tableView){
         _tableView = [[WTTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.view.height - Height_NavBar - Height_TabBar) style:UITableViewStylePlain];
    //     _tableView.backgroundColor = self.view.backgroundColor;
          [_tableView setTheme_backgroundColor:THEME_MAIN_BACKGROUNDCOLOR];
         _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
         _tableView.delegate = self;
         _tableView.dataSource = self;
         _tableView.ly_emptyView = [LYEmptyView emptyActionViewWithImage:[UIImage imageNamed:@"balance_no_network_icon"] titleStr:@"" detailStr:@"" btnTitleStr:@"+ 添加自选" target:self action:@selector(addCustomChoose)];
         _tableView.ly_emptyView.contentViewOffset = -50; 
         _tableView.estimatedRowHeight = 100;
         _tableView.rowHeight = UITableViewAutomaticDimension;
     }
     return _tableView;
 }
  

@end
