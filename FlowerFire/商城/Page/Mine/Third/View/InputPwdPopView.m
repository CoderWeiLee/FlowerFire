//
//  InputPwdPopView.m
//  531Mall
//
//  Created by 王涛 on 2020/6/8.
//  Copyright © 2020 Celery. All rights reserved.
//  

#import "InputPwdPopView.h"

@interface InputPwdPopView ()
{
    UIView       *_bacView;
    UIImageView  *_closeImage;
    UILabel      *_title;
}
@end

@implementation InputPwdPopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
        [self layoutSubview];
    }
    return self;
}

-(void)closePopClick{
    !self.closePopViewBlock ? : self.closePopViewBlock();
}

-(void)createUI{
    _bacView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.height - 54)];
    _bacView.backgroundColor = KWhiteColor;
    _bacView.layer.cornerRadius = 5;
    [self addSubview:_bacView];
    
    _title = [[UILabel alloc] initWithFrame:CGRectMake(_bacView.ly_x, _bacView.ly_y+21.5,_bacView.width, 17.5)];
    _title.text = @"请输入支付密码";
    _title.textAlignment = NSTextAlignmentCenter;
    _title.textColor = rgba(51, 51, 51, 1);
    _title.font = tFont(18);
    [_bacView addSubview:_title];
     
    _pwdInputView = [[CRBoxInputView alloc] initWithCodeLength:6];
    _pwdInputView.frame = CGRectMake(_bacView.ly_x + 14, _title.ly_maxY + 27, _bacView.width - 14 * 2, 32);
    _pwdInputView.ifNeedSecurity = YES;
    [_pwdInputView loadAndPrepareViewWithBeginEdit:NO];
    [_bacView addSubview:_pwdInputView];
        
    _closeImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"close"]];
    _closeImage.userInteractionEnabled = YES;
    [_closeImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closePopClick)]];
    [self addSubview:_closeImage];
}

- (void)layoutSubview{  
    _closeImage.frame = CGRectMake((_bacView.width-54)/2, _bacView.ly_maxY, 54, 54);
}

@end
