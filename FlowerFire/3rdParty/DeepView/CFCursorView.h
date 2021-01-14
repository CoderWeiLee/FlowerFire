//
//  CFCursorView.h
//  CCLineChart
//
//  Created by ZM on 2018/9/14.
//  Copyright © 2018年 hexuren. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CFCursorView : UIView

@property (nonatomic, assign) CGPoint selectedPoint;

@property (nonatomic, strong) NSDictionary *selectModel;

@property (nonatomic, strong) NSDictionary *priceModel;

@property (nonatomic, strong) NSString *symbol;

/**
 钱数币名
 */
@property (nonatomic, strong) NSString *priceCoinName;

@property(nonatomic, assign)int fromScale;     //交易对钱精确度(小数点后几位)
@property(nonatomic, assign)int toScale;         //交易对后精确度
@property(nonatomic, assign)int priceScale;     //价格精确度

@end
