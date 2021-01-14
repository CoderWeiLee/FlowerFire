//
//  IntroductionFotterView.m
//  FireCoin
//
//  Created by 王涛 on 2019/7/5.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "IntroductionFooterView.h"

@interface IntroductionFooterView ()
{
    UILabel *tip ;
}
@end

@implementation IntroductionFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
        line.theme_backgroundColor = THEME_LINE_TABLEVIEW_SEPARATOR_COLOR;
        [self addSubview:line];
        
        tip = [[UILabel alloc] initWithFrame:CGRectMake(15, 30, ScreenWidth, 30)];
        tip.theme_textColor = THEME_TEXT_COLOR;
        tip.font = tFont(20);
        tip.text = LocalizationKey(@"Introduction");
        tip.backgroundColor = self.backgroundColor;
        tip.layer.masksToBounds = YES;
        [self addSubview:tip];
        
        self.content = [[UITextView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(tip.frame)+20, ScreenWidth - 30, frame.size.height - 30 - 30 - 20)];
        self.content.backgroundColor = self.backgroundColor;
        self.content.font = tFont(16);
        self.content.theme_textColor = THEME_GRAY_TEXTCOLOR;
        self.content.layer.masksToBounds = YES;
        self.content.bounces = NO;
        self.content.userInteractionEnabled = NO;
        [self addSubview:self.content];
    }
    return self;
}

-(void)setTextStr:(NSString *)textStr bacHeight:(CGFloat)bacHeight{
    self.frame = CGRectMake(0, 0, ScreenWidth, bacHeight);
    self.content.frame = CGRectMake(15, CGRectGetMaxY(tip.frame)+20, ScreenWidth - 30, bacHeight - 30 - 30 - 20);
    self.content.text = textStr;
}

@end
