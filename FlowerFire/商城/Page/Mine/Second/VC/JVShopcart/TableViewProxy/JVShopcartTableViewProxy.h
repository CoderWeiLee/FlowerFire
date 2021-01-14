//
//  JVShopcartTableViewProxy.h
//  JVShopcart
//
//  Created by AVGD-Jarvi on 17/3/23.
//  Copyright © 2017年 AVGD-Jarvi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef void(^ShopcartProxyProductSelectBlock)(BOOL isSelected, NSIndexPath *indexPath,UIButton *productButton);
typedef void(^ShopcartProxyBrandSelectBlock)(BOOL isSelected, NSInteger section);
typedef void(^ShopcartProxyChangeCountBlock)(NSInteger count, NSIndexPath *indexPath);
typedef void(^ShopcartProxyDeleteBlock)(NSIndexPath *indexPath);
typedef void(^ShopcartProxyStarBlock)(NSIndexPath *indexPath);

typedef void(^ShopcartProxyDidSelectedRowBlock)(NSString *goodsID);

@interface JVShopcartTableViewProxy : NSObject <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, copy) ShopcartProxyProductSelectBlock shopcartProxyProductSelectBlock;
@property (nonatomic, copy) ShopcartProxyBrandSelectBlock shopcartProxyBrandSelectBlock;
@property (nonatomic, copy) ShopcartProxyChangeCountBlock shopcartProxyChangeCountBlock;
@property (nonatomic, copy) ShopcartProxyDeleteBlock shopcartProxyDeleteBlock;
@property (nonatomic, copy) ShopcartProxyStarBlock shopcartProxyStarBlock;
@property (nonatomic, copy) ShopcartProxyDidSelectedRowBlock shopcartProxyDidSelectedRowBlock;



@end
