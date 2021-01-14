//
//  KLineCell.m
//  FireCoin
//
//  Created by 王涛 on 2019/6/5.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "KLineCell.h"
#import "UIColor+Y_StockChart.h"


@interface KLineCell ()
{
    
}
@property(nonatomic, strong)UIView *line;
@end

@implementation KLineCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        self.btnArray = [NSMutableArray array];
        for (int i = 1; i<= 7; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = i;
            [self addSubview:btn];
            [btn setTitleColor:klineTypeSwitchBtnNormalTextColor forState:UIControlStateNormal];
            btn.titleLabel.font = tFont(14);
            if(i == 6){
                btn.tag = 10086;
            }else if(i == 7){
                btn.tag = 10087;
            }
            [self setBtnProperty:i Btn:btn];
            [self.btnArray addObject:btn];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        
        [self.btnArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:ScreenWidth/self.btnArray.count leadSpacing:0 tailSpacing:0];
        [self.btnArray mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(10);
            make.height.equalTo(@30);
        }];
        
        self.moreBtn = self.btnArray[5];
        
        UIImageView *subscript = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jiaobiao"]];
        [self.btnArray[5] addSubview:subscript];
        [subscript mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.btnArray[5].titleLabel.mas_bottom);
            make.right.mas_equalTo(self.btnArray[5].mas_right);
        }];
        
        UIImageView *subscript1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jiaobiao"]];
        [self.btnArray[6] addSubview:subscript1];
        [subscript1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.btnArray[6].titleLabel.mas_bottom);
            make.right.mas_equalTo(self.btnArray[6].mas_right);
        }];
        
        //初始化默认选中的K线类型
        NSNumber *defultTag = [[NSUserDefaults standardUserDefaults] objectForKey:defualtKlineType];
        if([defultTag intValue] == 0 || [defultTag intValue]>5){
            self.KlineCurrentBtn = (UIButton *)[self viewWithTag:2];
        }else{
            NSNumber *tag = [[NSUserDefaults standardUserDefaults] objectForKey:defualtKlineType];
            if([tag intValue]>5){
              //  [self moreView];
                self.KlineCurrentBtn = (UIButton *)[self viewWithTag:[tag intValue]];
            //    [self btnClick:(UIButton *)[self viewWithTag:[tag intValue]]];
            }else{
                self.KlineCurrentBtn = (UIButton *)[self viewWithTag:[tag intValue]];
            }
            
        }
         [self.KlineCurrentBtn setTitleColor:klineTypeSwitchBtnSelectedTextColor forState:UIControlStateNormal];
        
        //等待约束生效
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.KlineCurrentBtn.frame), self.KlineCurrentBtn.mj_w/2, 2)];
            self.line.centerX=self.KlineCurrentBtn.centerX;
            self.line.backgroundColor= klineTypeSwitchBtnSelectedTextColor;
            [self addSubview:self.line];
        });
        
        self.stockChartView.frame = CGRectMake(0, 50, ScreenWidth, 350);
        [self addSubview:self.stockChartView];
        [self.stockChartView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).offset(50);
            make.left.mas_equalTo(self.mas_left);
            make.size.mas_equalTo(CGSizeMake(ScreenWidth, 350));
            make.bottom.mas_equalTo(self.mas_bottom).offset(-10);
        }];
        
     //   [self addLinesView];
        [self sendSubviewToBack:self.contentView];
    }
    return self;
}

- (void)addLinesView {
    CGFloat whiteLine = self.stockChartView.bounds.size.height /4;
    CGFloat height = self.stockChartView.bounds.size.width /4;
    //横格
    for (int i = 0;i < 4;i++ ) {
        UIView *hengView = [[UIView alloc] initWithFrame:CGRectMake(0, whiteLine * (i + 1),self.stockChartView.bounds.size.width , 1)];
        hengView.backgroundColor = rgba(30, 43, 62, 1);
        [self.stockChartView addSubview:hengView];
        [self.stockChartView sendSubviewToBack:hengView];
    }
    //竖格
    for (int i = 0;i < 4;i++ ) {
        
        UIView *shuView = [[UIView alloc]initWithFrame:CGRectMake(height * (i + 1), 47, 1, self.stockChartView.bounds.size.height - 62)];
        shuView.backgroundColor = rgba(30, 43, 62, 1);
        [self.stockChartView addSubview:shuView];
        [self.stockChartView sendSubviewToBack:shuView];
    }
 
}

