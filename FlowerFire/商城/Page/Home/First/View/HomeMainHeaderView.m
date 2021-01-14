//
//  HomeMainHeaderView.m
//  531Mall
//
//  Created by 王涛 on 2020/5/18.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "HomeMainHeaderView.h"
#import <SDCycleScrollView/SDCycleScrollView.h> 
#import "UIImage+jianbianImage.h"
#import "SQCustomButton.h"
#import "LevelUpMemberViewController.h"
#import "MainMallTabBarController.h"
#import "ArticlesInfoViewController.h"
#import "MallHomeHornView.h"

static const NSInteger buttonNum = 8;
@interface HomeMainHeaderView ()<SDCycleScrollViewDelegate>
{

    SDCycleScrollView *_sdcycleScrollView;
    UIImageView       *_imageViewBac;
    MallHomeHornView  *_homeHornView;
    UIView            *_line,*_line2,*_line3;
    UILabel           *_tip;
    UIButton          *_levelUpMember;
    NSMutableArray<SQCustomButton*>              *_buttonArray;
}
@property(nonatomic, strong) NSMutableArray      *bannberInfoArray; //轮播图数组
@end

@implementation HomeMainHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
        [self layoutSubview];
        
        @weakify(self)
        [_levelUpMember addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            @strongify(self)
            if([WTMallUserInfo isLogIn]){
                if([NSStringFormat(@"%@",[WTMallUserInfo shareUserInfo].is_realname) isEqualToString:@"1"]){
                    if([NSStringFormat(@"%@",[WTMallUserInfo shareUserInfo].memberrank) isEqualToString:@"30"]){
                        printAlert(@"已是最高等级", 1.f);
                        return;
                    }
                    LevelUpMemberViewController *lvc = [LevelUpMemberViewController new];
                    [[self viewController].navigationController pushViewController:lvc animated:YES];
                }else{
                    NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:2];
                    md[@"userid"] = [WTMallUserInfo shareUserInfo].ID;
                    md[@"sessionid"] = [WTMallUserInfo shareUserInfo].sessionid;

                    [MBManager showLoading];
                    [[ReqestHelpManager share] requestMallPost:@"/api/member/memberInfo" andHeaderParam:md finish:^(NSDictionary *dicForData, ReqestType flag) {
                        [MBManager hideAlert];
                        @weakify(self)
                        if([dicForData[@"status"] integerValue] == 1){
                            @strongify(self)
                            WTMallUserInfo *userInfo = [WTMallUserInfo shareUserInfo];
                            userInfo.memberrank = dicForData[@"data"][@"memberrank"];
                            userInfo.is_realname = dicForData[@"data"][@"is_realname"];
                            [WTMallUserInfo saveUser:userInfo];
                             
                            if([NSStringFormat(@"%@",[WTMallUserInfo shareUserInfo].memberrank) isEqualToString:@"30"]){
                                printAlert(@"已是最高等级", 1.f);
                                return;
                            }
                            if([NSStringFormat(@"%@",[WTMallUserInfo shareUserInfo].is_realname) isEqualToString:@"1"]){
                                LevelUpMemberViewController *lvc = [LevelUpMemberViewController new];
                                [[self viewController].navigationController pushViewController:lvc animated:YES];
                            }else{
                                printAlert(@"升级会员需要完成实名认证", 1.f);
                            }
                        }else if([dicForData[@"status"] integerValue] == 9){
                            [WTMallUserInfo logout];
                        }
                        else{
                            printAlert(dicForData[@"msg"], 1.f);
                        }
                    }];
                }
            }else{
                [[WTPageRouterManager sharedInstance] jumpLoginViewController:[self viewController] isModalMode:YES whatProject:1];
            }
 
        }];
    }
    return self;
}

#pragma mark - dataSource
-(void)setBanner:(NSArray *)bannerArray{
    if(bannerArray.count == 0){
        return;
    }
    self.bannberInfoArray = bannerArray.mutableCopy;
    
    NSMutableArray *imageArray = [NSMutableArray array];
    for (NSString *imageStr in self.bannberInfoArray) {
        [imageArray addObject:imageStr];
    }
    
    _sdcycleScrollView.imageURLStringsGroup = imageArray;
}

