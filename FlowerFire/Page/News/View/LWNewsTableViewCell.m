//
//  LWNewsTableViewCell.m
//  FlowerFire
//
//  Created by 李伟 on 2021/1/20.
//  Copyright © 2021 Celery. All rights reserved.
//

#import "LWNewsTableViewCell.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/SDWebImage.h>
@interface LWNewsTableViewCell()
//标题
@property (nonatomic, strong) UILabel *titleLabel;
//来源
@property (nonatomic, strong) UILabel *sourceLabel;
//图片
@property (nonatomic, strong) UIImageView *coverImg;
@end
@implementation LWNewsTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor yellowColor];
        self.coverImg = [[UIImageView alloc] init];
        self.coverImg.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.coverImg];
        [self.coverImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView).offset(20);
            make.top.mas_equalTo(self.contentView).offset(10);
            make.width.mas_equalTo(@150);
            make.height.mas_equalTo(@80);
        }];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.backgroundColor = [UIColor lightGrayColor];
        self.titleLabel.numberOfLines = 0;
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.coverImg.mas_right).offset(10);
            make.top.mas_equalTo(self.coverImg).offset(3);
        }];
        
        
        self.sourceLabel = [[UILabel alloc] init];
        self.sourceLabel.backgroundColor = [UIColor lightGrayColor];
        self.sourceLabel.numberOfLines = 0;
        self.sourceLabel.textColor = [UIColor colorWithWhite:0.4 alpha:0.3];
        [self.contentView addSubview:self.sourceLabel];
        [self.sourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLabel);
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(3);
        }];
    }
    return self;
}

- (void)setModel:(LWNewsModel *)model {
    _model = model;
    [self.coverImg sd_setImageWithURL:[NSURL URLWithString:_model.coverurl]];
    self.titleLabel.text = _model.title;
    NSString *source = [NSString stringWithFormat:@"区块链研习社 %@   %@",_model.addtime_text,_model.type];
    self.sourceLabel.text = source;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
