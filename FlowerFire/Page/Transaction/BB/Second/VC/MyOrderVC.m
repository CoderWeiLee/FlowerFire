//
//  MyOrderVC.m
//  FireCoin
//
//  Created by 王涛 on 2019/6/6.
//  Copyright © 2019 王涛. All rights reserved.
//  我的委托单 (币币交易和法币交易共用)

#import "MyOrderVC.h"
#import "MJCSegmentInterface.h"
//#import <MJCSegmentInterface/MJCSegmentInterface.h>
#import "MyOrderPageTBVC.h"
#import "MyOrderFilterModalView.h"

@interface MyOrderVC ()<MJCSegmentDelegate>
{
    
}
@property(nonatomic, assign) MyOrderPageType         myOrderPageType;
@property(nonatomic, strong) MyOrderFilterModalView *myOrderFilterModalView;
@property(nonatomic, strong) MyOrderPageTBVC        *mvc;
@property(nonatomic, strong) MyOrderPageTBVC        *mvc1;
@end

@implementation MyOrderVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
  
    self.gk_navigationBar.hidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self setRightBarButtonItem];
    
    [self setScrollSegementControl:@[LocalizationKey(@"All commission"),LocalizationKey(@"Order History")]];
     
}
//重复设置，防止消失
-(void)setRightBarButtonItem{
    UIButton *fitterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [fitterBtn theme_setImage:@"global_filter_unselected" forState:UIControlStateNormal];
    [fitterBtn setFrame:CGRectMake(0, 0, 25, 25)];
    [fitterBtn addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:fitterBtn];
    self.gk_navigationItem.rightBarButtonItem = rightBtn;
    
}
#pragma mark - action
-(void)rightClick{
    if(self.myOrderFilterModalView.isShow){
        [self.myOrderFilterModalView hideView];
    }else{
        [self.myOrderFilterModalView showView:self];
       
    }
}

#pragma mark - MJCSegmentDelegate
-(void)mjc_ClickEventWithItem:(UIButton *)tabItem childsController:(UIViewController *)childsController segmentInterface:(MJCSegmentInterface *)segmentInterface{
    MyOrderPageTBVC *mvc = (MyOrderPageTBVC *)childsController;
    [mvc beginFresh];
    if(tabItem.tag == 0){
        self.myOrderFilterModalView.myOrderPageType =  MyOrderPageTypeAll;
    }else{
        self.myOrderFilterModalView.myOrderPageType =  MyOrderPageTypeHistory;
    }
    [self setRightBarButtonItem];
}

-(void)mjc_scrollDidEndDeceleratingWithItem:(UIButton *)tabItem childsController:(UIViewController *)childsController indexPage:(NSInteger)indexPage segmentInterface:(MJCSegmentInterface *)segmentInterface{
    MyOrderPageTBVC *mvc = (MyOrderPageTBVC *)childsController;
    [mvc beginFresh];
    if(tabItem.tag == 0){
        self.myOrderFilterModalView.myOrderPageType = MyOrderPageTypeAll;
    }else{
        self.myOrderFilterModalView.myOrderPageType = MyOrderPageTypeHistory;
    }
    [self setRightBarButtonItem];
}

#pragma mark - titleSegement
-(void)setScrollSegementControl:(NSArray *)titlesArr{
    NSMutableArray *vcarrr = [NSMutableArray array];
    self.mvc = [MyOrderPageTBVC new];
    self.mvc.myOrderPageType = MyOrderPageTypeAll;
    self.mvc.MyOrderPageWhereJump = self.MyOrderPageWhereJump;
    [vcarrr addObject:self.mvc];
    
    self.mvc1 = [MyOrderPageTBVC new];
    self.mvc1.myOrderPageType = MyOrderPageTypeHistory;
    self.mvc1.MyOrderPageWhereJump = self.MyOrderPageWhereJump;
    [vcarrr addObject:self.mvc1];
    [self setupBasicUIWithTitlesArr:titlesArr vcArr:vcarrr];
    
}

-(void)setupBasicUIWithTitlesArr:(NSArray*)titlesArr vcArr:(NSArray*)vcArr
{
    
    MJCSegmentStylesTools *tools = [MJCSegmentStylesTools jc_initWithSegmentStylestoolsBlock:^(MJCSegmentStylesTools *jc_tools) {
        jc_tools.
        jc_titlesViewBackColor(MainColor).
        jc_titleBarStyles(MJCTitlesClassicStyle).
        jc_itemTextSelectedColor(MainColor).
        jc_itemTextNormalColor(rgba(108, 128, 142, 1)).
        jc_itemTextFontSize(18).
        jc_itemImageSize(CGSizeMake(25, 25)).
        jc_childScollEnabled(YES).
        jc_indicatorColor(MainColor).
        jc_indicatorFollowEnabled(YES).
        jc_indicatorHidden(YES).
        jc_scaleLayoutEnabled(NO).
        jc_itemTextZoomEnabled(YES,25).
        jc_titlesViewFrame(CGRectMake(0, 0, ScreenWidth, 60)).
        jc_indicatorStyles(MJCIndicatorEqualTextEffect);
        
    }];
    
    MJCSegmentInterface *interFace = [MJCSegmentInterface initWithFrame: CGRectMake(0,Height_NavBar + 0,self.view.jc_width, self.view.jc_height- Height_NavBar) interFaceStyletools:tools];
    interFace.delegate = self;
    [self.view addSubview:interFace];
    
    [interFace intoTitlesArray:titlesArr intoChildControllerArray:vcArr hostController:self];
    
}

#pragma mark - ui
-(MyOrderFilterModalView *)myOrderFilterModalView{
    if(!_myOrderFilterModalView){
        _myOrderFilterModalView = [[MyOrderFilterModalView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _myOrderFilterModalView.paramsStatus = @"all";
        _myOrderFilterModalView.paramsType = @"all";
        @weakify(self)
        _myOrderFilterModalView.myOrderFilterBlock = ^(NSString * _Nonnull paramsType, NSString * _Nonnull paramsStatus) {
            @strongify(self)
            if(self.myOrderFilterModalView.myOrderPageType == MyOrderPageTypeAll){
                self.mvc.paramsType = paramsType;
                self.mvc.paramsStatus = @"0";
                [self.mvc beginFresh];
            }else{
                self.mvc1.paramsType = paramsType;
                self.mvc1.paramsStatus = paramsStatus;
                [self.mvc1 beginFresh];
            }
        };
    }
    return _myOrderFilterModalView;
}



@end
