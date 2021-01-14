//
//  HomeTableHeaderView.m
//  FlowerFire
//
//  Created by 王涛 on 2020/4/27.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "HomeTableHeaderView.h"
#import "SQCustomButton.h"
#import "TYCyclePagerView.h"
#import "TYCyclePagerViewCell.h"
#import "TYPageControl.h"
#import "WTWebViewController.h"
#import "HomeRealTimeMarketView.h"
#import "ChooseCoinTBVC.h"
#import "MyOrderPageTBVC.h"
#import "MoreApplicationViewController.h"
#import "HomeButtonModel.h"
#import "FFBuyRecordViewController.h"
#import "ScanCodeViewController.h"
#import "CollectionQRcodeViewController.h"
#import "DiZhuanZhangVVC.h"
#import "JiaoYiVC.h"
#import "MiningPollComputingPowerViewController.h"
@interface HomeTableHeaderView ()<TYCyclePagerViewDataSource,TYCyclePagerViewDelegate>
{
    
    TYPageControl   *_pageControl ;
    HomeRealTimeMarketView *_homeRealTimeMarketView;
    UIView          *_redLine,*_bottomLine;
    UILabel         *_24hChange;
    UILabel         *_coinKindTip,*_newPriceTip,*_24hChangTip;
    WTButton        *_quicklyBuyCoinButton;
}
@property(nonatomic, strong) NSMutableArray      *bannberInfoArray; //轮播图数组
@property(nonatomic, strong) TYCyclePagerView    *pagerView;  //轮播控件

@end

@implementation HomeTableHeaderView 

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
        [self layoutSubview];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SortHomeButtonNotice) name:SortHomeButtonNotice object:nil];
    }
    return self;
}

-(void)SortHomeButtonNotice{
    [self removeAllSubviews];
    [self createUI];
    [self layoutSubview];
}
 
- (NSArray *)getButtonViewData{
    NSMutableArray *buttonViewDataArray = [NSMutableArray array];
    
//    bool isFirstPlayApp = [[NSUserDefaults standardUserDefaults] objectForKey:@"isFirstPlayApp"];
//    if(!isFirstPlayApp){//是第一次玩app，是的话将默认按钮信息存进数据库 默认不是
//        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"isFirstPlayApp"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//
//        for (NSDictionary *dic in [self readLocalFileWithName:@"HomebuttonInfo"]) {
//            [buttonViewDataArray addObject:dic];
//        }
//        [[NSUserDefaults standardUserDefaults] setObject:buttonViewDataArray forKey:@"stuHomeBtns"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }
    /*
     
       {
           "buttonImageName":"委托",
           "buttonTitle":"homeButtonTip21",
           "viewControllerName":"FFBuyRecordViewController",
           "webView":"0",
           "buttonID":"4",
           "sortID":"4",
       },
     */
    for (NSDictionary *dic in [self readLocalFileWithName:@"HomebuttonInfo"]) {
        [buttonViewDataArray addObject:dic];
    }
    [[NSUserDefaults standardUserDefaults] setObject:buttonViewDataArray forKey:@"stuHomeBtns"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    buttonViewDataArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"stuHomeBtns"];

    /*
    NSDictionary *otherButtonDic;
    for (NSDictionary *dic in [self readLocalFileWithName:@"HomebuttonInfo"]) {
        if([dic[@"buttonID"] isEqualToString:@"9"]){
            otherButtonDic = dic;
        }
    }
    */
    
    if(buttonViewDataArray.count > 10){
        buttonViewDataArray = [buttonViewDataArray subarrayWithRange:NSMakeRange(0, 10)].mutableCopy;
//        [buttonViewDataArray replaceObjectAtIndex:9 withObject:otherButtonDic];
    }
    return buttonViewDataArray;
}

