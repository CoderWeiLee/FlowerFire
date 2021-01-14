//
//  DepthSectionOneHeaderView.m
//  FireCoin
//
//  Created by 王涛 on 2019/6/6.
//  Copyright © 2019 王涛. All rights reserved.
//  section1的深度头部

#import "DepthSectionOneHeaderView.h"

@interface DepthSectionOneHeaderView ()


@end

@implementation DepthSectionOneHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        
        UIView *line = [UIView new];
        line.theme_backgroundColor = THEME_LINE_TABLEVIEW_SEPARATOR_COLOR;
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top);
            make.left.mas_equalTo(self.mas_left);
            make.size.mas_equalTo(CGSizeMake(ScreenWidth, 1));
        }];
        
        UIView *depthView = [UIView new];
        depthView.backgroundColor = self.backgroundColor;
       // [depthView setTheme_backgroundColor:THEME_NAVBAR_BACKGROUNDCOLOR];
        [self addSubview:depthView];
        [depthView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(line.mas_bottom);
            make.left.mas_equalTo(self.mas_left);
            make.size.mas_equalTo(CGSizeMake(ScreenWidth, 230));
        }];
        
        [depthView addSubview:self.klineDeepView];
       
        UIButton *buyTip = [UIButton buttonWithType:UIButtonTypeCustom];
        [buyTip setTitle:LocalizationKey(@"BuyHandicap") forState:UIControlStateNormal];
        [buyTip setTitleColor:ContractDarkBlueColor forState:UIControlStateNormal];
        [buyTip setImage:[UIImage imageNamed:@"green_square"] forState:UIControlStateNormal];
        buyTip.titleLabel.font = tFont(13);
        buyTip.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 5);
        [depthView addSubview:buyTip];
        [buyTip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(depthView.mas_centerX).offset(-7.5);
            make.top.mas_equalTo(depthView.mas_top).offset(20);
        }];
        buyTip.titleLabel.layer.masksToBounds = YES;
        buyTip.titleLabel.backgroundColor = self.backgroundColor;
        [buyTip sizeToFit];
        
        UIButton *saleTip = [UIButton buttonWithType:UIButtonTypeCustom];
        [saleTip setTitle:LocalizationKey(@"SellHandicap") forState:UIControlStateNormal];
        [saleTip setTitleColor:ContractDarkBlueColor forState:UIControlStateNormal];
        [saleTip setImage:[UIImage imageNamed:@"red_square"] forState:UIControlStateNormal];
        saleTip.titleLabel.font = tFont(13);
        saleTip.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 5);
        [depthView addSubview:saleTip];
        [saleTip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(depthView.mas_centerX).offset(7.5);
            make.top.mas_equalTo(depthView.mas_top).offset(20);
        }];
        saleTip.titleLabel.layer.masksToBounds = YES;
        saleTip.titleLabel.backgroundColor = self.backgroundColor;
        [saleTip sizeToFit];
        
