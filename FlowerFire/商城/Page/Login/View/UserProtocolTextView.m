//
//  UserProtocolTextView.m
//  531Mall
//
//  Created by 王涛 on 2020/6/10.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "UserProtocolTextView.h"
#import "UserProtocolViewController.h"

@implementation UserProtocolTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
        self.textColor = KBlackColor;
        self.font = tFont(13);
        NSString *textStr = @"注册或登录即代表您同意《用户协议》";
        NSRange   protocolRange = [textStr rangeOfString:@"《用户协议》"];
         
        NSMutableAttributedString *ma = [[NSMutableAttributedString alloc] initWithString:textStr];
        [ma yy_setTextHighlightRange:protocolRange color:MainColor backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            UserProtocolViewController *uvc = [UserProtocolViewController new];
            [[self viewController].navigationController pushViewController:uvc animated:YES];
        }];
        
        self.attributedText = ma;
        self.textAlignment = NSTextAlignmentCenter;
   
    }
    return self;
}

@end
