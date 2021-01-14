//
//  CFDeepView.h
//  CCLineChart
//
//  Created by ZM on 2018/9/13.
//  Copyright © 2018年 hexuren. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CFDeepView : UIView

/** 当前交易对 */
@property (nonatomic,strong) NSString *symbol;
/** 卖点数据 */
@property (nonatomic,strong) NSArray *sellDataArrOfPoint;
/** 买点数据 */
@property (nonatomic,strong) NSArray *buyDataArrOfPoint;

/** 卖点数据 价格 */
@property (nonatomic,strong) NSArray *sellDataArrOfPointPrice;
/** 买点数据 价格 */
@property (nonatomic,strong) NSArray *buyDataArrOfPointPrice;

/** Y轴坐标数据 */
@property (nonatomic, strong) NSArray *dataArrOfY;
/** X轴坐标数据 */
@property (nonatomic, strong) NSArray *dataArrOfX;
/**
 钱数币名
 */
@property (nonatomic, strong) NSString *priceCoinName;

@property(nonatomic, assign)int fromScale;     //交易对钱精确度(小数点后几位)
@property(nonatomic, assign)int toScale;         //交易对后精确度
@property(nonatomic, assign)int priceScale;     //价格精确度

@property (nonatomic, assign) double maxY;

- (void)deepViewTouchBlock:(void(^)(BOOL ifTouching))block;

@end