#pragma mark - action
-(void)btnClick:(UIButton *)sender{
    if (sender.tag!=10086&&sender.tag!=10087&&sender.tag!=100&&sender.tag!=101&&sender.tag!=102&&sender.tag!=103&&sender.tag!=104&&sender.tag!=105&&sender.tag!=106) {
        [self.KlineCurrentBtn setTitleColor:klineTypeSwitchBtnNormalTextColor forState:UIControlStateNormal];
        [sender setTitleColor:klineTypeSwitchBtnSelectedTextColor forState:UIControlStateNormal];
        self.KlineCurrentBtn=sender;
        [UIView animateWithDuration:0.2 animations:^{
            self.line.centerX=sender.centerX;
        }];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:sender.tag] forKey:defualtKlineType];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.KlineCurrentBtn = sender;
    }
    
    switch (sender.tag) {
        case 1:
        {
            self.moreView.hidden=YES;
            self.indView.hidden=YES;
            [self.moreBtn setTitleColor:klineTypeSwitchBtnNormalTextColor forState:UIControlStateNormal];
            [self.moreBtn setTitle:LocalizationKey(@"More") forState:UIControlStateNormal];
        } 
            break;
        case 2:
        {
            self.moreView.hidden=YES;
            self.indView.hidden=YES;
            [self.moreBtn setTitleColor:klineTypeSwitchBtnNormalTextColor forState:UIControlStateNormal];
            
            [self.moreBtn setTitle:LocalizationKey(@"More") forState:UIControlStateNormal];
        }
            break;
        case 3:
        {
            self.moreView.hidden=YES;
            self.indView.hidden=YES;
            [self.moreBtn setTitleColor:klineTypeSwitchBtnNormalTextColor forState:UIControlStateNormal];
         
            [self.moreBtn setTitle:LocalizationKey(@"More") forState:UIControlStateNormal];
        }
            break;
        case 4:
        {
            self.moreView.hidden=YES;
            self.indView.hidden=YES;
            [self.moreBtn setTitleColor:klineTypeSwitchBtnNormalTextColor forState:UIControlStateNormal];
        
            [self.moreBtn setTitle:LocalizationKey(@"More") forState:UIControlStateNormal];
        }
            break;
        case 5:
        {
            self.moreView.hidden=YES;
            self.indView.hidden=YES;
            [self.moreBtn setTitleColor:klineTypeSwitchBtnNormalTextColor forState:UIControlStateNormal];
       
            [self.moreBtn setTitle:LocalizationKey(@"More") forState:UIControlStateNormal];
        }
            break;
            
        case 6:
        {
            self.moreView.hidden=YES;
            self.indView.hidden=YES;
            [self.moreBtn setTitle:LocalizationKey(@"15min") forState:UIControlStateNormal];
            [self.moreBtn setTitleColor:klineTypeSwitchBtnSelectedTextColor forState:UIControlStateNormal];
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:sender.tag] forKey:defualtKlineType];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [UIView animateWithDuration:0.2 animations:^{
                self.line.centerX=self.moreBtn.centerX;
            }];
        }
            break;
        case 7:
        {
            self.moreView.hidden=YES;
            self.indView.hidden=YES;
            [self.moreBtn setTitle:LocalizationKey(@"30min")  forState:UIControlStateNormal];
            [self.moreBtn setTitleColor:klineTypeSwitchBtnSelectedTextColor forState:UIControlStateNormal];
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:sender.tag] forKey:defualtKlineType];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [UIView animateWithDuration:0.2 animations:^{
                self.line.centerX=self.moreBtn.centerX;
            }];
        }
            break;
        case 8:
        {
            self.moreView.hidden=YES;
            self.indView.hidden=YES;
            [self.moreBtn setTitle:LocalizationKey(@"1week")  forState:UIControlStateNormal];
            [self.moreBtn setTitleColor:klineTypeSwitchBtnSelectedTextColor forState:UIControlStateNormal];
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:sender.tag] forKey:defualtKlineType];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [UIView animateWithDuration:0.2 animations:^{
                self.line.centerX=self.moreBtn.centerX;
            }];
        }
            break;
        case 9:
        {
            self.moreView.hidden=YES;
            self.indView.hidden=YES;
            [self.moreBtn setTitle:LocalizationKey(@"1mon")  forState:UIControlStateNormal];
            [self.moreBtn setTitleColor:klineTypeSwitchBtnSelectedTextColor forState:UIControlStateNormal];
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:sender.tag] forKey:defualtKlineType];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [UIView animateWithDuration:0.2 animations:^{
                self.line.centerX=self.moreBtn.centerX;
            }];
        }
            break;
        case 100:
        case 101:
            self.moreView.hidden=YES;
            self.indView.hidden=YES;
            [self.subCurrentBtn setTitleColor:klineTypeSwitchBtnNormalTextColor forState:UIControlStateNormal];
            [sender setTitleColor:klineTypeSwitchBtnSelectedTextColor forState:UIControlStateNormal];
            self.subCurrentBtn=sender;
            break;
        case 102:
            [self.subCurrentBtn setTitleColor:klineTypeSwitchBtnNormalTextColor forState:UIControlStateNormal];
            [sender setTitleColor:klineTypeSwitchBtnNormalTextColor forState:UIControlStateNormal];
            break;
        case 103:
        case 104:
        case 105:
            self.moreView.hidden=YES;
            self.indView.hidden=YES;
            [self.mainCurrentBtn setTitleColor:klineTypeSwitchBtnNormalTextColor forState:UIControlStateNormal];
            [sender setTitleColor:klineTypeSwitchBtnSelectedTextColor forState:UIControlStateNormal];
            self.mainCurrentBtn=sender;
            break;
        case 106:
            [self.mainCurrentBtn setTitleColor:klineTypeSwitchBtnNormalTextColor forState:UIControlStateNormal];
            [sender setTitleColor:klineTypeSwitchBtnNormalTextColor forState:UIControlStateNormal];
            break;
        case 10086:
        {
            if (self.moreView.hidden) {
                self.moreView.hidden=NO;
            }else{
                self.moreView.hidden=YES;
            }
            self.indView.hidden=YES;
            return;
        }
            break;
        case 10087:
        {
            if (self.indView.hidden) {
                self.indView.hidden=NO;
            }else{
                self.indView.hidden=YES;
            }
            self.moreView.hidden=YES;
            return;
        }
            break;
        default:
            break;
    }
    NSDictionary *dict =[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInteger:sender.tag],@"buttonTag",nil];
    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}
     
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
     //   _stockChartView.backgroundColor = [UIColor orangeColor];
        NSNumber *defalutIndex = [[NSUserDefaults standardUserDefaults] objectForKey:defualtKlineType];
        
        if([defalutIndex intValue] == 0){
             _stockChartView.DefalutselectedIndex= 2;//默认显示1分钟K线图
        }else{
             _stockChartView.DefalutselectedIndex= [defalutIndex integerValue];
        }
    }
    return _stockChartView;
}

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
        case 100:  //102和106是隐藏
            [btn setTitle:@"MACD" forState:UIControlStateNormal];
            break;
        case 101:
            [btn setTitle:@"KDJ" forState:UIControlStateNormal];
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
        case 10086:
            [btn setTitle:LocalizationKey(@"More") forState:UIControlStateNormal];
          
            break;
        case 10087:
            [btn setTitle:LocalizationKey(@"Index") forState:UIControlStateNormal];
            break;
    }
}

