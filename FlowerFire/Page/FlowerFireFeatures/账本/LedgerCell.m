//
//  LedgerCell.m
//  FlowerFire
//
//  Created by 王涛 on 2020/7/14.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "LedgerCell.h"

@interface LedgerCell ()
{
    WTLabel     *_topLabel,*_bottomLabel;
    WTBacView   *_lineBac;
    
}
@end

@implementation LedgerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self createUI];
        [self layoutSubview];
    }
    return self;
}

- (void)createUI{
    _topLabel = [[WTLabel alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, OverAllLeft_OR_RightSpace, ScreenWidth, 20) Text:@"已被 we******89激活" Font:tFont(15) textColor:grayTextColor parentView:self.contentView];
    
    _bottomLabel = [[WTLabel alloc] initWithFrame:CGRectMake(_topLabel.left, _topLabel.bottom + 5, ScreenWidth, 18) Text:@"2020-07-10 16:54" Font:tFont(14) textColor:[UIColor grayColor] parentView:self.contentView];
    
    _lineBac = [[WTBacView alloc] initWithFrame:CGRectMake(0, 69.5, ScreenWidth, 0.5) backGroundColor:FlowerFirexianColor parentView:self.contentView];
}

- (void)layoutSubview{
    
}

- (void)setCellData:(id)dic{
    _topLabel.text = @"比特币多空再度反转 后续价格能否延续上行";
    
}

@end