-(void)jumpVCHandle:(NSArray<HomeButtonModel*> *)dataArray currentIndex:(NSInteger)index{
    if(![WTUserInfo isLogIn]){
        [[WTPageRouterManager sharedInstance] jumpLoginViewController:[self viewController] isModalMode:YES whatProject:0];
        return;
    }
      
    NSInteger buttonId = [dataArray[index].buttonID integerValue];
    if(buttonId != 9){
        if (buttonId != 100) {
            [[UniversalViewMethod sharedInstance] activationStatusCheck:[self viewController]];

        }
}
    
    switch (buttonId) {
        case 0://充值 拼团
        {
            
            printAlert(LocalizationKey(@"homeButtonTip9"), 1.f);
            return;
            ChooseCoinTBVC *tvc = [[ChooseCoinTBVC alloc] initWithChooseCoinType:ChooseCoinTypeDeposit];
            [[self viewController].navigationController pushViewController:tvc animated:YES];
        }
            break;
        case 1:{
            // @property(nonatomic, strong)NSMutableArray<NoteModel *> *dataSource;
            MiningPollComputingPowerViewController *tvc = [[MiningPollComputingPowerViewController alloc] init];
            tvc.dataSource = _hornView.dataSource;
            [[self viewController].navigationController pushViewController:tvc animated:YES];
            
        }
            break;
        case 2://提币 DEFI
        {
            printAlert(LocalizationKey(@"homeButtonTip9"), 1.f);
            return;
            ChooseCoinTBVC *tvc = [[ChooseCoinTBVC alloc] initWithChooseCoinType:ChooseCoinTypeWithdraw];
            [[self viewController].navigationController pushViewController:tvc animated:YES];
        }
            break;
        case 4://委托
        {
            FFBuyRecordViewController *mvc = [[FFBuyRecordViewController alloc] initWithFFBuyRecordType:FFBuyRecordTypeCommission];
            [[self viewController].navigationController pushViewController:mvc animated:YES];
            break;
        }
        case 112://扫一扫
        {
          //  ScanCodeViewController *mvc = [ScanCodeViewController new];
            FFBuyRecordViewController *mvc = [[FFBuyRecordViewController alloc] initWithFFBuyRecordType:suo];
            [[self viewController].navigationController pushViewController:mvc animated:YES];
            break;
        }
        case 6://订单
        {
            FFBuyRecordViewController *mvc = [[FFBuyRecordViewController alloc] initWithFFBuyRecordType:FFBuyRecordTypeHidtoryRecord];
            [[self viewController].navigationController pushViewController:mvc animated:YES];
            break;
        }
        case 7://
        {
            FFBuyRecordViewController *mvc = [[FFBuyRecordViewController alloc] initWithFFBuyRecordType:FFBuyRecordTypeOrderRecord];
            [[self viewController].navigationController pushViewController:mvc animated:YES];
            
            break;
        }
        case 111://收款
        {
            
            CollectionQRcodeViewController *mvc = [CollectionQRcodeViewController new];
            [[self viewController].navigationController pushViewController:mvc animated:YES];
            break;;
        }
           
        case 100://地账户
        {
            DiZhuanZhangVVC *mvc = [[DiZhuanZhangVVC alloc] init];
            [[self viewController].navigationController pushViewController:mvc animated:YES];
            break;
        }
          
        case 8://社区
        {//@"http://www.unionexs.com/web/#/help/articlelist/1"
//            [[WTPageRouterManager sharedInstance] jumpToWebView:[self viewController].navigationController urlString:NSStringFormat(@"%@%@",BASE_URL,@"/web/#/help/articlelist/1")];
            JiaoYiVC *mvc = [[JiaoYiVC alloc] init];
            [[self viewController].navigationController pushViewController:mvc animated:YES];
            break;
        }
    
        default:
        {
            Class class = NSClassFromString(dataArray[index].viewControllerName);
            if(class){
                UIViewController *vc = [class new];
                [[self viewController].navigationController pushViewController:vc animated:true];
            }else{
                printAlert(LocalizationKey(@"homeButtonTip9"), 1.f);
            }
           
        }
            break;
    }
     
                
}

