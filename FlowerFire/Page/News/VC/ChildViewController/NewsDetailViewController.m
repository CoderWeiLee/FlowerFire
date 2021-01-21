//
//  NewsDetailViewController.m
//  FlowerFire
//
//  Created by 李伟 on 2021/1/21.
//  Copyright © 2021 Celery. All rights reserved.
//

#import "NewsDetailViewController.h"
#import <Masonry/Masonry.h>
#import <LSTCategory/UIView+LSTView.h>
@interface NewsDetailViewController ()
@property (nonatomic, strong) UIImageView *img;
//标题
@property (nonatomic, strong) UILabel *titleLabel;
//来源
@property (nonatomic, strong) UILabel *sourceLabel;
//时间
@property (nonatomic, strong) UILabel *timeLabel;
//内容
@property (nonatomic, strong) UILabel *contentLabel;
@end

@implementation NewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"browser-back-black"]];
    self.img.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)];
    [self.img addGestureRecognizer:tap];
    [self.view addSubview:self.img];
    [self.img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(20);
        make.top.mas_equalTo(self.view).offset(LSTStatusBarHeight() + 44);
    }];
    
    //添加标题
    self.titleLabel = [[UILabel alloc] init];
    NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:self.model.title];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 4;  //设置行间距
    [attrTitle addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17], NSForegroundColorAttributeName: [UIColor darkGrayColor], NSParagraphStyleAttributeName: paragraphStyle} range:NSMakeRange(0, attrTitle.length)];
    self.titleLabel.attributedText = attrTitle;
    self.titleLabel.numberOfLines = 0;
    [self.view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.img.mas_bottom).offset(20);
        make.left.mas_equalTo(self.view).offset(20);
        make.right.mas_equalTo(self.view).offset(-10);
    }];
    
    //添加来源
    self.sourceLabel = [[UILabel alloc] init];
    self.sourceLabel.text = @"区块链研习社";
    self.sourceLabel.textColor = [UIColor darkGrayColor];
    self.sourceLabel.font = [UIFont systemFontOfSize:10];
    [self.view addSubview:self.sourceLabel];
    [self.sourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(20);
    }];
    
    //添加时间
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.text = self.model.addtime_text;
    self.timeLabel.font = [UIFont systemFontOfSize:9];
    self.timeLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1];
    [self.view addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.sourceLabel.mas_right).offset(10);
        make.centerY.mas_equalTo(self.sourceLabel);
    }];
    
    //添加内容
    self.contentLabel = [[UILabel alloc] init];
    NSMutableAttributedString *attrContent = [[NSMutableAttributedString alloc] initWithString:self.model.subcontent];
    NSMutableParagraphStyle *paragraphStyle2 = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle2.lineSpacing = 15;  //设置行间距
    [attrContent addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14], NSForegroundColorAttributeName: [UIColor lightGrayColor], NSParagraphStyleAttributeName: paragraphStyle2} range:NSMakeRange(0, attrContent.length)];
    self.contentLabel.attributedText = attrContent;
    self.contentLabel.numberOfLines = 0;
    [self.view addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel);
        make.right.mas_equalTo(self.view).offset(-10);
        make.top.mas_equalTo(self.sourceLabel.mas_bottom).offset(30);
    }];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
