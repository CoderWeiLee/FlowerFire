//
//  FFProtocolTextView.m
//  FlowerFire
//
//  Created by 王涛 on 2020/9/8.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "FFProtocolTextView.h"

@implementation FFProtocolTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.editable = NO;
        self.textColor = KBlackColor;
        self.font = tFont(13);
        NSString *textStr = LocalizationKey(@"578Tip157");
        NSRange   protocolRange = [textStr rangeOfString:LocalizationKey(@"578Tip158")];
         
        NSMutableAttributedString *ma = [[NSMutableAttributedString alloc] initWithString:textStr];
        [ma yy_setTextHighlightRange:protocolRange color:MainColor backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            NSString *protocolURLStr = NSStringFormat(@"%@/web/#/help/articlelist/9",BASE_URL);
            [[WTPageRouterManager sharedInstance] jumpToWebView:[self viewController].navigationController urlString:protocolURLStr];
        }];
        
        self.attributedText = ma;
        self.textAlignment = NSTextAlignmentCenter;
   
    }
    return self;
}

@end
