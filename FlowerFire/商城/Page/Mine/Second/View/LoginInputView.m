//
//  LoginInputView.m
//  531Mall
//
//  Created by 王涛 on 2020/5/22.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "LoginInputView.h"

@implementation LoginInputView

- (instancetype)initWithFrame:(CGRect)frame placeholderStr:(NSString *)placeholderStr rightView:(nonnull UIView *)rightView{
    self = [super initWithFrame:frame];
    if(self){
        self.font = tFont(13);
        self.placeholder = placeholderStr;
        self.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        self.layer.shadowColor = [UIColor colorWithRed:153/255.0 green:174/255.0 blue:223/255.0 alpha:0.2].CGColor;
        self.layer.shadowOffset = CGSizeMake(0,5);
        self.layer.shadowOpacity = 1;
        self.layer.shadowRadius = 9;
        self.layer.cornerRadius = 5;
        
        UIView *lefView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, self.height)];
        self.leftView = lefView;
        self.leftViewMode = UITextFieldViewModeAlways;
        
        if(rightView){
            UIView *rightPlaceholder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rightView.width+17, rightView.height)];
            [rightPlaceholder addSubview:rightView];
            self.rightView = rightPlaceholder;
            self.rightViewMode = UITextFieldViewModeAlways;
        }
    }
    return self;
}

@end
