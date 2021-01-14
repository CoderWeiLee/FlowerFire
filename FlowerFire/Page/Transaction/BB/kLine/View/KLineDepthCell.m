//
//  KLineDepthCell.m
//  FireCoin
//
//  Created by 王涛 on 2019/6/6.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "KLineDepthCell.h"

@interface KLineDepthCell ()
{
    
}
@end

@implementation KLineDepthCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        
        self.BuyIndex = [UILabel new];
        self.BuyIndex.textColor = rgba(115, 135, 160, 1);
        self.BuyIndex.font = tFont(12);
        self.BuyIndex.text = @"1";
        self.BuyIndex.textAlignment = NSTextAlignmentLeft;
    //    self.BuyIndex.layer.masksToBounds = YES;
    //    self.BuyIndex.backgroundColor = self.backgroundColor;
        [self addSubview:self.BuyIndex];
//        [self.BuyIndex mas_makeConstraints:^(MASConstraintMaker *make) {
//         //   make.top.mas_equalTo(self.mas_top).offset(10);
//            make.left.mas_equalTo(self.mas_left).offset(OverAllLeft_OR_RightSpace);
//            make.width.mas_greaterThanOrEqualTo(15.333);
//            make.centerY.mas_equalTo(self.mas_centerY);
//        //    make.bottom.mas_equalTo(self.mas_bottom).offset(-10);
//        }];
        self.BuyIndex.frame = CGRectMake(OverAllLeft_OR_RightSpace, 0, 15.333, self.height);
        
        self.BuyNum = [UILabel new];
        self.BuyNum.theme_textColor = THEME_TEXT_COLOR;
        self.BuyNum.font = tFont(13);
        self.BuyNum.text = @"000.0000";
   //     self.BuyNum.layer.masksToBounds = YES;
   //     self.BuyNum.backgroundColor = self.backgroundColor;
        self.BuyNum.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.BuyNum];
//        [self.BuyNum mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(self.BuyIndex.mas_right).offset(5);
//            make.centerY.mas_equalTo(self.mas_centerY);
//            make.width.mas_lessThanOrEqualTo(ScreenWidth/4 - 22.5);
//        }];
        self.BuyNum.frame = CGRectMake(CGRectGetMaxX(self.BuyIndex.frame), 0, ScreenWidth/4 - 22.5,  self.height);
        self.BuyNum.adjustsFontSizeToFitWidth = YES;
        
        self.BuyPrice = [UILabel new];
        self.BuyPrice.textColor = qutesGreenColor;
        self.BuyPrice.font = tFont(13);
        self.BuyPrice.text = @"0.000000";
   //     self.BuyPrice.layer.masksToBounds = YES;
    //    self.BuyPrice.backgroundColor = self.backgroundColor;
        self.BuyPrice.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.BuyPrice];
        [self.BuyPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_centerX).offset(-5);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.width.mas_lessThanOrEqualTo(ScreenWidth/4 - 22.5);
        }];
        
        self.BuyPrice.adjustsFontSizeToFitWidth = YES;
        
        self.SellIndex = [UILabel new];
        self.SellIndex.textColor = rgba(115, 135, 160, 1);
        self.SellIndex.font = tFont(12);
        self.SellIndex.text = @"1";
     //   self.SellIndex.layer.masksToBounds = YES;
     //   self.SellIndex.backgroundColor = self.backgroundColor;
        self.SellIndex.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.SellIndex];
        [self.SellIndex mas_makeConstraints:^(MASConstraintMaker *make) {
       //     make.top.mas_equalTo(self.mas_top).offset(10);
            make.right.mas_equalTo(self.mas_right).offset(-OverAllLeft_OR_RightSpace);
            make.width.mas_greaterThanOrEqualTo(15.333);
            make.centerY.mas_equalTo(self.mas_centerY);
   //         make.bottom.mas_equalTo(self.mas_bottom).offset(-10);
        }];
        
        self.SellNum = [UILabel new];
        self.SellNum.theme_textColor = THEME_TEXT_COLOR;
        self.SellNum.font = tFont(13);
        self.SellNum.text = @"000.0000";
    //    self.SellNum.layer.masksToBounds = YES;
    //    self.SellNum.backgroundColor = self.backgroundColor;
        self.SellNum.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.SellNum];
        [self.SellNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.SellIndex.mas_left).offset(-5);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.width.mas_lessThanOrEqualTo(ScreenWidth/4 - 22.5);
        }];
        
        self.SellNum.adjustsFontSizeToFitWidth = YES;
        
        self.SellPrice = [UILabel new];
        self.SellPrice.textColor = qutesRedColor;
        self.SellPrice.font = tFont(13);
        self.SellPrice.text = @"0.000000";
  //      self.SellPrice.layer.masksToBounds = YES;
    //    self.SellPrice.backgroundColor = self.backgroundColor;
        self.SellPrice.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.SellPrice];
        [self.SellPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_centerX).offset(5);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.width.mas_lessThanOrEqualTo(ScreenWidth/4 - 22.5);
        }];
        
        self.SellPrice.adjustsFontSizeToFitWidth = YES;
    }
    return self;
}

