//
//  SearchResultHeaderView.m
//  531Mall
//
//  Created by 王涛 on 2020/5/19.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "SearchResultHeaderView.h"

@interface SearchResultHeaderView ()
{
    UIButton *_salesButton,*_timeButton,*_priceButton,*_switchCollectionButton;
    UIView   *_line;
}
@end

@implementation SearchResultHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
        [self layoutSubview];
    }
    return self;
}

- (void)createUI{
    self.backgroundColor = [UIColor whiteColor];
    
    _salesButton = [self creatButton];
    _salesButton.tag = 1;
    [_salesButton setTitle:@"销量 ▲" forState:UIControlStateNormal];
    [_salesButton setTitle:@"销量 ▼" forState:UIControlStateSelected];
    
    _timeButton = [self creatButton];
    _timeButton.tag = 2;
    [_timeButton setTitle:@"时间 ▲" forState:UIControlStateNormal];
    [_timeButton setTitle:@"时间 ▼" forState:UIControlStateSelected];
       
    _priceButton = [self creatButton];
    _priceButton.tag = 3;
    [_priceButton setTitle:@"价格 ▲" forState:UIControlStateNormal];
    [_priceButton setTitle:@"价格 ▼" forState:UIControlStateSelected];
    
    _switchCollectionButton = [self creatButton];
    _switchCollectionButton.tag = 4;
    [_switchCollectionButton setImage:[UIImage imageNamed:@"图层 1"] forState:UIControlStateSelected];
    [_switchCollectionButton setImage:[UIImage imageNamed:@"tcb"] forState:UIControlStateNormal];
    
    _line = [UIView new];
    _line.backgroundColor = rgba(250, 250, 250, 1);
    [self addSubview:_line];
}

- (void)layoutSubview{
    CGFloat buttonWidth = ScreenWidth/4;
    _salesButton.frame = CGRectMake(0, 0, buttonWidth, 40);
    _timeButton.frame = CGRectMake(_salesButton.ly_maxX, 0, buttonWidth, 40);
    _priceButton.frame = CGRectMake(_timeButton.ly_maxX, 0, buttonWidth, 40);
    _switchCollectionButton.frame = CGRectMake(_priceButton.ly_maxX, 0, buttonWidth, 40);
    _line.frame = CGRectMake(0, _salesButton.ly_maxY, ScreenWidth, 5);
}

-(void)searchresultButtonClick:(UIButton *)button{
    if(![button isEqual:_switchCollectionButton]){
        if(!button.isSelected){ //如果自己已经选中了，不给弄成未选择
            _salesButton.selected = NO;
            _timeButton.selected = NO;
            _priceButton.selected = NO;
        }
    }
    
    if([self.delegate respondsToSelector:@selector(searchresultButtonClick:)]){
        [self.delegate searchresultButtonClick:button];
    }
}

#pragma mark - privateMetho
-(UIButton *)creatButton{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:rgba(102, 102, 102, 1) forState:UIControlStateNormal];
    [button setTitleColor:MainColor forState:UIControlStateSelected];
    button.titleLabel.font = tFont(12);
    [self addSubview:button];
    [button addTarget:self action:@selector(searchresultButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

@end
