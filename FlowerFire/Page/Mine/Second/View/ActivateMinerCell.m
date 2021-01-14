//
//  ActivateMinerCell.m
//  FlowerFire
//
//  Created by 王涛 on 2020/8/24.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "ActivateMinerCell.h"

@interface ActivateMinerCell ()
{
    UIImageView *_coinImageView;
    WTBacView   *_whiteBac;
    WTLabel     *_coinName;
    WTLabel     *_time,*_sumCoin,*_invitedAddress,*_memberNum,*_phoneNum;
    WTBacView   *_line;
}
@end

@implementation ActivateMinerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self createUI];
        [self layoutSubview];
    }
    return self;
}

- (void)createUI{
    _whiteBac = [[WTBacView alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, 20, SCREEN_WIDTH - 2 * OverAllLeft_OR_RightSpace, 130) backGroundColor:KWhiteColor parentView:self.contentView];
    _whiteBac.layer.borderWidth = 1;
    _whiteBac.layer.cornerRadius = 1;
    _whiteBac.layer.borderColor = FlowerFireBorderColor.CGColor;
    
    _coinImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"头像"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    _coinImageView.frame = CGRectMake(OverAllLeft_OR_RightSpace, 10, 21, 21);
    [_whiteBac addSubview:_coinImageView];
    _coinImageView.tintColor = MainColor;
     
    _coinName = [[WTLabel alloc] initWithFrame:CGRectMake(_coinImageView.right + 5, _coinImageView.centerY - 10, (_whiteBac.width-50)/2, 20) Text:@"--" Font:tFont(12) textColor:rgba(139, 139, 139, 1) parentView:_whiteBac];
    
    _time = [[WTLabel alloc] initWithFrame:CGRectMake(_whiteBac.width - OverAllLeft_OR_RightSpace - (_whiteBac.width-50)/2, _coinName.centerY - 10, (_whiteBac.width-50)/2, 20) Text:LocalizationKey(@"578Tip14") Font:tFont(10) textColor:rgba(139, 139, 139, 1) parentView:_whiteBac];
    _time.textAlignment = NSTextAlignmentRight;
    
    _line = [[WTBacView alloc] initWithFrame:CGRectMake(0, _coinImageView.bottom + 10, _whiteBac.width, 1) backGroundColor:FlowerFirexianColor parentView:_whiteBac];
    
    _sumCoin = [[WTLabel alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, _line.bottom + OverAllLeft_OR_RightSpace, _whiteBac.width - 2 * OverAllLeft_OR_RightSpace, 15) Text:LocalizationKey(@"578Tip15") Font:tFont(15) textColor:rgba(45, 45, 45, 1) parentView:_whiteBac];
    
    _invitedAddress = [[WTLabel alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, _sumCoin.bottom + 10, _whiteBac.width - 2 * OverAllLeft_OR_RightSpace, 15) Text:LocalizationKey(@"578Tip16") Font:tFont(7) textColor:rgba(45, 45, 45, 1) parentView:_whiteBac];
    
    [_invitedAddress sizeThatFits:CGSizeMake(_whiteBac.width - 2 * OverAllLeft_OR_RightSpace, 15)];
    
    _memberNum = [[WTLabel alloc] initWithFrame:CGRectMake(_sumCoin.left, _invitedAddress.bottom + 9.5, _whiteBac.width/2, 10) Text:LocalizationKey(@"578Tip17") Font:tFont(10) textColor:rgba(137, 137, 137, 1) parentView:_whiteBac];
    
    _phoneNum = [[WTLabel alloc] initWithFrame:CGRectMake(_whiteBac.width - OverAllLeft_OR_RightSpace - _memberNum.width, _memberNum.centerY - 10, _memberNum.width, 20) Text:LocalizationKey(@"578Tip18") Font:tFont(10) textColor:rgba(137, 137, 137, 1) parentView:_whiteBac];
    _phoneNum.textAlignment = NSTextAlignmentRight;
   
}

- (void)setCellData:(FFMinerListModel *)model{
    _coinName.text = model.username;
    _sumCoin.text = NSStringFormat(@"%@%@",LocalizationKey(@"578Tip15"),model.money);
    _invitedAddress.text = NSStringFormat(@"%@%@",LocalizationKey(@"578Tip16"),model.address);
    
    _memberNum.text = NSStringFormat(@"%@%@",LocalizationKey(@"578Tip17"),model.down_user_count);
    
    _phoneNum.text = NSStringFormat(@"%@%@",LocalizationKey(@"578Tip18"),model.down_equipment_count);
     
    _time.text = NSStringFormat(@"%@%@",LocalizationKey(@"578Tip14"),model.activation_time);
}

@end
