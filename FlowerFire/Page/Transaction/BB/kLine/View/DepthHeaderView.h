//
//  CurrencyIntroductionCell.h
//  FireCoin
//
//  Created by 王涛 on 2019/6/5.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "BaseUIView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol DepthHeaderViewDelegate <NSObject>

-(void)didSwitchDeepthClick:(UIButton *)btn;

@end

@interface DepthHeaderView : BaseUIView

@property (nonatomic, strong) UIButton   *deepthBtn;
@property (nonatomic, strong) UIButton   *tradeBtn;
@property (nonatomic, strong) UIButton   *introductionBtn;
@property (nonatomic, strong) UIView     *line1,*line2,*line3;
@property (nonatomic, weak) id<DepthHeaderViewDelegate> deleagte;

/**
 开放出深度点击，用于切换交易对后重置页面


 */
-(void)deepthClick:(UIButton *)btn; 
-(void)tradeClick:(UIButton *)btn;
@end

NS_ASSUME_NONNULL_END
