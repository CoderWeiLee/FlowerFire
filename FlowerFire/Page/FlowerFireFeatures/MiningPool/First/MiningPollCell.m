//
//  MiningPollCell.m
//  FlowerFire
//
//  Created by 王涛 on 2020/7/14.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "MiningPollCell.h"

@interface MiningPollCell ()
{
    UIImageView *_coinImageView;
    WTBacView   *_whiteBac,*_lineView;
    WTLabel     *_maxCoin,*_minCoin,*_coinName;
    NSMutableArray<WTLabel *> *_labelArray;
    
}
@end

@implementation MiningPollCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.backgroundColor = KGrayBacColor;
        [self createUI];
        [self layoutSubview];
    }
    return self;
    
}

- (void)createUI{
    _whiteBac = [[WTBacView alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, 10, ScreenWidth - 2 * OverAllLeft_OR_RightSpace, 145) backGroundColor:KWhiteColor parentView:self.contentView];
    _whiteBac.layer.cornerRadius = 5;
    
    _coinImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_whiteBac.left, _whiteBac.top, 30, 30)];
    [_whiteBac addSubview:_coinImageView];
    
    _coinName = [[WTLabel alloc] initWithFrame:CGRectMake(_coinImageView.right + 5, _coinImageView.centerY - 10, 100, 20) Text:@"HDU" Font:tFont(15) textColor:KBlackColor parentView:_whiteBac];
    
    _minCoin = [[WTLabel alloc] initWithFrame:CGRectZero Text:@"最低持币" Font:tFont(13) textColor:MainColor parentView:_whiteBac];
    _minCoin.numberOfLines = 0;
   
    _maxCoin = [[WTLabel alloc] initWithFrame:CGRectZero Text:@"最佳持币" Font:tFont(13) textColor:MainColor parentView:_whiteBac];
    _maxCoin.numberOfLines = 0;
  
    _lineView = [[WTBacView alloc] initWithFrame:CGRectMake(_coinImageView.left,  _coinImageView.bottom+15, _whiteBac.width - 15 - OverAllLeft_OR_RightSpace, 0.5) backGroundColor:FlowerFirexianColor parentView:_whiteBac];
    
    NSArray<NSString*> *dateArray = @[@"累计收益",@"昨日收益",@"持币算力",@"推广算力",
                                      @"0",@"0",@"0",@"0",
                                      @"≈¥0",@"≈¥0",@"-",@"-",];
    _labelArray = [NSMutableArray array];
   
    for (int i = 0; i<dateArray.count; i++) {
        long perRowItemCount = 4;
        
        CGFloat space = 0;
        long columnIndex = i % perRowItemCount;
        long rowIndex = i / perRowItemCount;
        CGFloat margin = 5;
        CGFloat itemW = (_whiteBac.width - margin *3 )/ perRowItemCount;
        CGFloat itemH = 20 ;
        CGFloat bacWidth = space + columnIndex * (itemW + margin);
        CGFloat bacHeigth = rowIndex * (itemH + margin) + _lineView.bottom + 8  ; //20 距顶部的距离
        
        WTLabel *label = [[WTLabel alloc] initWithFrame:CGRectMake(bacWidth, bacHeigth, itemW, itemH)  Text:dateArray[i] Font:tFont(13) textColor:KBlackColor parentView:_whiteBac];
        label.textAlignment = NSTextAlignmentCenter;
        
        if(i<4){
            label.textColor = grayTextColor;
        }else if(i <8){
            label.textColor = KBlackColor;
        }else{
            label.textColor = grayTextColor;
        }
        
        [_labelArray addObject:label];
    }
    
}

- (void)layoutSubview{
    [_minCoin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_whiteBac.mas_right).offset(-OverAllLeft_OR_RightSpace);
        make.centerY.mas_equalTo(_coinImageView.mas_centerY);
        make.width.mas_lessThanOrEqualTo(60);
    }];
    
    [_maxCoin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_minCoin.mas_left).offset(-OverAllLeft_OR_RightSpace);
        make.centerY.mas_equalTo(_coinImageView.mas_centerY);
        make.width.mas_lessThanOrEqualTo(60);
    }];
}

- (void)setCellData:(id)dic{
    NSString *str = dic;
    _coinImageView.image = [UIImage imageNamed:str];
    _coinName.text = str;
    
    NSMutableAttributedString *ma = [[NSMutableAttributedString alloc] initWithString:@"最佳持币\n121.33333"];
    [ma yy_setColor:KBlackColor range:[[ma string] rangeOfString:@"121.3333  3"]];
    [ma yy_setColor:MainColor range:[[ma string] rangeOfString:@"最佳持币"]];
   
    _maxCoin.attributedText = ma;
    
    NSMutableAttributedString *ma2 = [[NSMutableAttributedString alloc] initWithString:@"最低持币\n61.23"];
    [ma2 yy_setColor:KBlackColor range:[[ma2 string] rangeOfString:@"61.23"]];
    [ma2 yy_setColor:MainColor range:[[ma2 string] rangeOfString:@"最低持币"]];
    
     
    _minCoin.attributedText= ma2;
   
    _minCoin.textAlignment = NSTextAlignmentCenter;
    _maxCoin.textAlignment = NSTextAlignmentCenter;
    [_maxCoin sizeToFit];
    [_minCoin sizeToFit];
    
}

@end
