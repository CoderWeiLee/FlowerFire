//
//  RegisteredTextField.m
//  FlowerFire
//
//  Created by 王涛 on 2020/5/14.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "RegisteredTextField.h"

@implementation RegisteredTextField

- (void)layoutSubview{
    self.title.frame = CGRectZero;
    
    self.loginInputView.frame = CGRectMake(0, self.title.ly_maxY + 10, ScreenWidth - 80, 40);
    
    self.rightView.frame = CGRectMake(0, 0, 30, 30);
    self.rightButton.frame = self.rightView.bounds;
    self.line.frame = CGRectMake(0, self.loginInputView.height, self.loginInputView.ly_width, 1);
    self.height = self.loginInputView.ly_maxY;
}

@end
