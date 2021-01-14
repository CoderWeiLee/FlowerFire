//
//  SwitchPaymentMethodView.h
//  FireCoin
//
//  Created by 王涛 on 2019/5/29.
//  Copyright © 2019 王涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderRecordModel.h"
#import "BaseUIView.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    SwitchPaymentMethodTypeBank, //银行
    SwitchPaymentMethodTypeAliPay, //支付宝
    SwitchPaymentMethodTypeWeChat,  //微信
} SwitchPaymentMethodType;

 
@interface SwitchPaymentMethodView : BaseUIView

@property(nonatomic, assign) SwitchPaymentMethodType switchPaymentMethodType;
@property(nonatomic, strong) OrderRecordModel        *model; //几种支付方式
@property(nonatomic, strong) UIView                  *bottomView;

@property(nonatomic, strong) UIButton                *leftBtn,*rightBtn;
@property (nonatomic, copy)  backRefreshBlock         backRefreshBlock;

@end

NS_ASSUME_NONNULL_END
