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
        self.backgroundColor = [UIColor whiteColor];
        self.coverImg = [[UIImageView alloc] init];
        [self.contentView addSubview:self.coverImg];
        [self.coverImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView).offset(20);
            make.top.mas_equalTo(self.contentView).offset(10);
            make.width.mas_equalTo(@120);
            make.height.mas_equalTo(@80);
        }];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.numberOfLines = 2;
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.coverImg.mas_right).offset(10);
            make.top.mas_equalTo(self.coverImg);
            make.right.mas_equalTo(self.contentView).offset(-10);
        }];
        
        
        self.sourceLabel = [[UILabel alloc] init];
        self.sourceLabel.font = [UIFont systemFontOfSize:12];
        self.sourceLabel.numberOfLines = 0;
        self.sourceLabel.textColor = [UIColor colorWithWhite:0.4 alpha:0.3];
        [self.contentView addSubview:self.sourceLabel];
        [self.sourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLabel);
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(6);
            make.right.mas_equalTo(self.contentView).offset(-10);
        }];
    }
    return self;
}

- (void)setModel:(LWNewsModel *)model {
    _model = model;
    [self.coverImg sd_setImageWithURL:[NSURL URLWithString:_model.coverurl]];
    NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:_model.title];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 4;  //设置行间距
    [attrTitle addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14], NSForegroundColorAttributeName: [UIColor blackColor], NSParagraphStyleAttributeName: paragraphStyle} range:NSMakeRange(0, attrTitle.length)];
    
    self.titleLabel.attributedText = attrTitle;
    NSString *source = [NSString stringWithFormat:@"区块链研习社 %@   %@",_model.addtime_text,_model.type];
    NSMutableAttributedString *attrSource = [[NSMutableAttributedString alloc] initWithString:source];
    [attrSource addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:11], NSForegroundColorAttributeName: [UIColor colorWithWhite:0.4 alpha:0.5], NSParagraphStyleAttributeName: paragraphStyle} range:NSMakeRange(0, attrSource.length)];
    self.sourceLabel.attributedText = attrSource;
    
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
