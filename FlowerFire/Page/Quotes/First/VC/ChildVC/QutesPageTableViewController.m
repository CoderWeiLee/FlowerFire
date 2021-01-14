//
//  QutesPageTableViewController.m
//  FlowerFire
//
//  Created by 王涛 on 2020/4/29.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "QutesPageTableViewController.h"
#import "QuotesPageCell.h"
#import "QutesSortView.h"
#import "KLlineViewController.h"
#import "MainTabBarController.h"
#import "QuotesTradingZoneModel.h"

@interface QutesPageTableViewController ()<QutesSortViewDelegate,KLlineViewControllerDelegate>
{
    int _selectIndexName,_selectIndexPrice,_selectIndexChange;
}

@property(nonatomic, strong)QutesSortView *qutesSortView;
@end

@implementation QutesPageTableViewController

- (instancetype)initWithDataArray:(NSMutableArray *)dataArray{
    self = [super init];
    if(self){
        self.modelArray = dataArray;
    }
    return self;
}

- (void)setModelArray:(NSMutableArray *)modelArray{
    _modelArray = modelArray;
    [self.tableView reloadData];
}
  
- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self createNavBar];
    [self createUI];
    
    [self.tableView reloadData];

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
    !self.sortBlock ? : self.sortBlock(0,_selectIndexName);
    [self changeBtnImage:_selectIndexName btn:btn];
    [self changeBtnImage:0 btn:self.qutesSortView.sortBtn1];
    [self changeBtnImage:0 btn:self.qutesSortView.sortBtn2];
   
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
    !self.sortBlock ? : self.sortBlock(1,_selectIndexPrice);
    [self changeBtnImage:_selectIndexPrice btn:btn];
    [self changeBtnImage:0 btn:self.qutesSortView.sortBtn];
    [self changeBtnImage:0 btn:self.qutesSortView.sortBtn2];
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
    !self.sortBlock ? : self.sortBlock(2,_selectIndexChange);
    [self changeBtnImage:_selectIndexChange btn:btn];
    [self changeBtnImage:0 btn:self.qutesSortView.sortBtn1];
    [self changeBtnImage:0 btn:self.qutesSortView.sortBtn];
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
    self.tableView.bounces = NO;
    self.tableView.frame = CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight - Height_NavBar);
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
        if (model.list.count) {
            [cell setCellData:model.list[0]];

        }
            }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [[UniversalViewMethod sharedInstance] activationStatusCheck:self];
    
    QuotesTradingZoneModel *models = self.modelArray[indexPath.row];

   
    if( models.list.count > 0){

        QuotesTransactionPairModel *model =  models.list[0];
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

- (UIView *)listView {
    return self.view;
}

@end
