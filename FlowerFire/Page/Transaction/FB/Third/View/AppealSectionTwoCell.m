//
//  AppealSectionTwoCell.m
//  FireCoin
//
//  Created by 王涛 on 2019/6/4.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "AppealSectionTwoCell.h"

@interface AppealSectionTwoCell ()
{
   
}
@end

@implementation AppealSectionTwoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if(self){
        
     //   self.backgroundColor = navBarColor;
        [self setTheme_backgroundColor:THEME_CELL_BACKGROUNDCOLOR];
        UIView *line = [[UIView alloc] init];
        line.theme_backgroundColor = THEME_TABBAR_BACKGROUNDCOLOR;
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top);
            make.left.mas_equalTo(self.mas_left);
            make.size.mas_equalTo(CGSizeMake(ScreenWidth, 5));
        }];
        
        UILabel *tip = [UILabel new];
        tip.textColor = rgba(149, 158, 188, 1);
        tip.text = LocalizationKey(@"FiatTip10");
        tip.font = [UIFont boldSystemFontOfSize:18];
        [self addSubview:tip];
        [tip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(line.mas_bottom).offset(15);
            make.left.mas_equalTo(self.mas_left).offset(OverAllLeft_OR_RightSpace);
        }];
        
        self.detailText = [UITextView new];
        self.detailText.textColor = rgba(115, 126, 149, 1);
        self.detailText.text = @"";
        [self.detailText setTheme_backgroundColor:THEME_CELL_BACKGROUNDCOLOR];
     //   self.detailText.backgroundColor = navBarColor;
        self.detailText.font = tFont(14);
        [self addSubview:self.detailText];
        [self.detailText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(tip.mas_bottom).offset(10);
            make.left.mas_equalTo(self.mas_left).offset(OverAllLeft_OR_RightSpace);
            make.size.mas_equalTo(CGSizeMake(ScreenWidth, 80));
            make.right.mas_equalTo(self.mas_right).offset(-OverAllLeft_OR_RightSpace);
            make.bottom.mas_equalTo(self.mas_bottom).offset(-15);
        }];
        
        UILabel *placeholderLabel = [UILabel new];
        placeholderLabel.text = NSStringFormat(@"%@...",LocalizationKey(@"AppealTip1")) ;
        placeholderLabel.font = [UIFont systemFontOfSize:13.f];
        placeholderLabel.textColor = [UIColor grayColor];
        placeholderLabel.numberOfLines = 0;
        [placeholderLabel sizeToFit];
        [self.detailText addSubview:placeholderLabel];
        [self.detailText setValue:placeholderLabel forKey:@"_placeholderLabel"];
        
    }
    return self;
}

@end