#pragma mark - lazyInit
//更多视图
-(UIView *)moreView{
    if(!_moreView){
        _moreView = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.line.frame)+5, ScreenWidth - 20, 50)];
        _moreView.backgroundColor = self.backgroundColor;
        _moreView.layer.borderColor = [UIColor grayColor].CGColor;
        _moreView.layer.borderWidth = 1;
        [self addSubview:_moreView];
        self.btnArray1 = [NSMutableArray array];
        for (int i = 1; i<= 4; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = i + 5;
            [_moreView addSubview:btn];
            [btn setTitleColor:klineTypeSwitchBtnNormalTextColor forState:UIControlStateNormal];
            btn.titleLabel.font = tFont(16);
            [self setBtnProperty:i Btn:btn];
            [self.btnArray1 addObject:btn];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [self.btnArray1 mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:ScreenWidth/self.btnArray1.count leadSpacing:0 tailSpacing:0];
        [self.btnArray1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_moreView.mas_centerY).offset(0);
            make.height.equalTo(@30);
        }];
        _moreView.hidden = YES;
    }
    return _moreView;
}

-(UIView *)indView{
    if(!_indView){
        _indView = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.line.frame)+5, ScreenWidth - 20, 100)];
        _indView.backgroundColor = self.backgroundColor;
        _indView.layer.borderColor = [UIColor grayColor].CGColor;
        _indView.layer.borderWidth = 1;
        [self addSubview:_indView];
        
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _indView.mj_w, _indView.mj_h/2)];
        [_indView addSubview:topView];
        
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame), _indView.mj_w, _indView.mj_h/2)];
        [_indView addSubview:bottomView];
        
        UILabel *tip = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 50, 50)];
        tip.textColor = grayTextColor;
        tip.text = LocalizationKey(@"Main");
        tip.font = tFont(16);
        [topView addSubview:tip];
        
        self.btnArray2 = [NSMutableArray array];
        for (int i = 0; i< 3; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = i + 3 + 100;
            [topView addSubview:btn];
            btn.backgroundColor = self.backgroundColor;
            btn.titleLabel.layer.masksToBounds = YES;
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [btn setTitleColor:klineTypeSwitchBtnNormalTextColor forState:UIControlStateNormal];
            btn.titleLabel.font = tFont(16);
            [self setBtnProperty:i Btn:btn];
            [self.btnArray2 addObject:btn];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        self.mainCurrentBtn = self.btnArray2[0];
        
        [self.btnArray2 mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:(ScreenWidth- 100)/(self.btnArray2.count+1) leadSpacing:80 tailSpacing:(ScreenWidth- 100)/(self.btnArray2.count+1)];
        [self.btnArray2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(topView.mas_centerY).offset(0);
            make.height.equalTo(@30);
        }];
        
        tip = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 50, 50)];
        tip.textColor = grayTextColor;
        tip.text = LocalizationKey(@"Sub");
        tip.font = tFont(16);
        [bottomView addSubview:tip];
    
        self.btnArray3 = [NSMutableArray array];
        for (int i = 0; i< 2; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = i + 100;
            [bottomView addSubview:btn];
            btn.backgroundColor = self.backgroundColor;
            btn.titleLabel.layer.masksToBounds = YES;
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [btn setTitleColor:klineTypeSwitchBtnNormalTextColor forState:UIControlStateNormal];
            btn.titleLabel.font = tFont(16);
            [self setBtnProperty:i Btn:btn];
            [self.btnArray3 addObject:btn];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        self.subCurrentBtn = self.btnArray3[0];
        
        [self.btnArray3 mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:(ScreenWidth- 100)/(self.btnArray2.count+1) leadSpacing:80 tailSpacing:(ScreenWidth- 100)/(self.btnArray2.count+1)];
        [self.btnArray3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bottomView.mas_centerY).offset(0);
            make.height.equalTo(@30);
        }];
        
        UIButton *hideBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [hideBtn setTitle:LocalizationKey(@"close2") forState:UIControlStateNormal];
        hideBtn.tag = 106;
        hideBtn.titleLabel.font = tFont(16);
        [hideBtn setTitleColor:klineTypeSwitchBtnNormalTextColor forState:UIControlStateNormal];
        [topView addSubview:hideBtn];
        [hideBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(topView.mas_centerY);
            make.right.mas_equalTo(topView.mas_right);
            make.size.mas_equalTo(CGSizeMake((ScreenWidth - 100)/(self.btnArray2.count +1), 30));
        }];
        
        UIButton *hideBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [hideBtn1 setTitle:LocalizationKey(@"close2") forState:UIControlStateNormal];
        hideBtn1.tag = 102;
        hideBtn1.titleLabel.font = tFont(16);
        [hideBtn1 setTitleColor:klineTypeSwitchBtnNormalTextColor forState:UIControlStateNormal];
        [bottomView addSubview:hideBtn1];
        [hideBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(bottomView.mas_centerY);
            make.right.mas_equalTo(bottomView.mas_right);
            make.size.mas_equalTo(CGSizeMake((ScreenWidth - 100)/(self.btnArray2.count +1), 30));
        }];
        [hideBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [hideBtn1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _indView.hidden = YES;
    }
    return _indView;
}

@end

