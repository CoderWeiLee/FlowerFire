//
//  WTTableView.m
//  FireCoin
//
//  Created by 王涛 on 2019/7/11.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "WTTableView.h"
#import "EmptyDataView.h"
#import "LYEmptyViewHeader.h"


@interface WTTableView ()

@end

@implementation WTTableView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initEmptyView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initEmptyView];
    }
    return self;
}
 
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self initEmptyView];
    }
    return self;
}
 
- (void)hideEmptyView{
//注意点:使用这两个方法，请先将emptyView的autoShowEmptyView属性置为NO，关闭自动显隐
    self.ly_emptyView.autoShowEmptyView = NO;
    [self ly_hideEmptyView];
}

- (void)setEmptyViewContentViewY:(CGFloat)offset{
    self.ly_emptyView.contentViewY = offset;
}

#pragma mark - privateMethod
-(void)initEmptyView{   
    self.ly_emptyView = [EmptyDataView diyCustomEmptyViewWithTarget:self action:@selector(emptyViewClick)];
}

-(void)emptyViewClick{
    !self.didEmptyViewBlock ? : self.didEmptyViewBlock();
}


/**
 同时识别多个手势
 
 @param gestureRecognizer gestureRecognizer description
 @param otherGestureRecognizer otherGestureRecognizer description
 @return return value description
 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}



@end
