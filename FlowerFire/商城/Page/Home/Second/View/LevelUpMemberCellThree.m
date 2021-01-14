//
//  LevelUpMemberCellThree.m
//  531Mall
//
//  Created by 王涛 on 2020/5/22.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "LevelUpMemberCellThree.h"

@interface LevelUpMemberCellThree ()
{
    UILabel *_leftTip;
}
@end

@implementation LevelUpMemberCellThree

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self createUI];
        [self layoutSubview];
    }
    return self;
}

- (void)createUI{
     _leftTip = [[UILabel alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, 0, 200, 20)];
     _leftTip.text = @"支付凭证:";
     _leftTip.font = tFont(13);
     _leftTip.textAlignment = NSTextAlignmentLeft;
     _leftTip.textColor = rgba(51, 51, 51, 1);
     [self addSubview:_leftTip];
    
    
     self.uploadButton = [UIButton buttonWithType:UIButtonTypeCustom];
     [self.uploadButton setImage:[UIImage imageNamed:@"tus"] forState:UIControlStateNormal];
     [self addSubview:self.uploadButton];
       
}

- (void)layoutSubview{
    [self.uploadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(140, 80));
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(_leftTip.mas_bottom).offset(15);
    }];
}

@end