- (void)createUI{
    NSMutableArray<HomeButtonModel*> *dateArray = [NSMutableArray array];
    
    for (NSDictionary *dic in [self getButtonViewData]) {
        [dateArray addObject:[HomeButtonModel yy_modelWithDictionary:dic]];
    }
    
    UIView *lastButtonView;
    for (int i = 0; i<dateArray.count; i++) {
        long perRowItemCount = 5;
        
        CGFloat space = 15;
        long columnIndex = i % perRowItemCount;
        long rowIndex = i / perRowItemCount;
        CGFloat margin = 20;
        CGFloat itemW = (ScreenWidth - margin *4 - 15*2)/5;
        CGFloat itemH = itemW ;
        CGFloat bacWidth = space + columnIndex * (itemW + margin);
        CGFloat bacHeigth = rowIndex * (itemH + margin) + 20; //20 距顶部的距离
        
        SQCustomButton *button = [[SQCustomButton alloc] initWithFrame:CGRectMake(bacWidth, bacHeigth, itemW, itemH) type:SQCustomButtonTopImageType  imageSize:CGSizeMake(itemH/2, itemH/2) midmargin:10];
        button.imageView.image = [UIImage imageNamed:dateArray[i].buttonImageName];
        button.imageView.contentMode = UIViewContentModeScaleAspectFit;
        button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        button.titleLabel.text = LocalizationKey(dateArray[i].buttonTitle);
        @weakify(self)
        [button setTouchBlock:^(SQCustomButton * _Nonnull button) {
            @strongify(self)
            [self jumpVCHandle:dateArray currentIndex:i];
        }];
        [self addSubview:button];
        if(i == dateArray.count - 1){
            lastButtonView = button; //记录最后一个视图好做布局
        }
    }
    
    _quicklyBuyCoinButton = [[WTButton alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, lastButtonView.ly_maxY + 20, ScreenWidth - 2*OverAllLeft_OR_RightSpace, 0) buttonImage:nil parentView:self];
    _quicklyBuyCoinButton.hidden = YES;
    UIImage *image2 = [UIImage imageNamed:@"img31"];
    CGFloat top = 0; // 顶端盖高度
    CGFloat bottom = 0 ; // 底端盖高度
    CGFloat left = 0; // 左端盖宽度
    CGFloat right = 0; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    image2 = [image2 resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    [_quicklyBuyCoinButton setBackgroundImage:image2 forState:UIControlStateNormal];
    
    
    _hornView = [[HomeHornView alloc] initWithFrame:CGRectMake(0, _quicklyBuyCoinButton.ly_maxY , ScreenWidth, 40)];
    [self addSubview:_hornView];
   
    self.pagerView = [[TYCyclePagerView alloc]initWithFrame:CGRectMake(0, _hornView.ly_maxY+10, ScreenWidth - 0, 100)];
    self.pagerView.isInfiniteLoop = YES;
    self.pagerView.autoScrollInterval = 3.0;
    self.pagerView.dataSource = self;
    self.pagerView.delegate = self;
    [self.pagerView registerClass:[TYCyclePagerViewCell class] forCellWithReuseIdentifier:@"cellId"];
    [self addSubview:self.pagerView];
    [self.pagerView reloadData];
     
    _pageControl = [[TYPageControl alloc] initWithFrame: CGRectMake(0, CGRectGetHeight(_pagerView.frame) - 26, CGRectGetWidth(_pagerView.frame), 26)];
    _pageControl.currentPageIndicatorSize = CGSizeMake(15, 2.5);
    _pageControl.pageIndicatorSize = CGSizeMake(15, 2.5);
    _pageControl.pageIndicatorSpaing = 2;
    _pageControl.currentPageIndicatorTintColor = [UIColor cyanColor];
    _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    [_pagerView addSubview:_pageControl];
         
    _homeRealTimeMarketView = [[HomeRealTimeMarketView alloc] initWithFrame:CGRectMake(0, self.pagerView.ly_maxY+10, ScreenWidth, 0)];
    _homeRealTimeMarketView.hidden = YES;
    [self addSubview:_homeRealTimeMarketView];
    
    _redLine = [UIView new];
    _redLine.backgroundColor = MainColor;
    [self addSubview:_redLine];
    
    _24hChange = [UILabel new];
    _24hChange.font = [UIFont boldSystemFontOfSize:18];
    _24hChange.textColor = KBlackColor;
    _24hChange.text = LocalizationKey(@"homeTip5");
    [self addSubview:_24hChange];
    
    _coinKindTip = [self createTipLabel:@"homeTip6"];
    _newPriceTip = [self createTipLabel:@"homeTip7"];
    _newPriceTip.textAlignment = NSTextAlignmentCenter;
    _24hChangTip = [self createTipLabel:@"homeTip8"];
    _24hChangTip.textAlignment= NSTextAlignmentRight;
    
    _bottomLine = [UIView new];
    _bottomLine.theme_backgroundColor = THEME_LINE_TABLEVIEW_SEPARATOR_COLOR;
    [self addSubview:_bottomLine];
    
    
}

/**
 {
 "id": 1,
 "ad_position_id": 1,
 "ad_name": "首页幻灯片1",
 "ad_code": "index_slide",
 "ad_size": "900*400",
 "image": "http://t450.shangtua.com/uploads/20190708/e6f7410e21b5b264690620088bc2af79.png",
 "link": "http://www.baidu.com",
 "sort": 1,
 "status": 1,
 "addtime": 1562573719
 },
 */
-(void)setBanner:(NSArray *)bannerArray{
    if(bannerArray.count == 0){
        return;
    }
    self.bannberInfoArray = bannerArray.mutableCopy;
    
    NSMutableArray *imageArray = [NSMutableArray array];
    for (NSDictionary *dic in self.bannberInfoArray) {
        [imageArray addObject:dic[@"image"]];
    }
    _pageControl.numberOfPages = self.bannberInfoArray.count;
    
    [self.pagerView updateData];
    // _sdcyleScrollView.imageURLStringsGroup = imageArray;
}

#pragma mark - TYCyclePagerViewDataSource
- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView {
    if(self.bannberInfoArray.count > 0){
        return self.bannberInfoArray.count;
    }
    return 1;
}

- (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    TYCyclePagerViewCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndex:index];
    if(self.bannberInfoArray.count > 0){
       [cell.bannerImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.bannberInfoArray[index][@"image"]]] placeholderImage:[UIImage imageNamed:@"banner1"]];
    }
    return cell;
}

