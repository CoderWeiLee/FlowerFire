//
//  LoginCell.m
//  531Mall
//
//  Created by 王涛 on 2020/5/22.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "LoginCell.h"
#import "PooCodeView.h"
#import "UIImage+jianbianImage.h"

@interface LoginCell ()
{
    BOOL isFirstInit; //防止刷新多次创建
}
@end

@implementation LoginCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        isFirstInit = YES;
    }
    return self;
}

- (void)setCellData:(NSDictionary *)dic{
    if(isFirstInit){
        NSString *placeholderStr = dic[@"placeholderStr"];
          NSString *rightViewStr = dic[@"rightView"];
        
        UIView *rightView = nil;
        if([rightViewStr isEqualToString:@"xia2"]){
            rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:rightViewStr]];
            rightView.frame = CGRectMake(0, 0, 22, 22);
            
        }
          
        self.loginInputView = [[LoginInputView alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, 16, ScreenWidth - 2 * OverAllLeft_OR_RightSpace, 45) placeholderStr:placeholderStr rightView:rightView];
        [self addSubview:self.loginInputView];
    }
     
}

- (void)setLoginCellData:(NSDictionary *)dic{
    if(isFirstInit){
        isFirstInit = NO;
        NSString *placeholderStr = dic[@"placeholderStr"];
        NSString *rightViewStr = dic[@"rightView"];
        
        UIView *rightView = nil;
        if([rightViewStr isEqualToString:@"imageCode"]){
            rightView = [UIButton buttonWithType:UIButtonTypeCustom];  
            rightView.frame = CGRectMake(0,0, 100, 30);
            [(UIButton *)rightView setTitleColor:KBlackColor forState:UIControlStateNormal];
            [[(UIButton *)rightView titleLabel] setFont:tFont(13)];
            [(UIButton *)rightView setTitle:@"获取图形验证码" forState:UIControlStateNormal];
           [(UIButton *)rightView addTarget:self action:@selector(getImageCodeClick:) forControlEvents:UIControlEventTouchUpInside];
             
//            rightView = [[PooCodeView alloc] initWithFrame:CGRectMake(0, 0, 85, 30) andChangeArray:nil];
        }
        
      
        
        if([rightViewStr isEqualToString:@"phoneCode"]){
            rightView = [UIButton buttonWithType:UIButtonTypeCustom];
            [(UIButton *)rightView setTitle:@"获取验证码" forState:UIControlStateNormal];
            rightView.layer.cornerRadius = 5;
            rightView.layer.masksToBounds = YES;
            rightView.frame = CGRectMake(0,0, 100, 25);
            [[(UIButton *)rightView titleLabel] setFont:tFont(13)];
            [(UIButton *)rightView setBackgroundImage:[UIImage gradientColorImageFromColors:MaingradientColor gradientType:GradientTypeLeftToRight imgSize:rightView.size] forState:UIControlStateNormal];
            [(UIButton *)rightView addTarget:self action:@selector(getCodeClick:) forControlEvents:UIControlEventTouchUpInside];
        }
         
        self.loginInputView = [[LoginInputView alloc] initWithFrame:CGRectMake(47.5, 16, ScreenWidth - 2 * 47.5, 41) placeholderStr:placeholderStr rightView:rightView];
        [self addSubview:self.loginInputView];
        
        if([dic[@"keyBoardType"] isEqualToString:@"phone"]){
            self.loginInputView.keyboardType = UIKeyboardTypePhonePad;
        }else if([dic[@"keyBoardType"] isEqualToString:@"number"]){
            self.loginInputView.keyboardType = UIKeyboardTypeNumberPad;
        }else{
            self.loginInputView.keyboardType = UIKeyboardTypeDefault;
        }
        
        if([dic[@"isSafeInput"] isEqualToString:@"1"]){
            self.loginInputView.secureTextEntry = YES;
        }else{
            self.loginInputView.secureTextEntry = NO;
        }
        if([rightViewStr isEqualToString:@"phoneCode"]){
            if (@available(iOS 12.0, *)) {
                self.loginInputView.textContentType = UITextContentTypeOneTimeCode;
            }
            if (@available(iOS 10.0, *)) {
                self.loginInputView.textContentType = @"one-time-code";
            }
        } 
    }
     
}

-(void)getCodeClick:(UIButton *)btn{
    !self.getCodeBlock ? : self.getCodeBlock(btn);
}

-(void)getImageCodeClick:(UIButton *)btn{
    !self.getImageCodeBlock ? : self.getImageCodeBlock(btn);
}

@end
 
