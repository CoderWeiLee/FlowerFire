//
//  CurrencyTransactionLimitPriceView.h
//  FireCoin
//
//  Created by 王涛 on 2019/6/4.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "BaseUIView.h"
#import "StepSlider.h" 
NS_ASSUME_NONNULL_BEGIN

@interface CurrencyTransactionLimitPriceView : BaseUIView

@property(nonatomic, strong)UITextField *PriceTF;
@property(nonatomic, strong)UITextField *AmountTF;
@property(nonatomic, strong)UIButton    *buyBtn;
@property(nonatomic, strong)UILabel     *CNYPrice;
@property(nonatomic, strong)UILabel     *Useable; //可用
@property(nonatomic, strong)StepSlider  *slider; //滑杆
@property(nonatomic, strong)UILabel     *sliderMaxValue;
@property(nonatomic, strong)UILabel     *sliderNum;
@property(nonatomic, strong)UILabel     *TradeNumber;//交易额
@property(nonatomic, strong)UIStepper   *stepper;
@property(nonatomic, strong)NSString    *baseCoinName; //交易额后面的币名字


/// 钱包钱数
@property(nonatomic, strong) NSString   *moneyNum;

/**
 是否开售了
 */
@property(nonatomic, assign)BOOL isSell;


/**
 数量右侧的币名字
 */
@property (nonatomic, strong)UILabel *baseCoin;
/**
 汇率
 */
//@property(nonatomic, assign)double  exchangeRate;

@property(nonatomic, assign) int fromScale;     //交易对钱精确度(小数点后几位)
@property(nonatomic, assign) int toScale;       //交易对后精确度
@property(nonatomic, assign) int priceScale;     //价格精确度
@end

NS_ASSUME_NONNULL_END
