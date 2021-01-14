//
//  SubmitPayPopView.m
//  531Mall
//
//  Created by 王涛 on 2020/5/23.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "SubmitPayPopView.h"

@interface SubmitPayPopView ()
{
    UIView          *_bacView;
    UILabel         *_title;
 
    UIView          *_line;
    UILabel         *_payMethodTip;


    UIImageView     *_closeImage;
}
@end

@implementation SubmitPayPopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
        [self layoutSubview];
         
       
    }
    return self;
}

//-(void)choosePayMethodClick:(UIButton *)btn{
//    if([self.delegate respondsToSelector:@selector(choosePayMethodClick:)]){
//        [self.delegate choosePayMethodClick:btn];
//    }
//}

-(void)closePopClick{
    !self.closePopViewBlock ? : self.closePopViewBlock();
}

- (void)createUI{
    _bacView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.height - 54)];
    _bacView.backgroundColor = KWhiteColor;
    _bacView.layer.cornerRadius = 10;
    [self addSubview:_bacView];
    
    _title = [UILabel new];
    _title.text = @"请输入密码";
    _title.textColor = rgba(51, 51, 51, 1);
    _title.font = tFont(18);
    [_bacView addSubview:_title];
    
    _price = [UILabel new];
    _price.text = @"¥--";
    _price.textColor = MainColor;
    _price.font = tFont(25);
    [_bacView addSubview:_price];
    
    _line = [UIView new];
    _line.backgroundColor = rgba(245, 245, 245, 1);
    [_bacView addSubview:_line];
    
    _payMethodTip = [UILabel new];
    _payMethodTip.text = @"支付方式";
    _payMethodTip.textColor = rgba(51, 51, 51, 1);
    _payMethodTip.font = tFont(13);
    [_bacView addSubview:_payMethodTip];
    
    _choosePayMethodButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_choosePayMethodButton setTitle:@"" forState:UIControlStateNormal];
    [_choosePayMethodButton setTitleColor:MainColor forState:UIControlStateNormal];
    _choosePayMethodButton.titleLabel.font = tFont(13);
  //  [_choosePayMethodButton addTarget:self action:@selector(choosePayMethodClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bacView addSubview:_choosePayMethodButton];
    
    _pwdInputView = [[CRBoxInputView alloc] initWithCodeLength:6]; 
    _pwdInputView.ifNeedSecurity = YES;
    [_pwdInputView loadAndPrepareViewWithBeginEdit:NO];
    [_bacView addSubview:_pwdInputView];
    
    _closeImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"close"]];
    _closeImage.userInteractionEnabled = YES;
    [_closeImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closePopClick)]];
    [self addSubview:_closeImage];
}

- (void)layoutSubview{
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_bacView.mas_top).offset(21.5);
        make.centerX.mas_equalTo(_bacView.mas_centerX);
    }];
    
    [_price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_title.mas_bottom).offset(20);
        make.centerX.mas_equalTo(_bacView.mas_centerX);
    }];
    
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_price.mas_bottom).offset(18);
        make.centerX.mas_equalTo(_bacView.mas_centerX);
        make.height.mas_equalTo(0.5);
        make.left.mas_equalTo(_bacView.mas_left).offset(12.5);
        make.right.mas_equalTo(_bacView.mas_right).offset(-12.5);
    }];
    
    [_payMethodTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_line.mas_bottom).offset(11.5);
        make.left.mas_equalTo(_line.mas_left);
    }];
    
    [_choosePayMethodButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_payMethodTip.mas_centerY);
        make.right.mas_equalTo(_line.mas_right);
        make.size.mas_equalTo(CGSizeMake(100, 30));
    }];
     
    [_pwdInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_payMethodTip.mas_bottom).offset(20);
        make.left.mas_equalTo(_bacView.mas_left).offset(15);
        make.right.mas_equalTo(_bacView.mas_right).offset(-15);
        make.height.mas_equalTo(32);
    }];
    
    _closeImage.frame = CGRectMake((_bacView.width-54)/2, _bacView.ly_maxY, 54, 54);
}

@end
