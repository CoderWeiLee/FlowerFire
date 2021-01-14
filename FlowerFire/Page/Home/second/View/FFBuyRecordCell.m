//
//  FFBuyRecordCell.m
//  FlowerFire
//
//  Created by 王涛 on 2020/8/29.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "FFBuyRecordCell.h"

@implementation FFBuyRecordCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.topLabel = [[WTLabel alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, OverAllLeft_OR_RightSpace, ScreenWidth/2, 20) Text:@"--" Font:tFont(15) textColor:KBlackColor parentView:self.contentView];
        
        self.bottomLabel = [[WTLabel alloc] initWithFrame:CGRectMake(self.topLabel.left, self.topLabel.bottom + 5, self.topLabel.width, 20) Text:@"--" Font:tFont(13) textColor:grayTextColor parentView:self.contentView];
        
        self.centerLabel = [[WTLabel alloc] initWithFrame:CGRectZero Text:@"--" Font:tFont(15) textColor:KBlackColor parentView:self.contentView];
        
        [self.centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-OverAllLeft_OR_RightSpace);
        }];
        
        WTBacView *line = [[WTBacView alloc] initWithFrame:CGRectMake(self.topLabel.left, 69, ScreenWidth - 2 * OverAllLeft_OR_RightSpace, 1) backGroundColor:FlowerFirexianColor parentView:nil];
        [self.contentView addSubview:line];
    }
    return self;
}

@end
