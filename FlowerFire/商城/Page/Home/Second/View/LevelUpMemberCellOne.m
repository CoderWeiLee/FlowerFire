//
//  LevelUpMemberCellOne.m
//  531Mall
//
//  Created by 王涛 on 2020/5/22.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "LevelUpMemberCellOne.h"

@implementation LevelUpMemberCellOne

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self createUI];
    }
    return self;
}

- (void)createUI{
    UIView *rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xia2"]];
    rightView.frame = CGRectMake(0, 0, 22, 22);
         
    self.loginInputView = [[LoginInputView alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, 16, ScreenWidth - 2 * OverAllLeft_OR_RightSpace, 45) placeholderStr:@"" rightView:rightView];
    [self addSubview:self.loginInputView];
    self.loginInputView.enabled = NO;
}

  

@end
