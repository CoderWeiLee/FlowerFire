//
//  ReleaseOrderVC.m
//  FireCoin
//
//  Created by 王涛 on 2019/5/31.
//  Copyright © 2019 王涛. All rights reserved.
//  发布委托单

#import "ReleaseOrderVC.h"
#import "MJCSegmentInterface.h"
#import "ViewController.h"
#import "ReleaseWantBuyChildVC.h"

@interface ReleaseOrderVC ()

@end

@implementation ReleaseOrderVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.gk_navigationItem.title = LocalizationKey(@"Issue order");
    
     [self setScrollSegementControl:@[LocalizationKey(@"I want to buy"),LocalizationKey(@"I want to sell")]];
}

#pragma mark - titleSegement
-(void)setScrollSegementControl:(NSArray *)titlesArr{
    NSMutableArray *vcarrr = [NSMutableArray array];
    
    ReleaseWantBuyChildVC *vc = [ReleaseWantBuyChildVC new];
    vc.coinName = self.coinName;
    vc.coinId  = self.coinId;
    vc.netDic = self.netDic;
    vc.releaseWantBuyType = ReleaseWantBuyTypeBuy;
    [vcarrr addObject:vc];
    
    ReleaseWantBuyChildVC *vc1 = [ReleaseWantBuyChildVC new];  
    vc1.coinName = self.coinName;
    vc1.coinId  = self.coinId;
    vc1.netDic = self.netDic;
    vc1.releaseWantBuyType = ReleaseWantBuyTypeSale;
    [vcarrr addObject:vc1];
   
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
        jc_indicatorStyles(MJCIndicatorEqualTextEffect);
    }];
    
    MJCSegmentInterface *interFace = [MJCSegmentInterface initWithFrame: CGRectMake(0,Height_NavBar,self.view.jc_width, self.view.jc_height) interFaceStyletools:tools];
    
    [self.view addSubview:interFace];
    
//    UIView *xian = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(interFace.frame), ScreenWidth, 2)];
//    xian.backgroundColor = rgba(0, 15, 37, 1);
//    [interFace addSubview:xian];
//    
    [interFace intoTitlesArray:titlesArr intoChildControllerArray:vcArr hostController:self];
    
}



@end
