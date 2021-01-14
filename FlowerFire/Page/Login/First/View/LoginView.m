//
//  LoginView.m
//  FlowerFire
//
//  Created by 王涛 on 2020/4/30.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "LoginView.h"
#import "FFProtocolTextView.h"

@interface LoginView ()
{
    UIScrollView   *_scrollView;
    UIImageView    *_logo;
    UILabel        *_welcome;
    WTLabel        *_appNameLabel;
    UIButton       *_backButton;
    WTButton       *_createAccountButton,*_improtAccountButton,*_protocolButton;
    FFProtocolTextView *_protocolTextView;
    WTButton       *_switchLanaguageButton;
}
@end

@implementation LoginView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
        [self layoutSubview];
        [self addTarget];
    }
    return self;
}

-(void)addTarget{
    @weakify(self)
    [[_backButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        if([self.delegate respondsToSelector:@selector(popVC)]){
            [self.delegate popVC];
        };
    }];
    
    [_createAccountButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        @strongify(self)
        if(self->_protocolButton.isSelected){
            if([self.delegate respondsToSelector:@selector(createAccountClick)]){
                [self.delegate createAccountClick];
            };
        }else{
            printAlert(LocalizationKey(@"578Tip161"), 1.f);
        }
        
    }];
    
    [_improtAccountButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        @strongify(self)
        if(self->_protocolButton.isSelected){
            if([self.delegate respondsToSelector:@selector(improtAccountClick)]){
                [self.delegate improtAccountClick];
            };
        }else{
            printAlert(LocalizationKey(@"578Tip161"), 1.f);
        }
        
    }];
    
    [_protocolButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(UIButton *sender) {
        sender.selected = !sender.selected;
    }];
    
    [_switchLanaguageButton addTarget:self action:@selector(switchLanguageClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)createUI{
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.bounces = NO;
    [self addSubview:_scrollView];
    
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _backButton.hidden = YES;
    [_backButton theme_setImage:@"top_bar_back_nomal" forState:UIControlStateNormal];
    [_scrollView addSubview:_backButton];
    
    NSString *details = @"";
    if ([[ChangeLanguage userLanguage] isEqualToString:@"en"]) {
        details = @"English";
    }else if ([[ChangeLanguage userLanguage] isEqualToString:@"zh-Hans"])
    {
        details = @"简体中文";
    }
    
    _switchLanaguageButton = [[WTButton alloc] initWithFrame:CGRectZero titleStr:details titleFont:tFont(15) titleColor:MainBlueColor parentView:_scrollView];
    _switchLanaguageButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    
    _logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-76"]];
    [_scrollView addSubview:_logo];
    
    
    _welcome = [UILabel new];
    _welcome.textAlignment = NSTextAlignmentCenter;
    _welcome.font = [UIFont boldSystemFontOfSize:25];
    _welcome.theme_textColor = THEME_TEXT_COLOR;
    _welcome.numberOfLines = 2;
    _welcome.text = LocalizationKey(@"loginTip1");
    [_scrollView addSubview:_welcome];
    
    _createAccountButton = [[WTButton alloc] initWithFrame:CGRectZero titleStr:LocalizationKey(@"578Tip159") titleFont:tFont(18) titleColor:KWhiteColor parentView:_scrollView];
    _createAccountButton.backgroundColor = MainBlueColor;
    _createAccountButton.layer.cornerRadius = 5;
    
    _improtAccountButton = [[WTButton alloc] initWithFrame:CGRectZero titleStr:LocalizationKey(@"578Tip160") titleFont:tFont(18) titleColor:KWhiteColor parentView:_scrollView];
    _improtAccountButton.backgroundColor = MainBlueColor;
    _improtAccountButton.layer.cornerRadius = 5;
    
    _protocolButton = [[WTButton alloc] initWithFrame:CGRectZero buttonImage:[UIImage imageNamed:@"Unselected"] selectedImage:[UIImage imageNamed:@"zhglxz"] parentView:_scrollView];
    _protocolButton.selected = YES;
    _protocolButton.hidden = YES;
    
    _protocolTextView = [[FFProtocolTextView alloc] initWithFrame:CGRectZero];
    [_scrollView addSubview:_protocolTextView];
    _protocolTextView.hidden = YES;
}

- (void)layoutSubview{
    _backButton.frame = CGRectMake(OverAllLeft_OR_RightSpace, SafeIS_IPHONE_X, 30, 30);
    
    _switchLanaguageButton.frame = CGRectMake(ScreenWidth - OverAllLeft_OR_RightSpace - 100, _backButton.centerY - 15, 100, 30);
    
    _logo.frame = CGRectMake(ScreenWidth/2 -LoginModuleLeftSpace, ScreenHeight / 7, 80, 80);
    _welcome.frame = CGRectMake(0, _logo.ly_maxY + 30, ScreenWidth, 80);
     
    _createAccountButton.frame = CGRectMake(ScreenWidth * 0.2, self.centerY - 80 , ScreenWidth*0.6, 50);
    
    _improtAccountButton.frame = CGRectMake(_createAccountButton.left, _createAccountButton.bottom + 20, _createAccountButton.width, _createAccountButton.height);
    
    [_protocolTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom).offset(-60);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake([HelpManager getLabelWidth:13 labelTxt:_protocolTextView.text].width, 30));
    }];
    
    [_protocolButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_protocolTextView.mas_left);
        make.centerY.mas_equalTo(_protocolTextView.mas_centerY);
    }];
    
    _scrollView.contentSize = CGSizeMake(ScreenWidth, 896);
}

-(void)switchLanguageClick:(UIButton *)btn{
    if([btn.titleLabel.text isEqualToString:@"简体中文"]){
        [ChangeLanguage setUserlanguage:@"en"];
    }else if([btn.titleLabel.text isEqualToString:@"English"]){
        [ChangeLanguage setUserlanguage:@"zh-Hans"];
    }
    
    [self removeAllSubviews];
    
    [self createUI];
    [self layoutSubview];
    [self addTarget];
    
}

-(void)switchLanguageHandler{
    //_welcome.text = LocalizationKey(@"loginTip1");
     
}


@end