//        NSDictionary *dic1 = @{@"price":@"0.001",
//                               @"volume":@"500"};
//        NSDictionary *dic2 = @{@"price":@"0.002",
//                               @"volume":@"450"};
//        NSDictionary *dic3 = @{@"price":@"0.003",
//                               @"volume":@"400"};
//        NSDictionary *dic4 = @{@"price":@"0.004",
//                               @"volume":@"350"};
//        NSDictionary *dic5 = @{@"price":@"0.005",
//                               @"volume":@"300"};
//        NSDictionary *dic6 = @{@"price":@"0.006",
//                               @"volume":@"250"};
//        NSDictionary *dic7 = @{@"price":@"0.002",
//                               @"volume":@"240"};
//        NSDictionary *dic8 = @{@"price":@"0.003",
//                               @"volume":@"230"};
//        NSDictionary *dic9 = @{@"price":@"0.004",
//                               @"volume":@"190"};
//        NSDictionary *dic10 = @{@"price":@"0.005",
//                                @"volume":@"150"};
//        NSDictionary *dic110 = @{@"price":@"0.006",
//                                 @"volume":@"100"};
//        NSMutableArray *buyArray = [NSMutableArray arrayWithObjects:dic1,dic2,dic3,dic4,dic5,dic6,dic7,dic8,dic9,dic10,dic110, nil];
//        NSDictionary *dic66 = @{@"price":@"0.001",
//                                @"volume":@"500"};
//        NSDictionary *dic55 = @{@"price":@"0.002",
//                                @"volume":@"400"};
//        NSDictionary *dic44 = @{@"price":@"0.003",
//                                @"volume":@"300"};
//        NSDictionary *dic33 = @{@"price":@"0.004",
//                                @"volume":@"200"};
//        NSDictionary *dic22 = @{@"price":@"0.005",
//                                @"volume":@"150"};
//        NSDictionary *dic11 = @{@"price":@"0.006",
//                                @"volume":@"100"};
//        NSMutableArray *sellArray = [NSMutableArray arrayWithObjects:dic11,dic22,dic33,dic44,dic55,dic66,nil];
//        [self.klineDeepView setDataArrOfX:@[@"0.01",@"0.03",@"0.06",@"0.08",@"0.11"]];
//        double maxY = 500.00;
//        NSString *y1 = @"";
//        if (maxY > 1000) {
//            y1 = [NSString stringWithFormat:@"%.2fK",maxY/1000];
//        }
//        else{
//            y1 = [NSString stringWithFormat:@"%.2f",maxY];
//        }
//        NSString *y2 = @"";
//        if (maxY > 1000) {
//            y2 = [NSString stringWithFormat:@"%.2fK",maxY/5*4/1000];
//        }
//        else{
//            y2 = [NSString stringWithFormat:@"%.2f",maxY/5*4];
//        }
//        NSString *y3 = @"";
//        if (maxY > 1000) {
//            y3 = [NSString stringWithFormat:@"%.2fK",maxY/5*3/1000];
//        }
//        else{
//            y3 = [NSString stringWithFormat:@"%.2f",maxY/5*3];
//        }
//        NSString *y4 = @"";
//        if (maxY > 1000) {
//            y4 = [NSString stringWithFormat:@"%.2fK",maxY/5*2/1000];
//        }
//        else{
//            y4 = [NSString stringWithFormat:@"%.2f",maxY/5*2];
//        }
//        NSString *y5 = @"";
//        if (maxY > 1000) {
//            y5 = [NSString stringWithFormat:@"%.2fK",maxY/5/1000];
//        }
//        else{
//            y5 = [NSString stringWithFormat:@"%.2f",maxY/5];
//        }
//        [self.klineDeepView setDataArrOfY:@[y1,y2,y3,y4,y5]];
//        self.klineDeepView.maxY = maxY;
//        [self.klineDeepView setBuyDataArrOfPoint:buyArray];
//        [self.klineDeepView setSellDataArrOfPoint:sellArray];
//        [self.klineDeepView setSymbol:@"EOS"];
        
        UIView *line1 = [UIView new];
        line1.theme_backgroundColor = THEME_LINE_TABLEVIEW_SEPARATOR_COLOR;
        [self addSubview:line1];
        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(depthView.mas_bottom);
            make.left.mas_equalTo(self.mas_left);
            make.size.mas_equalTo(CGSizeMake(ScreenWidth, 1));
        }];
        
        UIView *sectionHeaderView = [UIView new];
        sectionHeaderView.backgroundColor = self.backgroundColor;
     //   sectionHeaderView.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        [self addSubview:sectionHeaderView];
        [sectionHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(line1.mas_bottom);
            make.left.mas_equalTo(self.mas_left);
            make.size.mas_equalTo(CGSizeMake(ScreenWidth, 40));
        }];
        
        self.buyAmountLabel = [UILabel new];
        self.buyAmountLabel.layer.masksToBounds = YES;
        self.buyAmountLabel.backgroundColor = self.backgroundColor;
        self.buyAmountLabel.text = NSStringFormat(@"%@ %@ (ETC)",LocalizationKey(@"BuyHandicap"),LocalizationKey(@"Amount"));
        self.buyAmountLabel.textColor = rgba(57, 75, 83, 1);
        self.buyAmountLabel.font = tFont(13);
        [sectionHeaderView addSubview:self.buyAmountLabel];
        [self.buyAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(sectionHeaderView.mas_centerY) ;
            make.left.mas_equalTo(self.mas_left).offset(OverAllLeft_OR_RightSpace);
        }];
        
        self.coinPriceLabel = [UILabel new];
        self.coinPriceLabel.layer.masksToBounds = YES;
        self.coinPriceLabel.backgroundColor = self.backgroundColor;
        self.coinPriceLabel.text = NSStringFormat(@"%@(BTC)",LocalizationKey(@"Price"));
        self.coinPriceLabel.textColor = rgba(57, 75, 83, 1);
        self.coinPriceLabel.font = tFont(13);
        [sectionHeaderView addSubview:self.coinPriceLabel];
        [self.coinPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(sectionHeaderView.mas_centerY)  ;
            make.centerX.mas_equalTo(self.mas_centerX);
        }];
        
        self.saleAmountLabel = [UILabel new];
        self.saleAmountLabel.layer.masksToBounds = YES;
        self.saleAmountLabel.backgroundColor = self.backgroundColor;
        self.saleAmountLabel.text = NSStringFormat(@"%@(BTC)  %@",LocalizationKey(@"Amount"),LocalizationKey(@"SellHandicap"));
        self.saleAmountLabel.textColor = rgba(57, 75, 83, 1);
        self.saleAmountLabel.font = tFont(13);
        [sectionHeaderView addSubview:self.saleAmountLabel];
        [self.saleAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(sectionHeaderView.mas_centerY) ;
            make.right.mas_equalTo(self.mas_right).offset(-OverAllLeft_OR_RightSpace);
        }];
    }
    return self;
}

