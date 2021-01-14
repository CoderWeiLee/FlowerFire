//
//  MyOrderReturnPopView.m
//  531Mall
//
//  Created by 王涛 on 2020/5/21.
//  Copyright © 2020 Celery. All rights reserved.
//  退货弹窗

#import "MyOrderReturnPopView.h"
#import <YYText.h>
#import "UIImage+jianbianImage.h"

@interface MyOrderReturnPopView ()
{
    YYTextView           *_textView;
    UIView               *_bacView;
    UIImageView          *_closeImage;
    UIButton             *_submitButton;
}
@end

@implementation MyOrderReturnPopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
        [self layoutSubview];
    }
    return self;
}

- (void)createUI{
    _bacView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.height - 54)];
    _bacView.backgroundColor = KWhiteColor;
    _bacView.layer.cornerRadius = 10;
    [self addSubview:_bacView];
    
    _textView = [[YYTextView alloc] initWithFrame:CGRectMake(26.5, 23, _bacView.width - 26.5 * 2, 100)];
    _textView.backgroundColor= KWhiteColor;
    _textView.font = tFont(13);
    _textView.textColor = rgba(51, 51, 51, 1);
    _textView.placeholderFont = tFont(13);
    _textView.placeholderText = @"请填写退货原因";
    _textView.layer.cornerRadius = 5;
    _textView.layer.borderWidth = 0.5;
    _textView.layer.borderColor = rgba(204, 204, 204, 1).CGColor;
    [_bacView addSubview:_textView];
    
    _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_submitButton setTitle:@"确认退货" forState:UIControlStateNormal];
    _submitButton.layer.cornerRadius = 20;
    _submitButton.layer.masksToBounds = YES;
    _submitButton.titleLabel.font = tFont(18);
    [_submitButton addTarget:self action:@selector(returnSubmitClick) forControlEvents:UIControlEventTouchUpInside];
    [_submitButton setBackgroundImage:[UIImage gradientColorImageFromColors:MaingradientColor gradientType:GradientTypeLeftToRight imgSize:CGSizeMake(_textView.width, 40)] forState:UIControlStateNormal];
    
    [_bacView addSubview:_submitButton];
    
    _closeImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"close"]];
    _closeImage.userInteractionEnabled = YES;
    [_closeImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closePopClick)]];
    [self addSubview:_closeImage];
}

- (void)layoutSubview{
    _submitButton.frame = CGRectMake(_textView.ly_x, _textView.ly_maxY + 20, _textView.ly_width, 40);
    _closeImage.frame = CGRectMake((_bacView.width-54)/2, _bacView.ly_maxY, 54, 54);
}

-(void)closePopClick{
    !self.closePopViewBlock ? : self.closePopViewBlock();
}

-(void)returnSubmitClick{
    if([HelpManager isBlankString:_textView.text]){
        printAlert(@"请输入退货原因", 1.f);
        return;
    }
    !self.returnGoodsBlock ? : self.returnGoodsBlock(_textView.text);
}

@end
