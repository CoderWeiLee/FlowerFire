//
//  kyc1PopView.m
//  FlowerFire
//
//  Created by 王涛 on 2020/5/12.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "Kyc1PopView.h"

@interface Kyc1PopView ()
{
    UIView  *_topView;
    UILabel *_titleLabel;
    UILabel *_detailsLabel;
    UIButton *_cancelButton,*_verifiedButton;
    UIView  *_line,*_line1;
}
@end

@implementation Kyc1PopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
        [self layoutSubview];
    }
    return self;
}
 
-(void)jumpKycVCClick{
    !self.jumpKycVCBlock ? : self.jumpKycVCBlock();
}

-(void)dissmissPopClick{
    !self.dissmissPopBlock ? : self.dissmissPopBlock();
}

- (void)createUI{
    self.layer.cornerRadius = 10;
    self.theme_backgroundColor = THEME_MAIN_BACKGROUNDCOLOR;
    self.clipsToBounds = YES;
    
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 160)];
    _topView.backgroundColor = MainColor;
    [self addSubview:_topView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _topView.ly_maxY + 10, self.width, 20)];
    _titleLabel.font = tFont(15);
    _titleLabel.text = LocalizationKey(@"Kyc certification");
    _titleLabel.theme_textColor = THEME_TEXT_COLOR;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
    
    _detailsLabel = [[UILabel alloc] init];
    _detailsLabel.text = LocalizationKey(@"KycTip6");
    _detailsLabel.font = tFont(14);
    _detailsLabel.numberOfLines = 4;
    _detailsLabel.textAlignment = NSTextAlignmentCenter;
    _detailsLabel.theme_textColor = THEME_GRAY_TEXTCOLOR;
    [self addSubview:_detailsLabel];
    
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelButton setTitle:LocalizationKey(@"cancel") forState:UIControlStateNormal];
    [_cancelButton theme_setTitleColor:THEME_TEXT_COLOR forState:UIControlStateNormal];
    [_cancelButton.titleLabel setFont:tFont(15)];
    [self addSubview:_cancelButton];
    
    _verifiedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_verifiedButton setTitle:LocalizationKey(@"Go to certification") forState:UIControlStateNormal];
    [_verifiedButton setTitleColor:MainColor forState:UIControlStateNormal];
    [_verifiedButton.titleLabel setFont:tFont(15)];
    [self addSubview:_verifiedButton];
    
    _line = [UIView new];
    _line.theme_backgroundColor = THEME_LINE_TABLEVIEW_SEPARATOR_COLOR;
    [self addSubview:_line];
    
    _line1 = [UIView new];
    _line1.theme_backgroundColor = THEME_LINE_TABLEVIEW_SEPARATOR_COLOR;
    [self addSubview:_line1];
    
    [_cancelButton addTarget:self action:@selector(dissmissPopClick) forControlEvents:UIControlEventTouchUpInside];
    [_verifiedButton addTarget:self action:@selector(jumpKycVCClick) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)layoutSubview{
    [_detailsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(15);
        make.left.mas_equalTo(OverAllLeft_OR_RightSpace);
        make.right.mas_equalTo(-OverAllLeft_OR_RightSpace);
    }];
    
    CGFloat buttonHeight = 50;
    
    _cancelButton.frame = CGRectMake(0, self.height - buttonHeight, self.width/2, buttonHeight);
    _verifiedButton.frame = CGRectMake(_cancelButton.ly_maxX, self.height - buttonHeight, self.width/2, buttonHeight);
    _line.frame = CGRectMake(0, _cancelButton.ly_y, self.width, 1);
    _line1.frame = CGRectMake(self.center.x, _cancelButton.ly_maxY - buttonHeight + 7.5, 1, 35);
    
}

@end
