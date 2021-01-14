//
//  LeftMenuViewController.m
//  FireCoin
//
//  Created by 王涛 on 2019/6/5.
//  Copyright © 2019 王涛. All rights reserved.
//  侧边滑出页面

#import "LeftMenuViewController.h"
#import "MJCSegmentInterface.h"
#import "LeftMenuPageVC.h"
#import "UIViewController+LeftSlide.h"
#import "QuotesTradingZoneModel.h"
#import "SHPolling.h"
#import <MagicalRecord/MagicalRecord.h>
#import "OptionalSymbol+CoreDataClass.h"

@interface LeftMenuViewController ()<MJCSegmentDelegate>
{
    UIView *headerBac;
    NSMutableArray<LeftMenuPageVC *> *pageArray;
    NSInteger pageIndex;
}
@property(nonatomic,strong)SHPolling *SHPollinga;
/**
 搜索的内容
 */
//@property(nonatomic, strong)NSString *searchStr;
@end

@implementation LeftMenuViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     
    if(!self.SHPollinga.runing){
        [self.SHPollinga start];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.SHPollinga pause];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.gk_navigationBar.hidden = YES;
    
    //TODO:暂用轮询请求
    __weak typeof(self) weakSelf = self;
    self.SHPollinga = [SHPolling pollingWithInterval:0 block:^(SHPolling *observer,SHPollingStatus pollingStatus) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(POLLIING_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [weakSelf initData];
            [observer next:pollingStatus];
        });
        
    }];
    
    // 添加从左划入的功能
   // [self initSlideFoundation];
    
    [self setUpView];
    [self initData];
    
}


#pragma mark - dataSource
-(void)initData{  //获取交易区
    [self.afnetWork jsonGetSocketDict:@"/api/market/getMarket" JsonDict:nil Tag:@"1"];
}

-(void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    NSMutableArray *titleArray = [NSMutableArray array];
    self.dataArray = [NSMutableArray array];
    for (NSDictionary *dic in dict[@"data"]) {
        if([dic[@"symbol"] isEqualToString:@"USDT"]){
            QuotesTradingZoneModel *model = [QuotesTradingZoneModel yy_modelWithDictionary:dic];
            [self.dataArray addObject:model];
            [titleArray addObject:dic[@"symbol"]];
            break;
        }
        
    }
    if(self.dataArray.count == 0){
        return;
    }
 
    if(pageArray.count == 0)
    {   //加上个自选
//        [titleArray insertObject:LocalizationKey(@"OptionalSymbolTip5") atIndex:0];
       [self setScrollSegementControl:titleArray];
//    }else{。
        LeftMenuPageVC *qvc = pageArray[pageIndex];
        QuotesTradingZoneModel *model;
//        if(pageIndex>0){
            model = self.dataArray[pageIndex];
            if([HelpManager isBlankString:qvc.searchField.text]){
                qvc.modelArray = model.list;
            }else{
                //  要求取出包含‘币名’的元素 [c]不区分大小写[d]不区分发音符号即没有重音符号[cd]既不区分大小写，也不区分发音符号。
                NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"from_symbol CONTAINS [cd] %@",qvc.searchField.text];
                qvc.modelArray = [model.list filteredArrayUsingPredicate:pred2];
            }
             
            @weakify(qvc)
            qvc.searchBlock = ^(NSString * _Nonnull searchStr) {
                @strongify(qvc)
                if([HelpManager isBlankString:searchStr]){
                    qvc.modelArray = model.list;
                }else{
                    NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"from_symbol CONTAINS [cd] %@",searchStr];
                    qvc.modelArray = [model.list filteredArrayUsingPredicate:pred2];
                }
            };
//        }else{  // 自选的数据
//               NSMutableArray *modelMutableArray = [NSMutableArray array];
//               NSArray<OptionalSymbol *> *sqliteArray = [OptionalSymbol MR_findAll];
//               for (int i = 0; i<self.dataArray.count; i++) {
//                   QuotesTradingZoneModel *zoneModel = self.dataArray[i];
//                   if(sqliteArray.count>0){
//                       for (int j = 0; j<sqliteArray.count; j++) {
//                          OptionalSymbol *optionSymbol = sqliteArray[j];
//                          for (QuotesTransactionPairModel *pairModel in zoneModel.list) {
//                              if([pairModel.market_id integerValue] == optionSymbol.marketID){
//                                  [modelMutableArray addObject:pairModel];
//                              }
//                          }
//                       }
//                   }
//                }
//            if([HelpManager isBlankString:qvc.searchField.text]){
//                qvc.modelArray = modelMutableArray;
//            }else{
//                //  要求取出包含‘币名’的元素 [c]不区分大小写[d]不区分发音符号即没有重音符号[cd]既不区分大小写，也不区分发音符号。
//                NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"from_symbol CONTAINS [cd] %@",qvc.searchField.text];
//                qvc.modelArray = [modelMutableArray filteredArrayUsingPredicate:pred2];
//            }
//
//            @weakify(qvc)
//            qvc.searchBlock = ^(NSString * _Nonnull searchStr) {
//                @strongify(qvc)
//                if([HelpManager isBlankString:searchStr]){
//                    qvc.modelArray = modelMutableArray;
//                }else{
//                    NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"from_symbol CONTAINS [cd] %@",searchStr];
//                    qvc.modelArray = [modelMutableArray filteredArrayUsingPredicate:pred2];
//                }
//            };
//        }
        
         
    }
}

