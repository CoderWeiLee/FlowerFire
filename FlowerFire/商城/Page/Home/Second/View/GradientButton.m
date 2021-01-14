//
//  GradientButton.m
//  531Mall
//
//  Created by 王涛 on 2020/5/22.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "GradientButton.h"
#import "UIImage+jianbianImage.h"

@implementation GradientButton

- (instancetype)initWithFrame:(CGRect)frame titleStr:(NSString *)titleStr{
    self = [super initWithFrame:frame];
    if(self){
        [[HelpManager sharedHelpManager] jianbianMainColor:self size:frame.size];
        [self setTitle:titleStr forState:UIControlStateNormal];
    }
    return self;
}

@end
