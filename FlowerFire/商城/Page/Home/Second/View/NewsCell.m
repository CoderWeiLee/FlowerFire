//
//  NewsCell.m
//  531Mall
//
//  Created by 王涛 on 2020/5/19.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "NewsCell.h"

@interface NewsCell ()
{
    UILabel *_time;
    UIImageView *_line;
    UILabel *_title,*_details;
    UIView  *_bacView;
}
@end

@implementation NewsCell 

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self createUI];
        [self layoutSubview];
    }
    return self;
}

- (void)setCellData:(BulletinModel *)model{
    _title.text = model.title;
    _details.text = model.content;
    _time.text = model.ctime;
}

- (void)createUI{
    _time = [UILabel new];
    _time.text = @"------ -----";
    _time.textColor = rgba(153, 153, 153, 1);
    _time.font = tFont(11);
    [self addSubview:_time];
    
    _bacView = [UIView new];
    _bacView.backgroundColor = KWhiteColor;
    _bacView.layer.shadowColor = [UIColor colorWithRed:153/255.0 green:174/255.0 blue:223/255.0 alpha:0.2].CGColor;
    _bacView.layer.shadowOffset = CGSizeMake(0,5);
    _bacView.layer.shadowOpacity = 1;
    _bacView.layer.shadowRadius = 9;
    _bacView.layer.cornerRadius = 5;
    [self addSubview:_bacView];
    
    _line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"x"]];
    [self addSubview:_line];
    
    _title = [UILabel new];
    _title.text = @"--";
    _title.textColor = MainColor;
    _title.font = tFont(13);
    _title.numberOfLines = 0;
    [self addSubview:_title];
    
    _details = [UILabel new];
    _details.text = @"--";
    _details.textColor = rgba(102, 102, 102, 1);
    _details.font = tFont(12);
    _details.numberOfLines = 0;
    [self addSubview:_details];
}

- (void)layoutSubview{
    [_time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(13.5);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    
    [_bacView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(OverAllLeft_OR_RightSpace);
        make.right.mas_equalTo(self.mas_right).offset(-OverAllLeft_OR_RightSpace);
        make.top.mas_equalTo(_time.mas_bottom).offset(15.5);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-5);
    }];
    
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_bacView.mas_left);
        make.top.mas_equalTo(_bacView.mas_top);
        make.bottom.mas_equalTo(_bacView.mas_bottom);
    }];
    
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_bacView.mas_top).offset(14);
        make.left.mas_equalTo(_bacView.mas_left).offset(11.5);
        make.right.mas_equalTo(_bacView.mas_right).offset(-11.5);
    }];
    
    [_details mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_title.mas_bottom).offset(12.5);
        make.bottom.mas_equalTo(_bacView.mas_bottom).offset(-16.5);
        make.left.mas_equalTo(_bacView.mas_left).offset(11.5);
        make.right.mas_equalTo(_bacView.mas_right).offset(-11.5);
    }];
    

}

@end
