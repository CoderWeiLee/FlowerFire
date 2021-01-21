//
//  LWNewsLineTableViewCell.m
//  FlowerFire
//
//  Created by 李伟 on 2021/1/21.
//  Copyright © 2021 Celery. All rights reserved.
//

#import "LWNewsLineTableViewCell.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/SDWebImage.h>////标题
#import "BaseLineView.h"
//来源
@interface LWNewsLineTableViewCell()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) BaseLineView *lineView;
@end
@implementation LWNewsLineTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        self.timeLabel = [[UILabel alloc] init];
        self.timeLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        self.timeLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:self.timeLabel];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView).offset(13.5);
            make.top.mas_equalTo(self.contentView).offset(17.5);
        }];
        
        self.lineView = [[BaseLineView alloc] init];
        [self.contentView addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.timeLabel).offset(20);
            make.top.mas_equalTo(self.timeLabel.mas_bottom).offset(3);
            make.bottom.equalTo(self.contentView);
            make.width.equalTo(@5);
        }];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.numberOfLines = 2;
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView).offset(55);
            make.top.mas_equalTo(self.timeLabel.mas_bottom).offset(17);
            make.right.mas_equalTo(self.contentView).offset(-20);
        }];
        
        self.contentLabel = [[UILabel alloc] init];
        self.contentLabel.font = [UIFont systemFontOfSize:12];
        self.contentLabel.numberOfLines = 5;
        self.contentLabel.textColor = [UIColor colorWithWhite:0.4 alpha:0.3];
        [self.contentView addSubview:self.contentLabel];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLabel);
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(6);
            make.right.mas_equalTo(self.contentView).offset(-20);
        }];
        
    }
    return self;
}

- (void)setModel:(LWNewsModel *)model {
    _model = model;
    self.timeLabel.text = _model.addtime_text;
    NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:_model.title];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 10;  //设置行间距
    [attrTitle addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15], NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#202020"], NSParagraphStyleAttributeName: paragraphStyle} range:NSMakeRange(0, attrTitle.length)];
    
    self.titleLabel.attributedText = attrTitle;
    NSMutableAttributedString *attrSource = [[NSMutableAttributedString alloc] initWithString:_model.subcontent];
    [attrSource addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13], NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#999999"], NSParagraphStyleAttributeName: paragraphStyle} range:NSMakeRange(0, attrSource.length)];
    self.contentLabel.attributedText = attrSource;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
