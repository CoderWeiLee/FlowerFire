//
//  HomeHornView.m
//  FlowerFire
//
//  Created by 王涛 on 2020/4/28.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "HomeHornView.h"
#import "WTWebViewController.h"
#import "AnnouncementViewController.h"

@interface HomeHornView ()<UUMarqueeViewDelegate>
{
    UIImageView *_marqueeImage;
    UILabel     *_moreTip;
    UIView      *_topLine,*_bottomLine;
    NSInteger    _hornCurrentIndex;
}

@end

@implementation HomeHornView
 
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
        [self layoutSubview];
    }
    return self;
}

- (void)createUI{
    _marqueeImage = [UIImageView new];
    _marqueeImage.theme_image = @"home_news_image";
    [self addSubview:_marqueeImage];
    
    self.marqueeView = [[UUMarqueeView alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace + 20 + 10, 0, ScreenWidth - OverAllLeft_OR_RightSpace *2 - 30 - 5, 20) direction:UUMarqueeViewDirectionUpward];
    self.marqueeView.delegate = self;
    self.marqueeView.timeIntervalPerScroll = 3.0f;    // 条目滑动间隔
    self.marqueeView.timeDurationPerScroll = 0.5f;    // 条目滑动时间
  //  self.marqueeView.touchEnabled = YES;    // 设置为YES可监听点击事件，默认值为NO
    [self addSubview:self.marqueeView];
         
    _topLine = [UIView new];
    _topLine.theme_backgroundColor = THEME_LINE_TABLEVIEW_SEPARATOR_COLOR;
    [self addSubview:_topLine];
    
    _bottomLine = [UIView new];
    _bottomLine.theme_backgroundColor = THEME_LINE_TABLEVIEW_SEPARATOR_COLOR;
    [self addSubview:_bottomLine];
    
    _moreTip = [UILabel new];
    _moreTip.theme_backgroundColor = THEME_MAIN_BACKGROUNDCOLOR;
    _moreTip.theme_textColor = THEME_GRAY_TEXTCOLOR;
    _moreTip.layer.masksToBounds = YES;
    _moreTip.text = LocalizationKey(@"homeTip2");
    _moreTip.font = tFont(13);
    [self addSubview:_moreTip];
      
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpWebView)]];
}

-(void)jumpWebView{
    [self didTouchItemViewAtIndex:_hornCurrentIndex forMarqueeView:self.marqueeView];
}

#pragma mark - UUMarqueeViewDelegate
- (NSUInteger)numberOfVisibleItemsForMarqueeView:(UUMarqueeView*)marqueeView {
    // 指定可视条目的行数，仅[UUMarqueeViewDirectionUpward]时被调用。
    // 当[UUMarqueeViewDirectionLeftward]时行数固定为1。
    return 1;
}

- (NSUInteger)numberOfDataForMarqueeView:(UUMarqueeView*)marqueeView {
    // 指定数据源的个数。例:数据源是字符串数组@[@"A", @"B", @"C"]时，return 3。
    return self.dataSource.count;
}

- (void)createItemView:(UIView*)itemView forMarqueeView:(UUMarqueeView*)marqueeView {
    // 在marquee view创建时（即'-(void)reloadData'调用后），用于创建条目视图的初始结构，可自行添加任意subview。
    // ### 给必要的subview添加tag，可在'-(void)updateItemView:withData:forMarqueeView:'调用时快捷获取并设置内容。
    UILabel *content = [[UILabel alloc] initWithFrame:itemView.bounds];
    content.font = [UIFont systemFontOfSize:13.0f];
    content.tag = 1001;
    content.textColor = [UIColor grayColor];
    [itemView addSubview:content];
}

- (void)updateItemView:(UIView*)itemView atIndex:(NSUInteger)index forMarqueeView:(UUMarqueeView*)marqueeView {
    // 设定即将显示的条目内容，在每次marquee view滑动时被调用。
    // 'index'即为数据源数组的索引值。
    if(self.dataSource.count >0){
  
        UILabel *content = [itemView viewWithTag:1001];
        content.text = self.dataSource[index].title;
    }
    _hornCurrentIndex = index;
}

- (CGFloat)itemViewWidthAtIndex:(NSUInteger)index forMarqueeView:(UUMarqueeView*)marqueeView {
    // 指定条目在显示数据源内容时的视图宽度，仅[UUMarqueeViewDirectionLeftward]时被调用。
    // ### 在数据源不变的情况下，宽度可以仅计算一次并缓存复用。
    UILabel *content;
    if(self.dataSource.count >0){
        content = [[UILabel alloc] init];
        content.font = [UIFont systemFontOfSize:13.0f];
        content.text = self.dataSource[index].title;
    }
    return content.intrinsicContentSize.width;
}

- (void)didTouchItemViewAtIndex:(NSUInteger)index forMarqueeView:(UUMarqueeView*)marqueeView {
    if(self.dataSource.count>0){
        AnnouncementViewController *avc =[AnnouncementViewController new];
        avc.dataArray = self.dataSource;
   
        [[self viewController].navigationController pushViewController:avc animated:YES];
    }

    return;
}

- (void)layoutSubview{
    _marqueeImage.frame = CGRectMake(OverAllLeft_OR_RightSpace, 10, 20, 20);
 
    [self.marqueeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_marqueeImage.mas_centerY);
        make.left.mas_equalTo(_marqueeImage.mas_right).offset(10);
        make.size.mas_equalTo(self.marqueeView.size);
    }];
    
    [_moreTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-OverAllLeft_OR_RightSpace);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
     
    _topLine.frame = CGRectMake(0, 0, ScreenWidth, 1);
    _bottomLine.frame = CGRectMake(0, self.height, ScreenWidth, 1);
}

@end
