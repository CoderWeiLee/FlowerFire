//
//  RaiseCell.m
//  FlowerFire
//
//  Created by 王涛 on 2020/7/15.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "RaiseCell.h"

@interface RaiseCell ()
{
    WTLabel     *_coinName,*_status,*_peopleNum,*_coinNum;
    WTButton    *_time;
    WTBacView   *_line,*_line2;
    UIImageView *_coinImageView;
    
}
@end

@implementation RaiseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self createUI];
        [self layoutSubview];
    }
    return self;
}

- (void)createUI{
    _line2 = [[WTBacView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10) backGroundColor:KGrayBacColor parentView:self.contentView];
    
    _coinName = [[WTLabel alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, _line2.bottom, 100, 40) Text:@"XRP" Font:tFont(16) textColor:KBlackColor parentView:self.contentView];
    
    _time = [[WTButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - OverAllLeft_OR_RightSpace - 200, _line2.bottom, 200, 40) titleStr:@"2020/05/01 16:06" titleFont:tFont(14) titleColor:[UIColor grayColor] buttonImage:[UIImage imageNamed:@"img30"] parentView:self.contentView];
    _time.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _time.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 5);
    
    _line = [[WTBacView alloc] initWithFrame:CGRectMake(_coinName.left, _coinName.bottom, ScreenWidth - OverAllLeft_OR_RightSpace * 2, 0.5) backGroundColor:FlowerFirexianColor parentView:self.contentView];
    
    _coinImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_line.left, _line.bottom+10, 70, 70)];
    [self.contentView addSubview:_coinImageView];
    
    _status = [[WTLabel alloc] initWithFrame:CGRectZero Text:@"募集结束" Font:tFont(16) textColor:MainColor parentView:self.contentView];
    
    _peopleNum = [[WTLabel alloc] initWithFrame:CGRectZero Text:@"目标人数:15000" Font:tFont(15) textColor:[UIColor grayColor] parentView:self.contentView];
   
    _coinNum = [[WTLabel alloc] initWithFrame:CGRectZero Text:@"发型总量:1,000,000,000" Font:tFont(15) textColor:[UIColor grayColor] parentView:self.contentView];
   
 
}

- (void)layoutSubview{
    [_status mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_coinImageView.mas_top);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-OverAllLeft_OR_RightSpace);
    }];
    
    [_coinNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_coinImageView.mas_bottom);
        make.right.mas_equalTo(_status.mas_right);
    }];
    
    [_peopleNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_coinNum.mas_top).offset(-1);
        make.right.mas_equalTo(_status.mas_right);
    }];
}

- (void)setCellData:(id)dic{
    NSString *str = dic;
    _coinImageView.image = [UIImage imageNamed:str];
    _coinName.text = str;
    
}

@end
