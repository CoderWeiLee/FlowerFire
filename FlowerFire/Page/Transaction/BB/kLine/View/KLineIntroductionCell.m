//
//  KLineIntroductionCell.m
//  FireCoin
//
//  Created by 王涛 on 2019/7/4.
//  Copyright © 2019 王涛. All rights reserved.
//  k线cell

#import "KLineIntroductionCell.h"

@implementation KLineIntroductionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        
        UIView *line = [UIView new];
        line.theme_backgroundColor = THEME_LINE_TABLEVIEW_SEPARATOR_COLOR;
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top);
            make.left.mas_equalTo(self.mas_left).offset(OverAllLeft_OR_RightSpace);
            make.size.mas_equalTo(CGSizeMake(ScreenWidth-20, 1));
        }];
        
        self.leftLabel = [UILabel new];
        self.leftLabel.textColor = rgba(91, 133, 150, 1);
        self.leftLabel.font = tFont(15);
        self.leftLabel.layer.masksToBounds = YES;
        self.leftLabel.backgroundColor = self.backgroundColor;
        [self addSubview:self.leftLabel];
        [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(OverAllLeft_OR_RightSpace);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        
        self.rightLabel = [UILabel new];
        self.rightLabel.textAlignment = NSTextAlignmentRight;
        self.rightLabel.theme_textColor = THEME_TEXT_COLOR;
        self.rightLabel.font = tFont(15);
        self.rightLabel.layer.masksToBounds = YES;
        self.rightLabel.backgroundColor = self.backgroundColor;
        [self addSubview:self.rightLabel];
        [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).offset(-OverAllLeft_OR_RightSpace);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.width.mas_equalTo(ScreenWidth/2);
        }];
        
        
    }
    return self;
}

-(void)setCellData:(NSArray<BlockchainIntroductionModel *> *)modelArray cellIndex:(NSInteger)cellIndex{
    self.rightLabel.text = @"--";
    if(modelArray.count > 0){
        BlockchainIntroductionModel *model = modelArray[0];
        switch (cellIndex) {
            case 0:
                self.leftLabel.text = LocalizationKey(@"Issue Time");
                self.rightLabel.text = [HelpManager getTimeStr:model.public_time dataFormat:@"yyyy-MM-dd"];
                break;
            case 1:
                self.leftLabel.text = LocalizationKey(@"Total Amount");
                self.rightLabel.text = model.total_num;
                break;
            case 2:
                self.leftLabel.text = LocalizationKey(@"Circulation");
                self.rightLabel.text = model.total_market;
                break;
            case 3:
                self.leftLabel.text = LocalizationKey(@"Token Price");
                self.rightLabel.text = model.group_price;
                break;
            case 4:
                self.leftLabel.text = LocalizationKey(@"White Paper");
                self.rightLabel.text = model.white_book;
                break;
            case 5:
                self.leftLabel.text = LocalizationKey(@"Official Website");
                self.rightLabel.text = model.url;
                break;
            case 6:
                self.leftLabel.text = LocalizationKey(@"Block Explorer");
                self.rightLabel.text = model.block_url;
                break;
        }
    }else{
        switch (cellIndex) {
            case 0:
                self.leftLabel.text = LocalizationKey(@"Issue Time");
                break;
            case 1:
                self.leftLabel.text = LocalizationKey(@"Total Amount");
                break;
            case 2:
                self.leftLabel.text = LocalizationKey(@"Circulation");
                break;
            case 3:
                self.leftLabel.text = LocalizationKey(@"Token Price");
                break;
            case 4:
                self.leftLabel.text = LocalizationKey(@"White Paper");
                break;
            case 5:
                self.leftLabel.text = LocalizationKey(@"Official Website");
                break;
            case 6:
                self.leftLabel.text = LocalizationKey(@"Block Explorer");
                break;
        }
    }
    
}



@end
