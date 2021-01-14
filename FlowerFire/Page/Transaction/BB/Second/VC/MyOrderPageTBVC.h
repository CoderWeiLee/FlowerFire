//
//  MyOrderPageTBVC.h
//  FireCoin
//
//  Created by 王涛 on 2019/6/6.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "BaseTableViewController.h"
#import "MyOrderVC.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    MyOrderPageTypeAll = 0,  //全部委托
    MyOrderPageTypeHistory, //历史记录
} MyOrderPageType;



@interface MyOrderPageTBVC : BaseTableViewController 
@property(nonatomic, assign)MyOrderPageType      myOrderPageType;
@property(nonatomic, assign)MyOrderPageWhereJump MyOrderPageWhereJump;

/**
 请求参数  all全部 0购买 1出售
 */
@property(nonatomic, strong)NSString *paramsType;

/**
 请求参数  all全部 -1已撤销 0挂售中 1已完成
 */
@property(nonatomic, strong)NSString *paramsStatus;


-(void)beginFresh;
@end

NS_ASSUME_NONNULL_END