-(void)setCoinName:(NSString *)leftName rightName:(NSString *)rightName depthDic:(nonnull NSDictionary *)depthDic priceScale:(int)priceScale fromScale:(int)fromScale{
    NSDictionary *dict = depthDic;
    
    self.buyAmountLabel.text = [NSString stringWithFormat:@"%@ %@(%@)",LocalizationKey(@"BuyHandicap"),LocalizationKey(@"Amount"),leftName];
    self.coinPriceLabel.text = [NSString stringWithFormat:@"%@ (%@)",LocalizationKey(@"Price"),rightName];
    self.saleAmountLabel.text = [NSString stringWithFormat:@"%@(%@) %@",LocalizationKey(@"Amount"),leftName,LocalizationKey(@"SellHandicap")];
    [self.klineDeepView setSymbol:leftName];
    self.klineDeepView.priceCoinName = rightName;
    self.klineDeepView.priceScale = priceScale;
    self.klineDeepView.fromScale = fromScale;
    if(dict.count == 0){
    //    self.klineDeepView = [CFDeepView new];
        [self.klineDeepView setDataArrOfX:@[@"0",@"0",@"0",@"0",@"0"]];
        [self.klineDeepView setDataArrOfY:@[@"0",@"0",@"0",@"0",@"0"]];
        self.klineDeepView.maxY = 0;

        [self.klineDeepView setBuyDataArrOfPoint:@[]];
        [self.klineDeepView setSellDataArrOfPoint:@[]];
        self.klineDeepView.buyDataArrOfPointPrice = @[];
        self.klineDeepView.sellDataArrOfPointPrice = @[];
        return;
    }
    
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
        NSMutableArray *buyArray = [NSMutableArray array];
           NSMutableArray *sellArray = [NSMutableArray array];
        
           for (NSDictionary *dic in dict[@"buy_list"][@"list"]) {
               [buyArray addObject:dic];
           }
           for (NSDictionary *dic in dict[@"sell_list"][@"list"]) { 
               [sellArray addObject:dic];
           }
           
           if(buyArray.count == 0
              && sellArray.count == 0){
               return;
           }
           
           NSMutableArray *getLeftXArray = [NSMutableArray array];
           NSMutableArray *getRightXArray = [NSMutableArray array];
           NSMutableArray *getLeftYArray = [NSMutableArray array];
           NSMutableArray *getRightYArray = [NSMutableArray array];
           
           NSMutableArray *leftTotalArray = [NSMutableArray array];
           NSMutableArray *rightTotalArray = [NSMutableArray array];
           
           //先让最小金额在左边
           buyArray  = [[NSMutableArray alloc] initWithArray:[buyArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
               double total_surplus = [obj1[@"price"] doubleValue];
               double total_surplus1 = [obj2[@"price"] doubleValue];
               if (total_surplus > total_surplus1) {
                   return NSOrderedDescending;
               } else {
                   return NSOrderedAscending;
               }
           }]];
           
           for (NSInteger i = buyArray.count - 1; i>=0; i--) {
               [getLeftXArray addObject:buyArray[i][@"price"]];
               double surplus = 0.0;
               for (int i = 0; i<getLeftXArray.count; i++) {
                   surplus += [buyArray[i][@"total_surplus"] doubleValue];
               }
               [getLeftYArray addObject:[NSNumber numberWithDouble:surplus]];
               [leftTotalArray addObject:@{@"total_surplus":[NSNumber numberWithDouble:surplus]}];
           }
           //再根据成交量排序
           leftTotalArray = [[NSMutableArray alloc] initWithArray:[leftTotalArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
               double total_surplus = [obj1[@"total_surplus"] doubleValue];
               double total_surplus1 = [obj2[@"total_surplus"] doubleValue];
               if (total_surplus < total_surplus1) {
                   return NSOrderedDescending;
               } else {
                   return NSOrderedAscending;
               }
           }]];
           
           for (int i = 0; i<sellArray.count; i++) {
               [getRightXArray addObject:sellArray[i][@"price"]];
               
               double surplus = 0.0;
               for (int i = 0; i<getRightXArray.count; i++) {
                   surplus += [sellArray[i][@"total_surplus"] doubleValue];
               }
               [getRightYArray addObject:[NSNumber numberWithDouble:surplus]];
               [rightTotalArray addObject:@{@"total_surplus":[NSNumber numberWithDouble:surplus]}];
           }
           
           NSString *leftX = [NSString stringWithFormat:@"%@",[ToolUtil stringFromNumber:[[getLeftXArray valueForKeyPath:@"@min.doubleValue"] doubleValue] withlimit:priceScale]]  ;
           NSString *leftAvgX = [NSString stringWithFormat:@"%@",[ToolUtil stringFromNumber:[[getLeftXArray valueForKeyPath:@"@avg.doubleValue"] doubleValue] withlimit:priceScale]];
           NSString *rightAvgX = [NSString stringWithFormat:@"%@",[ToolUtil stringFromNumber:[[getRightXArray valueForKeyPath:@"@avg.doubleValue"] doubleValue] withlimit:priceScale]];
           NSString *rightX = [NSString stringWithFormat:@"%@",[ToolUtil stringFromNumber:[[getRightXArray valueForKeyPath:@"@max.doubleValue"] doubleValue] withlimit:priceScale]];
           
           NSString *centerX = @"";
           if([[getLeftXArray valueForKeyPath:@"@min.doubleValue"] doubleValue] >= [[getRightXArray valueForKeyPath:@"@min.doubleValue"] doubleValue]){
               centerX = [NSString stringWithFormat:@"%@",[ToolUtil stringFromNumber:[[getLeftXArray valueForKeyPath:@"@min.doubleValue"] doubleValue] withlimit:priceScale]];
           }else{
               centerX = [NSString stringWithFormat:@"%@",[ToolUtil stringFromNumber:[[getRightXArray valueForKeyPath:@"@min.doubleValue"] doubleValue] withlimit:priceScale]]; ;
           }
           
          // [self.klineDeepView setDataArrOfX:@[leftX,leftAvgX,centerX,rightAvgX,rightX]];
           
           
           double maxY;
           
           if([[getLeftYArray valueForKeyPath:@"@max.floatValue"] floatValue] >= [[getRightYArray valueForKeyPath:@"@max.floatValue"] floatValue]){
               maxY = [[getLeftYArray valueForKeyPath:@"@max.floatValue"] floatValue];
           }else{
               maxY = [[getRightYArray valueForKeyPath:@"@max.floatValue"] floatValue];
           }
           
           
           NSString *y1 = @"";
           if (maxY > 1000) {
               y1 = [NSString stringWithFormat:@"%.2fK",maxY/1000];
           }
           else{
               y1 = [NSString stringWithFormat:@"%.2f",maxY];
           }
           NSString *y2 = @"";
           if (maxY > 1000) {
               y2 = [NSString stringWithFormat:@"%.2fK",maxY/5*4/1000];
           }
           else{
               y2 = [NSString stringWithFormat:@"%.2f",maxY/5*4];
           }
           NSString *y3 = @"";
           if (maxY > 1000) {
               y3 = [NSString stringWithFormat:@"%.2fK",maxY/5*3/1000];
           }
           else{
               y3 = [NSString stringWithFormat:@"%.2f",maxY/5*3];
           }
           NSString *y4 = @"";
           if (maxY > 1000) {
               y4 = [NSString stringWithFormat:@"%.2fK",maxY/5*2/1000];
           }
           else{
               y4 = [NSString stringWithFormat:@"%.2f",maxY/5*2];
           }
           NSString *y5 = @"";
           if (maxY > 1000) {
               y5 = [NSString stringWithFormat:@"%.2fK",maxY/5/1000];
           }
           else{
               y5 = [NSString stringWithFormat:@"%.2f",maxY/5];
           }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.klineDeepView setDataArrOfX:@[leftX,leftAvgX,centerX,rightAvgX,rightX]];
                      
            [self.klineDeepView setDataArrOfY:@[y1,y2,y3,y4,y5]];
            self.klineDeepView.maxY = maxY;
            
            [self.klineDeepView setBuyDataArrOfPoint:leftTotalArray];
            [self.klineDeepView setSellDataArrOfPoint:rightTotalArray];
            self.klineDeepView.buyDataArrOfPointPrice = buyArray;
            self.klineDeepView.sellDataArrOfPointPrice = sellArray;
        });
           
    });
    
    
    
   
}

- (CFDeepView *)klineDeepView {
    if (!_klineDeepView) {
        _klineDeepView = [[CFDeepView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 230)];
        _klineDeepView.backgroundColor = self.backgroundColor;
       // [_klineDeepView setSymbol:@"EOS"];
    }
    return _klineDeepView;
}
@end