-(void)setCellData:(NSDictionary *)depthDic cellIndex:(NSInteger)cellIndex priceScale:(int)priceScale fromScale:(int)fromScale{
    int HandicapDataCount = 20;
    NSMutableArray *bidcontentArr = [NSMutableArray array];
    NSMutableArray *askcontentArr = [NSMutableArray array];
    
    for (NSDictionary *dic in depthDic[@"buy_list"][@"list"]) {
        [bidcontentArr addObject:dic];
    }
    for (NSDictionary *dic in depthDic[@"sell_list"][@"list"]) {
        [askcontentArr addObject:dic];
    }
    
    if (bidcontentArr.count>= HandicapDataCount) {
        bidcontentArr = [NSMutableArray arrayWithArray:[bidcontentArr subarrayWithRange:NSMakeRange(0, HandicapDataCount)]];
    }else{
        int amount= HandicapDataCount-(int) bidcontentArr.count;
        for (int i=0; i<amount; i++) {
            [bidcontentArr insertObject:@{@"price":@00.00,@"total_surplus":@00.00} atIndex:bidcontentArr.count];
        }
    }
    
    if (askcontentArr.count>=20) {
        askcontentArr = [NSMutableArray arrayWithArray:[askcontentArr subarrayWithRange:NSMakeRange(0, HandicapDataCount)]];
    }else{
        int amount= HandicapDataCount-(int)askcontentArr.count;
        for (int i=0; i<amount; i++) {
            [askcontentArr insertObject:@{@"price":@00.00,@"total_surplus":@00.00} atIndex:askcontentArr.count];
        }
    }
    
    
    self.BuyPrice.text=[NSString stringWithFormat:@"%@",[ToolUtil stringFromNumber:[bidcontentArr[cellIndex][@"price"] doubleValue] withlimit:priceScale]];
    self.BuyNum.text =  [NSString stringWithFormat:@"%@",[ToolUtil stringFromNumber:[bidcontentArr[cellIndex][@"total_surplus"] doubleValue] withlimit:fromScale]];
    
    self.SellPrice.text = [NSString stringWithFormat:@"%@",[ToolUtil stringFromNumber:[askcontentArr[cellIndex][@"price"] doubleValue] withlimit:priceScale]];
    self.SellNum.text =  [NSString stringWithFormat:@"%@",[ToolUtil stringFromNumber:[askcontentArr[cellIndex][@"total_surplus"] doubleValue] withlimit:fromScale]];
    
    [self defaultStrConversion];
}

-(void)setCellData:(NSDictionary *)depthDic cellIndex:(NSInteger)cellIndex{
//    int HandicapDataCount = 20;
//    NSMutableArray *bidcontentArr = [NSMutableArray array];
//    NSMutableArray *askcontentArr = [NSMutableArray array];
//    
//    for (NSDictionary *dic in depthDic[@"buy_list"][@"list"]) {
//        [bidcontentArr addObject:dic];
//    }
//    for (NSDictionary *dic in depthDic[@"sell_list"][@"list"]) {
//        [askcontentArr addObject:dic];
//    }
//    
//    if (bidcontentArr.count>= HandicapDataCount) {
//        bidcontentArr = [NSMutableArray arrayWithArray:[bidcontentArr subarrayWithRange:NSMakeRange(0, HandicapDataCount)]];
//    }else{
//        int amount= HandicapDataCount-(int) bidcontentArr.count;
//        for (int i=0; i<amount; i++) {
//            [bidcontentArr insertObject:@{@"price":@00.00,@"total_surplus":@00.00} atIndex:bidcontentArr.count];
//        }
//    }
//    
//    if (askcontentArr.count>=20) {
//        askcontentArr = [NSMutableArray arrayWithArray:[askcontentArr subarrayWithRange:NSMakeRange(0, HandicapDataCount)]];
//    }else{
//        int amount= HandicapDataCount-(int)askcontentArr.count;
//        for (int i=0; i<amount; i++) {
//            [askcontentArr insertObject:@{@"price":@00.00,@"total_surplus":@00.00} atIndex:askcontentArr.count];
//        }
//    }
//    
//    self.BuyPrice.text=[NSString stringWithFormat:@"%@",bidcontentArr[cellIndex][@"price"]];
//    
//    self.SellPrice.text = [NSString stringWithFormat:@"%@",askcontentArr[cellIndex][@"price"]];
//   
//    if([[UniversalViewMethod getContractSetting] isEqualToString:@"张"]){
//        self.BuyNum.text =  [NSString stringWithFormat:@"%@",bidcontentArr[cellIndex][@"cont"]];
//        self.SellNum.text =  [NSString stringWithFormat:@"%@",askcontentArr[cellIndex][@"cont"]];
//    }else{
//         self.BuyNum.text =  [NSString stringWithFormat:@"%f",[bidcontentArr[cellIndex][@"amount"] doubleValue]];
//         self.SellNum.text =  [NSString stringWithFormat:@"%f",[askcontentArr[cellIndex][@"amount"] doubleValue]];
//    }
//    [self defaultStrConversion];
}
//0的数值转换为 --
-(void)defaultStrConversion{
    if([self.BuyNum.text doubleValue] == 0){
        self.BuyNum.text = @"--";
    }
    if([self.SellNum.text doubleValue] == 0){
        self.SellNum.text = @"--";
    }
    if([self.BuyPrice.text doubleValue] == 0){
        self.BuyPrice.text = @"--";
    }
    if([self.SellPrice.text doubleValue] == 0){
        self.SellPrice.text = @"--";
    }
}
@end