- (TYCyclePagerViewLayout *)layoutForPagerView:(TYCyclePagerView *)pageView {
    TYCyclePagerViewLayout *layout = [[TYCyclePagerViewLayout alloc]init];
    layout.itemSize = CGSizeMake(CGRectGetWidth(pageView.frame) - 30, CGRectGetHeight(pageView.frame));
    layout.itemSpacing = 5;
    layout.layoutType = TYCyclePagerTransformLayoutLinear;
    return layout;
}

- (void)pagerView:(TYCyclePagerView *)pageView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index{
    //578: 点击公告暂停访问 点击轮播图不用跳转（后台设置）；
    if(self.bannberInfoArray.count > 0){
        NSString *urlStr = self.bannberInfoArray[index][@"link"];
        if(![urlStr isEqualToString:@"#"]){
            [[WTPageRouterManager sharedInstance] jumpToWebView:[self viewController].navigationController urlString:urlStr];
        }
    }
}

- (void)pagerView:(TYCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    _pageControl.currentPage = toIndex;
}

#pragma mark - 布局
- (void)layoutSubview{
    _redLine.frame = CGRectMake(OverAllLeft_OR_RightSpace, _homeRealTimeMarketView.ly_maxY+OverAllLeft_OR_RightSpace, 2, 18);
    [_24hChange mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_redLine.mas_right).offset(3);
        make.centerY.mas_equalTo(_redLine);
    }];
    
    _coinKindTip.frame = CGRectMake(OverAllLeft_OR_RightSpace, _redLine.ly_maxY+OverAllLeft_OR_RightSpace, (ScreenWidth)/3 - 15, 16);
    _newPriceTip.frame = CGRectMake(_coinKindTip.ly_maxX, _redLine.ly_maxY+OverAllLeft_OR_RightSpace, (ScreenWidth)/3 , 16);
    [_24hChangTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_newPriceTip.mas_centerY);
        make.right.mas_equalTo(-OverAllLeft_OR_RightSpace);
    }];
    
    _bottomLine.frame = CGRectMake(0, _coinKindTip.ly_maxY+OverAllLeft_OR_RightSpace, ScreenWidth, 1);
    self.height = _bottomLine.ly_maxY;
}

#pragma mark - privateMethod
-(UILabel *)createTipLabel:(NSString *)LocalizationKey{
    UILabel *la = [UILabel new];
    la.font = tFont(12);
    la.text = LocalizationKey(LocalizationKey);
    la.textColor = [UIColor grayColor];
    [self addSubview:la];
    return la;
}

// 读取本地JSON文件
- (NSDictionary *)readLocalFileWithName:(NSString *)name {
    // 获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"json"];
    // 将文件数据化
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    // 对数据进行JSON格式化并返回字典形式
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

@end

////模型
//@interface headerButtonModel ()
//@end
//@implementation headerButtonModel
//@end
//
