//
//  LightningChargeFormView.m
//  FireCoin
//
//  Created by 王涛 on 2020/8/13.
//  Copyright © 2020 王涛. All rights reserved.
//

#import "LightningChargeFormView.h"

@interface LightningChargeFormView ()
{
    
}
@end

@implementation LightningChargeFormView

- (instancetype)initWithFrame:(CGRect)frame leftText:(NSString *)leftText placeHolderStr:(NSString *)placeHolderStr
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 5;
      //  self.backgroundColor = rgba(247, 245, 251, 1);
        
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 155, 45)];
        
        [leftView addSubview:[[WTLabel alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, 0, 150, 45) Text:leftText Font:tFont(17) textColor:rgba(51, 51, 51, 1) parentView:leftView]];
        
        self.leftView = leftView;
        self.leftViewMode = UITextFieldViewModeAlways;
        
        self.placeholder = placeHolderStr;
        
//        UIView *bac = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 45)];
//        self.rightView = bac;
        self.rightViewMode = UITextFieldViewModeAlways;
        
        self.font = tFont(17);
        self.textAlignment = NSTextAlignmentRight;
    }
    return self;
}

 

@end
