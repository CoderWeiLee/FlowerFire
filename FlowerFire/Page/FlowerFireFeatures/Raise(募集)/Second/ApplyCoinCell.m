//
//  ApplyCoinCell.m
//  FlowerFire
//
//  Created by 王涛 on 2020/7/15.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "ApplyCoinCell.h"

@interface ApplyCoinCell ()
{
    WTLabel     *_tip;
    WTLabel     *_redStart;
}
@end

@implementation ApplyCoinCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        _tip = [[WTLabel alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, OverAllLeft_OR_RightSpace, 100, 20) Text:@"" Font:tFont(15) textColor:KBlackColor parentView:self.contentView];
        
        _redStart = [[WTLabel alloc] initWithFrame:CGRectMake(_tip.right, _tip.centerY - 7.5, 15, 15) Text:@"*" Font:tFont(15) textColor:MainColor parentView:self.contentView];
        
        self.textView = [[YYTextView alloc] initWithFrame:CGRectMake(_tip.left, _tip.bottom + 5, SCREEN_WIDTH - 4 *OverAllLeft_OR_RightSpace, 30)];
        self.textView.layer.borderWidth = 1;
        self.textView.layer.borderColor = RGB(217, 217, 217).CGColor;
        self.textView.tintColor = MainColor;
        self.textView.placeholderTextColor = [UIColor grayColor];
        self.textView.textColor = KBlackColor;
        self.textView.layer.cornerRadius = 5;
        [self.contentView addSubview:self.textView];
    }
    return self;
}

- (void)setCellData:(id)dic{
    self.textView.placeholderText = LocalizationKey(dic[@"placeholderText"]);
    _tip.text = LocalizationKey(dic[@"tip"]);
    
    [_tip sizeToFit];
    _redStart.left = _tip.right;
    
    if([dic[@"start"] isEqualToString:@"1"]){
        _redStart.hidden = NO;
    }else{
        _redStart.hidden = YES;
    }
     
}

@end

