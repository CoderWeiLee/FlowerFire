//
//  MyOrderVC.h
//  FireCoin
//
//  Created by 王涛 on 2019/6/6.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    MyOrderPageWhereJumpBB,  //币币的委托单
    MyOrderPageWhereJumpFB, //法币的委托单
    MyOrderPageWhereJumpHome, //从首页进来
} MyOrderPageWhereJump;  //从哪里跳转到这里的


@interface MyOrderVC : BaseViewController

@property(nonatomic, assign)MyOrderPageWhereJump MyOrderPageWhereJump;
@end

NS_ASSUME_NONNULL_END
