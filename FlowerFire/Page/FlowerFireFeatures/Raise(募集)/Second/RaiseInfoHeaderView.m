//
//  RaiseInfoHeaderView.m
//  FlowerFire
//
//  Created by 王涛 on 2020/7/15.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "RaiseInfoHeaderView.h"

@interface RaiseInfoHeaderView ()
{
    UIImageView *_coinImageView;
    WTLabel     *_coinName;
    WTLabel     *_status;
    WTBacView   *_line;
}
@end

@implementation RaiseInfoHeaderView

- (instancetype)initWithFrame:(CGRect)frame coinName:(nonnull NSString *)coinName
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = KWhiteColor;
        _coinImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:coinName]];
        _coinImageView.frame = CGRectMake(OverAllLeft_OR_RightSpace, OverAllLeft_OR_RightSpace, 70, 70);
        [self addSubview:_coinImageView];
        
        _coinName = [[WTLabel alloc] initWithFrame:CGRectMake(_coinImageView.right + 5, _coinImageView.centerY - 20, 200, 20) Text:coinName Font:tFont(16) textColor:KBlackColor parentView:self];
        
        _status = [[WTLabel alloc] initWithFrame:CGRectMake(_coinName.left, _coinImageView.centerY, 200, 20) Text:@"公募状态:募集结束" Font:tFont(15) textColor:[UIColor grayColor] parentView:self];
        
        NSMutableAttributedString *ma = [[NSMutableAttributedString alloc] initWithString:_status.text];
        [ma yy_setColor:MainColor range:[_status.text rangeOfString:@"募集结束"]];
        [ma yy_setColor:[UIColor grayColor] range:[_status.text rangeOfString:@"公募状态:"]];
        [ma yy_setFont:tFont(15) range:[_status.text rangeOfString:@"募集结束"]];
        [ma yy_setFont:tFont(15) range:[_status.text rangeOfString:@"公募状态:"]];
        _status.attributedText = ma;
        
        _line = [[WTBacView alloc] initWithFrame:CGRectMake(_coinImageView.left, self.height - 1, SCREEN_WIDTH - 2 * OverAllLeft_OR_RightSpace, 1) backGroundColor:FlowerFirexianColor parentView:self];
    }
    return self;
}

@end
