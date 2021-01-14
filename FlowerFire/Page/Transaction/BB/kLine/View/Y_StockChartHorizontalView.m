//
//  Y_StockChartHorizontalView.m
//  FireCoin
//
//  Created by 王涛 on 2019/6/18.
//  Copyright © 2019 王涛. All rights reserved.
//  横版K线图视图

#import "Y_StockChartHorizontalView.h"

@interface Y_StockChartHorizontalView ()
{
    NSArray<UILabel *>  *masArray ;
    NSMutableArray<UIButton *> *btnArray,*btnArray1;
    
    UIButton            *_KlineCurrentBtn;//选中的K线种类
    UIButton            *_mainCurrentBtn;//选中的主图
    UIButton            *_subCurrentBtn;//选中的副图
}

@end

@implementation Y_StockChartHorizontalView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}

-(void)createView{
    self.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
    
    self.headerBac = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenHeight, 30)];
    self.headerBac.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
    [self addSubview:self.headerBac];
    
    self.symbolLabel = [UILabel new];
    self.symbolLabel.theme_textColor = THEME_TEXT_COLOR;
    self.symbolLabel.font = tFont(15);
    self.symbolLabel.text = @"--/--";
    self.symbolLabel.backgroundColor = self.backgroundColor;
    self.symbolLabel.layer.masksToBounds = YES;
    [self.headerBac addSubview:self.symbolLabel];
    
    self.PriceLabel = [UILabel new];
    self.PriceLabel.textColor = qutesRedColor;
    self.PriceLabel.font = tFont(16);
    self.PriceLabel.text = @"0.0000";
    self.PriceLabel.backgroundColor = self.backgroundColor;
    self.PriceLabel.layer.masksToBounds = YES;
    [self.headerBac addSubview:self.PriceLabel];
    
    self.changeLabel = [UILabel new];
    self.changeLabel.textColor = qutesRedColor;
    self.changeLabel.font = tFont(11);
    self.changeLabel.text = @"0.00%";
    self.changeLabel.backgroundColor = self.backgroundColor;
    self.changeLabel.layer.masksToBounds = YES;
    [self.headerBac addSubview:self.changeLabel];
    
    self.CNYLabel = [UILabel new];
    self.CNYLabel.textColor = grayTextColor;
    self.CNYLabel.font = tFont(12);
    self.CNYLabel.text = @"0.00%";
    self.CNYLabel.backgroundColor = self.backgroundColor;
    self.CNYLabel.layer.masksToBounds = YES;
    [self.headerBac addSubview:self.CNYLabel];
   
    
    masArray = @[self.symbolLabel,self.PriceLabel,self.changeLabel,self.CNYLabel];

    [masArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:(ScreenHeight/2 - 20)/masArray.count leadSpacing:20 tailSpacing:ScreenHeight/2];
    
    [masArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.height.mas_equalTo(@30);
    }];
    
    self.highLabel = [UILabel new];
    self.highLabel.textColor = grayTextColor;
    self.highLabel.font = tFont(10);
    self.highLabel.text = NSStringFormat(@"%@ 0.0000",LocalizationKey(@"H"));
    self.highLabel.backgroundColor = self.backgroundColor;
    self.highLabel.layer.masksToBounds = YES;
    [self.headerBac addSubview:self.highLabel];

    self.lowLabel = [UILabel new];
    self.lowLabel.textColor = grayTextColor;
    self.lowLabel.font = tFont(10);
    self.lowLabel.text = NSStringFormat(@"%@ 0.000",LocalizationKey(@"L"));
    self.lowLabel.backgroundColor = self.backgroundColor;
    self.lowLabel.layer.masksToBounds = YES;
    [self.headerBac addSubview:self.lowLabel];

    self.amountLabel = [UILabel new];
    self.amountLabel.textColor = grayTextColor;
    self.amountLabel.font = tFont(10);
    self.amountLabel.text = @"24H 0.0000";
    self.amountLabel.backgroundColor = self.backgroundColor;
    self.amountLabel.layer.masksToBounds = YES;
    [self.headerBac addSubview:self.amountLabel];
    
    
    self.symbolLabel.adjustsFontSizeToFitWidth = YES;
    self.PriceLabel.adjustsFontSizeToFitWidth = YES;
    self.changeLabel.adjustsFontSizeToFitWidth = YES;
    self.CNYLabel.adjustsFontSizeToFitWidth = YES;
    
    self.symbolLabel.textAlignment = NSTextAlignmentCenter;
    self.PriceLabel.textAlignment = NSTextAlignmentCenter;
    self.changeLabel.textAlignment = NSTextAlignmentCenter;
    self.CNYLabel.textAlignment = NSTextAlignmentCenter;
    self.highLabel.textAlignment = NSTextAlignmentCenter;
    self.lowLabel.textAlignment = NSTextAlignmentCenter;
    self.amountLabel.textAlignment = NSTextAlignmentCenter;
    
    self.masArray1 = [NSMutableArray arrayWithObjects:self.highLabel,self.lowLabel,self.amountLabel, nil]  ;
    
    [self.masArray1 mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:(ScreenHeight/2 - 55)/self.masArray1.count leadSpacing:ScreenHeight/2+10 tailSpacing:45];
    
    [self.masArray1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.height.mas_equalTo(@30);
    }];
    
    self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeBtn setImage:[UIImage imageNamed:@"closeImage"] forState:UIControlStateNormal];
    [self.headerBac addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.headerBac.mas_centerY);
        make.right.mas_equalTo(self.headerBac.mas_right).offset(-15);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [self.closeBtn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.mainView = [[UIView alloc] initWithFrame:CGRectMake(ScreenHeight - 55, CGRectGetMaxY(self.headerBac.frame)+5, 50, ScreenWidth - 70)];
    self.mainView.backgroundColor = self.backgroundColor;
    [self addSubview:self.mainView];
    
    btnArray = [NSMutableArray array];
    UIView *line;
    for (int i = 0 ; i<9; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = tFont(12);
        [btn setTitleColor:grayTextColor forState:UIControlStateNormal];
        [self.mainView addSubview:btn];
        [btnArray addObject:btn];
        
        if(i <5){
            btn.tag = 100 + i + 2;
        }else{
            btn.tag = 100 + i - 4-2;
        }
        
        //主图和副图点击忽略
        if(i == 0 || i == 5){
            btn.tag = 666+i;
        }
        
        if(i == 4){
            line = [UIView new];
            line.theme_backgroundColor = THEME_LINE_TABLEVIEW_SEPARATOR_COLOR;
            [self.mainView addSubview:line];
        }
        [self setBtnProperty:i Btn:btn];
        [btn addTarget:self action:@selector(mapClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [btnArray mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedItemLength:(ScreenWidth - 30 *2 - 10)/btnArray.count leadSpacing:0 tailSpacing:0];
    
    [btnArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-5);
        make.width.mas_equalTo(@50);
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(btnArray[4].mas_bottom);
        make.width.mas_equalTo(btnArray[4].mas_width);
        make.right.mas_equalTo(btnArray[4].mas_right);
        make.height.mas_equalTo(@1);
    }];
    
    btnArray1 = [NSMutableArray array];
    
    for (int i = 1; i<=8; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = tFont(13);
        [btn setTitleColor:grayTextColor forState:UIControlStateNormal];
        [self addSubview:btn];
        btn.backgroundColor = self.backgroundColor;
        btn.tag = i;
        [btnArray1 addObject:btn];
       
        if(i > 5){
            btn.tag = i + 2;
        }
        if(i == 8){
            self.moreBtn = btn;
             [btn addTarget:self action:@selector(moreClick) forControlEvents:UIControlEventTouchUpInside];
        }else{
             [btn addTarget:self action:@selector(KbtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        [self setBtnProperty:i Btn:btn];
    }
    
    [btnArray1 mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:(ScreenHeight-40)/btnArray1.count leadSpacing:20 tailSpacing:20];
    
    [btnArray1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom).offset(0);
        make.height.mas_equalTo(@30);
    }];
    
    self.stockChartView.backgroundColor = self.backgroundColor;
    
    //设置默认按钮
    _mainCurrentBtn = btnArray[1];
    [_mainCurrentBtn setTitleColor:klineTypeSwitchBtnSelectedTextColor forState:UIControlStateNormal];
    self.moreView.hidden = YES;
}
//更多点击
-(void)moreClick{
    self.moreView.hidden=!self.moreView.hidden;
}

//k线菜单
-(void)KbtnClick:(UIButton *)sender{
    [_KlineCurrentBtn setTitleColor:klineTypeSwitchBtnNormalTextColor forState:UIControlStateNormal];
    [sender setTitleColor:klineTypeSwitchBtnSelectedTextColor forState:UIControlStateNormal];
    _KlineCurrentBtn=sender;
    [UIView animateWithDuration:0.2 animations:^{
        self.klineView.centerX=sender.centerX;
    }];
    
    switch (sender.tag) {
        case 1:
            [self.moreBtn setTitleColor:klineTypeSwitchBtnNormalTextColor forState:UIControlStateNormal];
            [self.moreBtn setTitle:LocalizationKey(@"More") forState:UIControlStateNormal];
            break;
        case 2:
            [self.moreBtn setTitleColor:klineTypeSwitchBtnNormalTextColor forState:UIControlStateNormal];
            [self.moreBtn setTitle:LocalizationKey(@"More") forState:UIControlStateNormal];
            break;
        case 3:
            [self.moreBtn setTitleColor:klineTypeSwitchBtnNormalTextColor forState:UIControlStateNormal];
            [self.moreBtn setTitle:LocalizationKey(@"More") forState:UIControlStateNormal];
            break;
        case 4:
            [self.moreBtn setTitleColor:klineTypeSwitchBtnNormalTextColor forState:UIControlStateNormal];
            [self.moreBtn setTitle:LocalizationKey(@"More") forState:UIControlStateNormal];
            break;
        case 5:
            [self.moreBtn setTitleColor:klineTypeSwitchBtnNormalTextColor forState:UIControlStateNormal];
            [self.moreBtn setTitle:LocalizationKey(@"More") forState:UIControlStateNormal];
            break;
        case 6:
        {
            [self.moreBtn setTitle:LocalizationKey(@"15min") forState:UIControlStateNormal];
            [self.moreBtn setTitleColor:klineTypeSwitchBtnSelectedTextColor forState:UIControlStateNormal];
            [UIView animateWithDuration:0.2 animations:^{
                self.klineView.centerX=self.moreBtn.centerX;
            }];
        }
            break;
        case 7:
        {
            [self.moreBtn setTitle:LocalizationKey(@"30min") forState:UIControlStateNormal];
            [self.moreBtn setTitleColor:klineTypeSwitchBtnSelectedTextColor forState:UIControlStateNormal];
            [UIView animateWithDuration:0.2 animations:^{
                self.klineView.centerX=self.moreBtn.centerX;
            }];
        }
            break;
        case 8:
            [self.moreBtn setTitleColor:klineTypeSwitchBtnNormalTextColor forState:UIControlStateNormal];
            [self.moreBtn setTitle:LocalizationKey(@"More") forState:UIControlStateNormal];
            break;
        case 9:
            [self.moreBtn setTitleColor:klineTypeSwitchBtnNormalTextColor forState:UIControlStateNormal];
            [self.moreBtn setTitle:LocalizationKey(@"More") forState:UIControlStateNormal];
            break;
    }
    
    self.moreView.hidden=YES;
    NSDictionary *dict =[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInteger:sender.tag],@"buttonTag",nil];
    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

#pragma mark - netData
-(void)setModel:(QuotesTransactionPairModel *)model{
    _model = model;
    self.PriceLabel.text = [ToolUtil stringFromNumber:[model.New_price doubleValue] withlimit:model.dec];
    NSString*cnyRate= [((AppDelegate*)[UIApplication sharedApplication].delegate).CNYRate stringValue];
    self.CNYLabel.text = [NSString stringWithFormat:@"≈%.2f CNY",[self.PriceLabel.text doubleValue]*[cnyRate doubleValue]*1];
    double change = [model.change doubleValue];
    
    if (change <0) {
        self.changeLabel.textColor = qutesRedColor;
        self.changeLabel.text = [NSString stringWithFormat:@"%.2f%%", change];
    }else if (change >0) {
        self.changeLabel.textColor = qutesGreenColor;
        self.changeLabel.text = [NSString stringWithFormat:@"+%.2f%%", change];
    }else{
        self.changeLabel.textColor = qutesRedColor;
        self.changeLabel.text = @"0.00%";
    }
    
    self.highLabel.text =  [NSString stringWithFormat:@"%@ %@",LocalizationKey(@"H"),[ToolUtil stringFromNumber:[model.high_price doubleValue] withlimit:model.dec]];
    self.lowLabel.text = [NSString stringWithFormat:@"%@ %@",LocalizationKey(@"L"),[ToolUtil stringFromNumber:[model.low_price doubleValue] withlimit:model.dec]];
    self.amountLabel.text =[NSString stringWithFormat:@"24H %@",model.deal_amount_24h];
}

- (void)setY_KLineModel:(Y_KLineModel *)Y_KLineModel{
    self.PriceLabel.text = NSStringFormat(@"$%f",(Y_KLineModel.High.doubleValue + Y_KLineModel.Low.doubleValue)/2);
    self.CNYLabel.hidden = YES;
    //    double change = [model.change doubleValue];
    //
    //    if (change <0) {
    //        self.changeLabel.textColor = qutesRedColor;
    //        self.changeLabel.text = [NSString stringWithFormat:@"%.2f%%", change];
    //    }else if (change >0) {
    self.changeLabel.textColor = qutesGreenColor;
    self.changeLabel.text = [NSString stringWithFormat:@"+%@%%", @"0.12"];
    //    }else{
    //        self.changeLabel.textColor = qutesRedColor;
    //        self.changeLabel.text = @"0.00%";
    //    }
    
    self.highLabel.text = NSStringFormat(@"%@ %@",LocalizationKey(@"H"),Y_KLineModel.High);
    self.lowLabel.text = NSStringFormat(@"%@ %@",LocalizationKey(@"L"),Y_KLineModel.Low); 
    self.amountLabel.text = NSStringFormat(@"%@ %f",LocalizationKey(@"Executed"),Y_KLineModel.Volume);
}

#pragma mark - action
-(void)mapClick:(UIButton *)sender{
    if(sender.tag>102 && sender.tag<=106){
        if (sender.tag==106) {//隐藏
            [_mainCurrentBtn setTitleColor:klineTypeSwitchBtnNormalTextColor forState:UIControlStateNormal];
            [sender setTitleColor:klineTypeSwitchBtnNormalTextColor forState:UIControlStateNormal];
        }else{
            [_mainCurrentBtn setTitleColor:klineTypeSwitchBtnNormalTextColor forState:UIControlStateNormal];
            [sender setTitleColor:klineTypeSwitchBtnSelectedTextColor forState:UIControlStateNormal];
            _mainCurrentBtn=sender;
        }
    }else{
        if (sender.tag==102) {//隐藏
            [_subCurrentBtn setTitleColor:klineTypeSwitchBtnNormalTextColor forState:UIControlStateNormal];
            [sender setTitleColor:klineTypeSwitchBtnNormalTextColor forState:UIControlStateNormal];
        }else{
            [_subCurrentBtn setTitleColor:klineTypeSwitchBtnNormalTextColor forState:UIControlStateNormal];
            [sender setTitleColor:klineTypeSwitchBtnSelectedTextColor forState:UIControlStateNormal];
            _subCurrentBtn=sender;
        }
    }
   
    NSDictionary *dict =[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInteger:sender.tag],@"buttonTag",nil];
    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

-(void)closeClick{
    if([self.delegate respondsToSelector:@selector(dismiss)]){
        [self.delegate dismiss];
    }
}
#pragma mark - util
-(void)setBtnProperty:(int)index Btn:(UIButton *)btn{
    switch (btn.tag) {
        case 1:
            [btn setTitle:LocalizationKey(@"Line") forState:UIControlStateNormal];
            break;
        case 2:
            [btn setTitle:LocalizationKey(@"1min") forState:UIControlStateNormal];
            break;
        case 3:
            [btn setTitle:LocalizationKey(@"5min") forState:UIControlStateNormal];
            break;
        case 4:
            [btn setTitle:LocalizationKey(@"1hour") forState:UIControlStateNormal];
            break;
        case 5:
            [btn setTitle:LocalizationKey(@"1day") forState:UIControlStateNormal];
            break;
        case 6:
            [btn setTitle:LocalizationKey(@"15min") forState:UIControlStateNormal];
            break;
        case 7:
            [btn setTitle:LocalizationKey(@"30min") forState:UIControlStateNormal];
            break;
        case 8:
            [btn setTitle:LocalizationKey(@"1week") forState:UIControlStateNormal];
            break;
        case 9:
            [btn setTitle:LocalizationKey(@"1mon") forState:UIControlStateNormal];
            break;
        case 10:
            [btn setTitle:LocalizationKey(@"More") forState:UIControlStateNormal];
            break;
        case 666:
            [btn setTitle:LocalizationKey(@"Main") forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont fontWithName:@"PingFang SC" size:13];
            [btn setTitleColor:MainBlueColor forState:UIControlStateNormal];
            break;
        case 103:
            [btn setTitle:@"MA" forState:UIControlStateNormal];
            break;
        case 104:
            [btn setTitle:@"EMA" forState:UIControlStateNormal];
            break;
        case 105:
            [btn setTitle:@"BOLL" forState:UIControlStateNormal];
            break;
        case 106:
            [btn setTitle:LocalizationKey(@"close2") forState:UIControlStateNormal];
            break;
        case 671:
            [btn setTitle:LocalizationKey(@"Sub") forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont fontWithName:@"PingFang SC" size:13];
            [btn setTitleColor:MainBlueColor forState:UIControlStateNormal];
            break;
        case 100:
            [btn setTitle:@"MACD" forState:UIControlStateNormal];
            break;
        case 101:
            [btn setTitle:@"KDJ" forState:UIControlStateNormal];
            break;
        case 102:
            [btn setTitle:LocalizationKey(@"close2") forState:UIControlStateNormal];
            break;
    }
}



#pragma mark - lazyInit
- (Y_StockChartView *)stockChartView
{
    if(!_stockChartView) {
        _stockChartView = [Y_StockChartView new];
        _stockChartView.itemModels = @[
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"指标" type:Y_StockChartcenterViewTypeOther],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"分时" type:Y_StockChartcenterViewTypeTimeLine],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"1分" type:Y_StockChartcenterViewTypeKline],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"5分" type:Y_StockChartcenterViewTypeKline],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"1小时" type:Y_StockChartcenterViewTypeKline],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"1天" type:Y_StockChartcenterViewTypeKline],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"15分" type:Y_StockChartcenterViewTypeKline],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"30分钟" type:Y_StockChartcenterViewTypeKline],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"1周" type:Y_StockChartcenterViewTypeKline],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"1月" type:Y_StockChartcenterViewTypeKline],
                                       ];
       
       // _stockChartView.DefalutselectedIndex=1;
        [self addSubview:_stockChartView];
        [_stockChartView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (IS_IPHONE_X) {
                make.edges.equalTo(self).insets(UIEdgeInsetsMake(30, 24, 31.5, 60));
            } else {
                make.edges.equalTo(self).insets(UIEdgeInsetsMake(30, 0, 31.5, 60));;
            }
        }];
      
    }
    return _stockChartView;
}

