//
//  QuotesChildFactoryViewController.h
//  FlowerFire
//
//  Created by 王涛 on 2020/4/29.
//  Copyright © 2020 Celery. All rights reserved.
//  工厂类
 
#import "QuotesSortProtocol.h"
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, quotesChildType) {
    quotesChildTypeChoose = 0,//自选
    quotesChildTypeAll, //全部
};

@interface QuotesChildVCFactory : BaseViewController<QuotesSortProtocol>

-(instancetype)initWithQutesType:(quotesChildType)qutesType;


-(void)netDateHandle:(NSArray *)titleArray;
- (void)netDateHandle:(NSArray *)titleArray withArray:(NSMutableArray *)array;

@end

NS_ASSUME_NONNULL_END
