//
//  TaskMainCell.m
//  531Mall
//
//  Created by 王涛 on 2020/5/19.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "TaskMainCell.h"
#import "UIImage+jianbianImage.h"

@interface TaskMainCell ()
{
    UIImageView *_taskImage;
    UILabel     *_title,*_details;
    
    UIView      *_bacView;
    CGSize      _buttonSize;
}
@end

@implementation TaskMainCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self createUI];
        [self layoutSubview];
    }
    return self;
}

/**
 is_get=-1或0是去完成（－1调领取任务接口，并跳转到对应接口，0只是跳转）
 is_get=1且is_reward=0是领取奖励
 is_reward=1是已领取奖励。
 */
- (void)setCellData:(TaskModel *)model{
    _title.text = model.name;
    _details.text = NSStringFormat(@"%@ 任务奖励:%@",model.details,model.money);
    [_taskImage sd_setImageWithURL:[NSURL URLWithString:model.img]];
    
    if(model.is_get == 0 ||  model.is_get == -1){
        [_goButton setTitle:@"去完成" forState:UIControlStateNormal];
        [_goButton setTitleColor:rgba(88, 88, 88, 1) forState:UIControlStateNormal];
        [_goButton setBackgroundImage:[UIImage gradientColorImageFromColors:@[rgba(254, 213, 132, 1),rgba(255, 230, 181, 1)] gradientType:GradientTypeLeftToRight imgSize:CGSizeMake(67.5, 23)] forState:UIControlStateNormal];
    }else if(model.is_get == 1 && model.is_reward == 0){
        [_goButton setTitle:@"领取奖励" forState:UIControlStateNormal];
        [_goButton setTitleColor:KWhiteColor forState:UIControlStateNormal];
        [_goButton setBackgroundImage:[UIImage gradientColorImageFromColors:MaingradientColor gradientType:GradientTypeLeftToRight imgSize:CGSizeMake(67.5, 23)] forState:UIControlStateNormal];
    }else if(model.is_reward == 1){
        [_goButton setTitle:@"已领取" forState:UIControlStateNormal];
        [_goButton setTitleColor:KWhiteColor forState:UIControlStateNormal];
        [_goButton setBackgroundImage:[UIImage imageWithColor:rgba(204, 204, 204, 1)] forState:UIControlStateNormal];
    }
}

- (void)createUI{
    _buttonSize = CGSizeMake(67.5, 23);
    
    _bacView = [UIView new];
    _bacView.backgroundColor = KWhiteColor;
    _bacView.layer.shadowColor = [UIColor colorWithRed:153/255.0 green:174/255.0 blue:223/255.0 alpha:0.2].CGColor;
    _bacView.layer.shadowOffset = CGSizeMake(0,5);
    _bacView.layer.shadowOpacity = 1;
    _bacView.layer.shadowRadius = 9;
    _bacView.layer.cornerRadius = 5;
    [self addSubview:_bacView];
    
    _taskImage = [[UIImageView alloc] initWithImage:[UIImage imageWithColor:[UIColor orangeColor]]];
    _taskImage.contentMode = UIViewContentModeScaleAspectFit;
    _taskImage.layer.cornerRadius = 43.5/2;
    _taskImage.layer.masksToBounds = YES;
    [self addSubview:_taskImage];
    
    _title = [UILabel new];
    _title.text = @"--";
    _title.textColor = rgba(51, 51, 51, 1);
    _title.font = tFont(13);
    _title.numberOfLines = 0;
    [self addSubview:_title];
    
    _details = [UILabel new];
    _details.text = @"--";
    _details.textColor = rgba(153, 153, 153, 1);
    _details.font = tFont(12);
    _details.numberOfLines = 0;
    [self addSubview:_details];
    
    _goButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _goButton.titleLabel.font = tFont(12);
    _goButton.layer.cornerRadius = 5;
    _goButton.layer.masksToBounds = YES;
    _goButton.layer.shadowOffset = CGSizeMake(0,2);
    _goButton.layer.shadowOpacity = 1;
    _goButton.layer.shadowRadius = 4;
    [self addSubview:_goButton];
}

- (void)layoutSubview{
    [_bacView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(OverAllLeft_OR_RightSpace);
        make.right.mas_equalTo(self.mas_right).offset(-OverAllLeft_OR_RightSpace);
        make.top.mas_equalTo(self.mas_top).offset(16);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-5);
    }];
    
    _goButton.frame = CGRectMake(ScreenWidth - OverAllLeft_OR_RightSpace - 67.5 - 10, 16+7.5+7, _buttonSize.width, _buttonSize.height);
    
    [_taskImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_bacView.mas_left).offset(7.5);
        make.top.mas_equalTo(_bacView.mas_top).offset(7.5); 
        make.size.mas_equalTo(CGSizeMake(43.5, 43.5));
    }];
    
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_taskImage.mas_top).offset(4.5);
        make.left.mas_equalTo(_taskImage.mas_right).offset(5.5);
        make.right.mas_equalTo(_goButton.mas_left).offset(-11.5);
    }];
    
    [_details mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_title.mas_bottom).offset(12.5);
        make.bottom.mas_equalTo(_bacView.mas_bottom).offset(-11.5);
        make.left.mas_equalTo(_title.mas_left);
        make.right.mas_equalTo(_bacView.mas_right).offset(-11.5);
    }];
    

}


@end
