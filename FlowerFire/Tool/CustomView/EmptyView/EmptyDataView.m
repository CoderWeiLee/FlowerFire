//
//  EmptyDataView.m
//  BaseDevelopmentFramework
//
//  Created by 王涛 on 2019/11/7.
//  Copyright © 2019 Celery. All rights reserved.
//

#import "EmptyDataView.h"

@implementation EmptyDataView

+ (instancetype)diyNoDataEmpty{
    return [EmptyDataView emptyViewWithImageStr:@"nodata"
                                    titleStr:@"暂无数据"
                                   detailStr:@"请检查您的网络连接是否正确!"];
}
+ (instancetype)diyNoNetworkEmptyWithTarget:(id)target action:(SEL)action{
    
    EmptyDataView *diy = [EmptyDataView emptyActionViewWithImageStr:@"noData"
                                                     titleStr:@"暂无数据"
                                                    detailStr:@"请检查你的网络连接是否正确!"
                                                  btnTitleStr:@"重新加载"
                                                       target:target
                                                       action:action];
    diy.autoShowEmptyView = NO;
    
    diy.imageSize = CGSizeMake(150, 150);
    
    return diy;
}

+ (instancetype)diyCustomEmptyViewWithTarget:(id)target action:(SEL)action{
    
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 80)];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    titleLab.font = [UIFont systemFontOfSize:16];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.text = LocalizationKey(@"noDataTip");
    titleLab.theme_textColor = THEME_TEXT_COLOR;
    [customView addSubview:titleLab];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(60, 50, 80, 30)];
    button.backgroundColor = MainColor;
    [button setTitle:LocalizationKey(@"noDataTip1") forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.layer.cornerRadius = 2;
    [customView addSubview:button];
     
    EmptyDataView *diy = [EmptyDataView emptyViewWithCustomView:customView];
    return diy;
}

- (void)prepare{
    [super prepare];
    
    self.subViewMargin = 20.f;
    
    self.titleLabFont = [UIFont systemFontOfSize:25];
    self.titleLabTextColor = [UIColor blackColor];
    
    self.detailLabFont = [UIFont systemFontOfSize:17];
    self.detailLabTextColor = [UIColor grayColor];
    self.detailLabMaxLines = 5;
    
    self.actionBtnBackGroundColor = rgba(90, 180, 160,1);
    self.actionBtnTitleColor = [UIColor whiteColor];
}
@end