#pragma mark - action
- (void)showFromLeft
{
    [self show];
  //  [self getData];
    if(!self.SHPollinga.runing){
        [self.SHPollinga start];
    }
}

-(void)hide{
    [super hide];
    [self.SHPollinga pause];
}

#pragma mark - ui
-(void)setUpView{
    self.view.backgroundColor = rgba(0, 0, 0, 0.5);

    headerBac = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth/3*2, 60+Height_StatusBar)];
  //  headerBac.backgroundColor = navBarColor;
    [headerBac setTheme_backgroundColor:THEME_CELL_BACKGROUNDCOLOR];
    [self.view addSubview:headerBac];
    
    self.topLabel = [UILabel new];
    self.topLabel.text = LocalizationKey(@"Exchange");
    self.topLabel.theme_textColor = THEME_TEXT_COLOR;
    self.topLabel.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
    self.topLabel.layer.masksToBounds = YES;
    self.topLabel.font = [UIFont boldSystemFontOfSize:30];
    [headerBac addSubview:self.topLabel];
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(headerBac.mas_centerY).offset(Height_StatusBar/2);
        make.left.mas_equalTo(headerBac.mas_left).offset(OverAllLeft_OR_RightSpace);
    }];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.backgroundColor = rgba(0, 0, 0, 0.5);
    closeBtn.frame = CGRectMake(CGRectGetMaxX(headerBac.frame), 0, ScreenWidth - CGRectGetMaxX(headerBac.frame), ScreenHeight);
    [self.view addSubview:closeBtn];
    [closeBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
}

-(void)setScrollSegementControl:(NSArray *)titlesArr{
    if(titlesArr.count == 0){
        return;
    }
    NSMutableArray *vcarrr = [NSMutableArray array];
    for (int i = 0 ; i<titlesArr.count; i++) {
        LeftMenuPageVC *lgp;
//        if(i == 0){
//            NSMutableArray *modelMutableArray = [NSMutableArray array];
//            lgp = [LeftMenuPageVC new];
//            NSArray<OptionalSymbol *> *sqliteArray = [OptionalSymbol MR_findAll];
//            for (int i = 0; i<self.dataArray.count; i++) {
//                QuotesTradingZoneModel *zoneModel = self.dataArray[i];
//                if(sqliteArray.count>0){
//                    for (int j = 0; j<sqliteArray.count; j++) {
//                       OptionalSymbol *optionSymbol = sqliteArray[j];
//                       for (QuotesTransactionPairModel *pairModel in zoneModel.list) {
//                           if([pairModel.market_id integerValue] == optionSymbol.marketID){
//                               [modelMutableArray addObject:pairModel];
//                           }
//                       }
//                    }
//                }else{//自选都删除后清空残存的旧数据
//
//                }
//             }
//           lgp.modelArray = modelMutableArray;
//        }else{
            lgp = [LeftMenuPageVC new];
            QuotesTradingZoneModel *model = self.dataArray[i];
            lgp.modelArray = model.list;
            
      //  }
        
        [vcarrr addObject:lgp];
      
        __weak typeof(self) weakSelf = self;
        lgp.backRefreshBlock = ^{
            [weakSelf hide];
            [weakSelf.SHPollinga pause];
        };
    }
    pageArray = vcarrr;
    if(vcarrr.count == 0){
        return;
    }
    
    
    [self setupBasicUIWithTitlesArr:titlesArr vcArr:vcarrr];
    
}

-(void)setupBasicUIWithTitlesArr:(NSArray*)titlesArr vcArr:(NSArray*)vcArr
{
    
    MJCSegmentStylesTools *tools = [MJCSegmentStylesTools jc_initWithSegmentStylestoolsBlock:^(MJCSegmentStylesTools *jc_tools) {
        jc_tools.
        jc_titlesViewBackColor(rgba(13, 27, 57, 1)).
        jc_titleBarStyles(MJCTitlesClassicStyle).
        jc_itemTextSelectedColor(MainColor).
        jc_itemTextNormalColor(rgba(108, 128, 142, 1)).
        jc_itemTextFontSize(18).
        jc_itemImageSize(CGSizeMake(25, 25)).
        jc_childScollEnabled(YES).
        jc_indicatorColor(MainColor).
        jc_indicatorFollowEnabled(YES).
     //   jc_childScollEnabled(NO).
        jc_indicatorStyles(MJCIndicatorEqualTextEffect);
    }];
    
    MJCSegmentInterface *interFace = [MJCSegmentInterface initWithFrame: CGRectMake(0,CGRectGetMaxY(headerBac.frame),ScreenWidth/3*2, self.view.jc_height- CGRectGetMaxY(headerBac.frame) ) interFaceStyletools:tools];
    interFace.delegate = self;
    
    [interFace intoTitlesArray:titlesArr intoChildControllerArray:vcArr hostController:self];
    
    [self.view addSubview:interFace];
    
}

-(void)mjc_ClickEventWithItem:(UIButton *)tabItem childsController:(UIViewController *)childsController segmentInterface:(MJCSegmentInterface *)segmentInterface{
    pageIndex = tabItem.tag;
  
}

-(void)mjc_scrollDidEndDeceleratingWithItem:(UIButton *)tabItem childsController:(UIViewController *)childsController indexPage:(NSInteger)indexPage segmentInterface:(MJCSegmentInterface *)segmentInterface{
    pageIndex = indexPage;
  
}

@end