-(UIView *)moreView{
    if(!_moreView){
        _moreView = [[UIView alloc] init];
        _moreView.backgroundColor = self.backgroundColor;
        [self addSubview:_moreView];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 6;
        [self setBtnProperty:0 Btn:btn];
        btn.titleLabel.font = tFont(13);
        [btn setTitleColor:grayTextColor forState:UIControlStateNormal];
        [_moreView addSubview:btn];
        [btn addTarget:self action:@selector(KbtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_moreView.mas_left).offset(0);
            make.centerY.mas_equalTo(_moreView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake((ScreenHeight-40)/8, 30));
        }];
        
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn1.tag = 7;
        [self setBtnProperty:0 Btn:btn1];
        btn1.titleLabel.font = tFont(13);
        [btn1 setTitleColor:grayTextColor forState:UIControlStateNormal];
        [_moreView addSubview:btn1];
        [btn1 addTarget:self action:@selector(KbtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(btn.mas_right).offset(0);
            make.centerY.mas_equalTo(_moreView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake((ScreenHeight-40)/8, 30));
        }];
    }
    return _moreView;
}

-(void)setCurrentIndex:(NSInteger)currentIndex{
    _currentIndex = currentIndex;
    
    if(currentIndex == 6 || currentIndex == 7){
        _KlineCurrentBtn = (UIButton *)[self viewWithTag:currentIndex];
    }else{
        if(currentIndex>5){
            _KlineCurrentBtn = btnArray1[currentIndex - 1 - 2];
        }else{
            _KlineCurrentBtn = btnArray1[currentIndex - 1];
        }
    }
    
    [_KlineCurrentBtn setTitleColor:klineTypeSwitchBtnSelectedTextColor forState:UIControlStateNormal];
    
    //等待约束生效
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self KbtnClick:self->_KlineCurrentBtn];
    });
    
    self.klineView=[[UIView alloc]initWithFrame:CGRectMake(0, ScreenWidth-2, ((ScreenHeight-40)/btnArray1.count)/4, 2)];
    self.klineView.centerX=btnArray1[0].centerX;
    self.klineView.backgroundColor=klineTypeSwitchBtnSelectedTextColor;
    [self addSubview:self.klineView];
    
    [self.moreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(btnArray1[0].mas_top);
        make.left.mas_equalTo(self.mas_left).offset(OverAllLeft_OR_RightSpace);
        make.size.mas_equalTo(CGSizeMake(ScreenHeight - 40, 30));
    }];
}

@end