- (void)setDataSource:(NSMutableArray<BulletinModel *> *)dataSource{
    [_homeHornView setDataSource:dataSource];
    [_homeHornView.marqueeView reloadData];
}

#pragma mark - sdcycleDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
}

- (void)createUI{
    _imageViewBac = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg1"]];
    _imageViewBac.frame = CGRectMake(0, 0, ScreenWidth, 250);
    _imageViewBac.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_imageViewBac]; 
    
    _homeNavtionView = [[HomeNavtionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44.5+Height_StatusBar)];
    [self addSubview:_homeNavtionView];
    
    _sdcycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(16, _homeNavtionView.ly_maxY + 8.5, ScreenWidth - 16 * 2, 158.5) delegate:self placeholderImage:nil];
    [self addSubview:_sdcycleScrollView];
    _sdcycleScrollView.layer.cornerRadius = 5;
    _sdcycleScrollView.backgroundColor = [UIColor clearColor];
   // _sdcycleScrollView.localizationImageNamesGroup = @[[UIImage imageNamed:@"组 22"],[UIImage imageNamed:@"组 22"]];
    _sdcycleScrollView.currentPageDotColor = MainColor;
    _sdcycleScrollView.pageDotColor = rgba(255, 221, 148, 1);
    _sdcycleScrollView.pageControlBottomOffset = - 25;
   // _sdcycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;

    _homeHornView = [[MallHomeHornView alloc] initWithFrame:CGRectMake(0, _imageViewBac.ly_maxY + 30, ScreenWidth , 25)];
    [self addSubview:_homeHornView];
        
    NSMutableArray<headerButtonModel*> *dateArray = [NSMutableArray arrayWithCapacity:buttonNum];
    _buttonArray = [NSMutableArray arrayWithCapacity:buttonNum];
    for (NSDictionary *dic in [self getButtonViewData]) {
        headerButtonModel *model = [headerButtonModel yy_modelWithDictionary:dic];
        [dateArray addObject:model];
    }
    
    for (int i = 0; i<dateArray.count; i++) {
        long perRowItemCount = buttonNum/2;
        
        CGFloat space = 15;
        long columnIndex = i % perRowItemCount;
        long rowIndex = i / perRowItemCount;
        CGFloat margin = 20;
        CGFloat itemW = (ScreenWidth - margin *3 - 15*2)/perRowItemCount;
        CGFloat itemH = itemW ;
        CGFloat bacWidth = space + columnIndex * (itemW + margin);
  
        CGFloat bacHeigth = rowIndex * (itemH + margin) + _homeHornView.ly_maxY + 25; //20 距顶部的距离
     
        SQCustomButton *button = [[SQCustomButton alloc] initWithFrame:CGRectMake(bacWidth, bacHeigth, itemW, itemH) type:SQCustomButtonTopImageType  imageSize:CGSizeMake(46, 46) midmargin:3];
        button.imageView.image = [UIImage imageNamed:dateArray[i].buttonImageName];
        button.titleLabel.text = dateArray[i].buttonTitle;
        button.titleLabel.font = tFont(13);
        button.titleLabel.textColor = rgba(51, 51, 51, 1);

        if(i == 0){
            [button setTouchBlock:^(SQCustomButton * _Nonnull button) { 
                [[NSNotificationCenter defaultCenter] postNotificationName:SelectedTabBarIndexNotice object:nil userInfo:@{@"index":@(1)}];
            }];
        }else{
            [button setTouchBlock:^(SQCustomButton * _Nonnull button) {
                printAlert(@"暂未开放", 1.f);
            }];
        }

        
        [self addSubview:button];
        [_buttonArray addObject:button];
    }
     
    _line = [UIView new];
    _line.backgroundColor = rgba(249, 249, 249, 1);
    [self addSubview:_line];
    
    _levelUpMember = [UIButton buttonWithType:UIButtonTypeCustom];
    [_levelUpMember setImage:[UIImage imageNamed:@"sj"] forState:UIControlStateNormal];
    _levelUpMember.adjustsImageWhenHighlighted = NO;
    [self addSubview:_levelUpMember];
    
    _line2 = [UIView new];
    _line2.backgroundColor = rgba(39, 36, 39, 1);
    [self addSubview:_line2];
    
    _tip = [UILabel new];
    _tip.textColor = rgba(39, 36, 39, 1);
    _tip.text = @"好物推荐";
    _tip.font = tFont(15);
    _tip.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_tip];
    
    _line3 = [UIView new];
    _line3.backgroundColor = rgba(39, 36, 39, 1);
    [self addSubview:_line3];
    
 
}

