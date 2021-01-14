//
//  WTLabel.m
//  FilmCrowdfunding
//
//  Created by 王涛 on 2019/11/13.
//  Copyright © 2019 Celery. All rights reserved.
//

#import "WTLabel.h"

@implementation WTLabel

- (instancetype)init
{
    self = [super init];
    if (self) {
        //防止过度渲染
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //防止过度渲染
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame Text:(NSString *)text Font:(UIFont *)font textColor:(UIColor *)textColor parentView:(UIView *)parentView{
    self = [super initWithFrame:frame];
    if (self) {
        self.text = text;
        self.font = font;
        self.textColor = textColor;
        if(parentView){
            [parentView addSubview:self];
        }
        
    }
    return self;
}

 

@end
