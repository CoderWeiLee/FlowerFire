//
//  TransferHeaderView.m
//  FireCoin
//
//  Created by 王涛 on 2019/6/1.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "TransferHeaderView.h"

@interface TransferHeaderView()
{
    
}

@end

@implementation TransferHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //self.backgroundColor = navBarColor;
        [self setTheme_backgroundColor:THEME_CELL_BACKGROUNDCOLOR];
        UIView *bac = [[UIView alloc] initWithFrame:CGRectMake(20, 20, ScreenWidth - 40, 90)];
        bac.layer.cornerRadius = 3;
        bac.layer.theme_borderColor = THEME_LINE_INPUTBORDERCOLOR;
        bac.layer.borderWidth = 1;
        [self addSubview:bac];
        
        UIView *circle = [UIView new];
        circle.layer.cornerRadius = 3;
        circle.backgroundColor = rgba(30, 135, 217, 1);
        [bac addSubview:circle];
        [circle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(bac.mas_top).offset(20);
            make.left.mas_equalTo(bac.mas_left).offset(15);
            make.size.mas_equalTo(@[@6,@6]);
        }];
        
        UIView *circle1 = [UIView new];
        circle1.layer.cornerRadius = 3;
        circle1.backgroundColor = rgba(218, 71, 96, 1);
        [bac addSubview:circle1];
        [circle1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(bac.mas_bottom).offset(-20);
            make.left.mas_equalTo(bac.mas_left).offset(15);
            make.size.mas_equalTo(@[@6,@6]);
        }];
        
        UILabel *fromLabel = [UILabel new];
        fromLabel.text = LocalizationKey(@"From");
        fromLabel.textColor = grayTextColor;
        fromLabel.font = tFont(15);
        fromLabel.layer.masksToBounds = YES;
        fromLabel.backgroundColor = self.backgroundColor;
        [bac addSubview:fromLabel];
        [fromLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(circle.mas_right).offset(15);
            make.centerY.mas_equalTo(circle.mas_centerY);
            make.width.mas_equalTo(40);
        }];
        
        UILabel *toLabel = [UILabel new];
        toLabel.text = LocalizationKey(@"To");
        toLabel.textColor = grayTextColor;
        toLabel.font = tFont(15);
        toLabel.layer.masksToBounds = YES;
        toLabel.backgroundColor = self.backgroundColor;
        [bac addSubview:toLabel];
        [toLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(circle.mas_right).offset(15);
            make.centerY.mas_equalTo(circle1.mas_centerY);
            make.width.mas_equalTo(40);
        }];
        
        UIView *line = [UIView new];
        line.theme_backgroundColor = THEME_LINE_INPUTBORDERCOLOR;
        [bac addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(bac.mas_centerY);
            make.left.mas_equalTo(fromLabel.mas_left);
            make.right.mas_equalTo(bac.mas_right).offset(-70);
            make.height.mas_equalTo(1);
        }];
        
        UIButton *turnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        turnBtn.theme_backgroundColor = THEME_TRANSFER_BACKGROUNDCOLOR;
        [turnBtn theme_setImage:@"transfer" forState:UIControlStateNormal];
        [bac addSubview:turnBtn];
        [turnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(bac.mas_right);
            make.top.mas_equalTo(bac.mas_top);
            make.size.mas_equalTo(CGSizeMake(70, 90));
        }];
        
        self.legalCurrencyAccount = [UILabel new];
        self.legalCurrencyAccount.text = @"法币账户";
        self.legalCurrencyAccount.textAlignment = NSTextAlignmentLeft;
        self.legalCurrencyAccount.theme_textColor = THEME_TEXT_COLOR;
        self.legalCurrencyAccount.font = tFont(16);
        [bac addSubview:self.legalCurrencyAccount];
        [self.legalCurrencyAccount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(fromLabel.mas_right).offset(15);
            make.centerY.mas_equalTo(circle.mas_centerY);
            make.right.mas_equalTo(turnBtn.mas_left);
            make.height.mas_equalTo(40);
        }];
        
        self.coinAccount = [UILabel new];
        self.coinAccount.text = @"币币账户";
        self.coinAccount.textAlignment = NSTextAlignmentLeft;
        self.coinAccount.theme_textColor = THEME_TEXT_COLOR;
        self.coinAccount.font = tFont(16); 
        [bac addSubview:self.coinAccount];
        [self.coinAccount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(fromLabel.mas_right).offset(15);
            make.centerY.mas_equalTo(circle1.mas_centerY);
            make.right.mas_equalTo(turnBtn.mas_left);
            make.height.mas_equalTo(40);
        }];
        
        [turnBtn addTarget:self action:@selector(turnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

#pragma mark - action
-(void)turnClick{
    if(self.isCoinAccountAbove){
        [self.legalCurrencyAccount.layer addAnimation:[self moveX:0.5 X:[NSNumber numberWithFloat:0]] forKey:nil];
        [self.coinAccount.layer addAnimation:[self moveX:0.5 X:[NSNumber numberWithFloat:0]] forKey:nil];
    }else{
        CGFloat y =  self.legalCurrencyAccount.frame.origin.y;
        CGFloat y1 = self.coinAccount.frame.origin. y ;
        CGFloat y2 = y1 - y;
        
        [self.legalCurrencyAccount.layer addAnimation:[self moveX:0.5 X:[NSNumber numberWithFloat:y2]] forKey:nil];
        [self.coinAccount.layer addAnimation:[self moveX:0.5 X:[NSNumber numberWithFloat:-y2]] forKey:nil];
    }
    self.isCoinAccountAbove = !self.isCoinAccountAbove;
    !self.switchTransTypeBlock ? : self.switchTransTypeBlock(self.isCoinAccountAbove);
}

#pragma mark =====横向、纵向移动===========
-(CABasicAnimation *)moveX:(float)time X:(NSNumber *)x
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];///.y的话就向下移动。
    animation.toValue = x;
    animation.duration = time;
    animation.removedOnCompletion = NO;//yes的话，又返回原位置了。
    animation.repeatCount = 1;
    animation.fillMode = kCAFillModeForwards;
    return animation;
}

@end
