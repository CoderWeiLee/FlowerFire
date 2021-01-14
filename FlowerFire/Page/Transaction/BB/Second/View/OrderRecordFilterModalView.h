//
//  OrderRecordFilterModalVC.h
//  FireCoin
//
//  Created by 王涛 on 2019/6/25.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "BaseUIView.h"

NS_ASSUME_NONNULL_BEGIN

/**
 订单记录block
 
 @param paramsType 回调选中的订单类型
 @param paramsStatus 回调选中的订单状态
 */
typedef void(^OrderRecordFilterBlock)(NSString * paramsType,NSString * paramsStatus);


@interface OrderRecordFilterModalView : BaseUIView

@property (nonatomic, copy)  OrderRecordFilterBlock orderRecordFilterBlock;
@property (nonatomic, strong) UIView *mainView;

/**
 是否有了默认值，有直接是选中状态
 */
@property (nonatomic, strong) NSString *paramsType,*paramsStatus;
/**
 是否显示了
 */
@property (nonatomic, assign) BOOL   isShow;

-(void)showView:(UIViewController *)vc;

-(void)hideView;

@end 

NS_ASSUME_NONNULL_END