- (void)layoutSubview{
    _line.frame = CGRectMake(0, _buttonArray.lastObject.ly_maxY + 20, ScreenWidth, 8);
    _levelUpMember.frame = CGRectMake(OverAllLeft_OR_RightSpace, _line.ly_maxY+10, ScreenWidth - 2 * OverAllLeft_OR_RightSpace, 97);
    
    CGSize tipWidth = [HelpManager getLabelWidth:15 labelTxt:_tip.text];
    _tip.frame = CGRectMake(self.ly_centerX-tipWidth.width/2, _levelUpMember.ly_maxY + 25, tipWidth.width, 20);
      
    [_line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_tip.mas_left).offset(-6.5);
        make.centerY.mas_equalTo(_tip.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(70, 0.5));
    }];
    
    [_line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_tip.mas_right).offset(6.5);
        make.centerY.mas_equalTo(_tip.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(70, 0.5));
    }];
    [self layoutIfNeeded];
    NSLog(@"123:%f",ceil(_tip.ly_maxY+20));
}

- (void)setArticleDataArray:(NSMutableArray *)articleDataArray{
    _articleDataArray = articleDataArray;
      
    for (int i = 0; i<_articleDataArray.count; i++) {
        NSDictionary *dict = _articleDataArray[i];
        if(i == 9){
            break;
        }
        SQCustomButton *sqButton = _buttonArray[i+1];
        sqButton.titleLabel.text = dict[@"title"];
        [sqButton.imageView sd_setImageWithURL:[NSURL URLWithString:dict[@"thumb"]]];
        sqButton.imageView.layer.cornerRadius = sqButton.imageView.size.width/2;
        sqButton.imageView.layer.masksToBounds = YES;
        @weakify(self)
        [sqButton setTouchBlock:^(SQCustomButton * _Nonnull button) {
            @strongify(self)
            ArticlesInfoViewController *avc = [[ArticlesInfoViewController alloc] initWithArticlesID:dict[@"article_id"] articlesTitle:dict[@"title"]];
            [[self viewController].navigationController pushViewController:avc animated:YES];
        }];
    }
    
    
    
}

- (NSArray *)getButtonViewData{
    //读取按钮数据
    NSArray *array = @[@{@"buttonImageName":@"b1",@"buttonTitle":@"商城",@"viewControllerName":@"tabbar",@"webView":@"0"},
        @{@"buttonImageName":@"b2",@"buttonTitle":@"公司简介",@"viewControllerName":@"ViewController",@"webView":@"1"},
        @{@"buttonImageName":@"b3",@"buttonTitle":@"产品简介",@"viewControllerName":@"ViewController",@"webView":@"1"},
        @{@"buttonImageName":@"b4",@"buttonTitle":@"品牌简介",@"viewControllerName":@"ViewController",@"webView":@"1"},
        @{@"buttonImageName":@"b5",@"buttonTitle":@"招募简介",@"viewControllerName":@"ViewController",@"webView":@"1"},
        @{@"buttonImageName":@"b6",@"buttonTitle":@"推广模式",@"viewControllerName":@"ViewController",@"webView":@"1"},
        @{@"buttonImageName":@"b7",@"buttonTitle":@"抢购简介",@"viewControllerName":@"ViewController",@"webView":@"1"},
        @{@"buttonImageName":@"b8",@"buttonTitle":@"股权股份",@"viewControllerName":@"ViewController",@"webView":@"1"},
    ];
    
    return array;
}

+ (CGFloat)HomeMainHeaderHeight{
    return 330 + 20 + (ScreenWidth - 20 *3 - 15*2)/4*2 + 20 + 8 + 97 + 10 + 25 + 20 + 20;
}

@end

//模型
@interface headerButtonModel ()
@end
@implementation headerButtonModel
@end
