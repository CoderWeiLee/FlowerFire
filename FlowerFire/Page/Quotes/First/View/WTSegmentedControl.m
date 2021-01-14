//
//  WTSegmentedControl.m
//  FlowerFire
//
//  Created by 王涛 on 2020/4/28.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "WTSegmentedControl.h"

@interface WTSegmentedControl ()
{
    NSMutableArray<WTSegmentedItem *> *_itemArray;
}
@end

@implementation WTSegmentedControl

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 5;
        self.layer.theme_borderColor = THEME_LINE_INPUTBORDERCOLOR;
        self.layer.borderWidth = 1;
        self.clipsToBounds = YES;
        _itemArray = [NSMutableArray array];
    }
    return self;
}

- (void)insertSegmentWithTitle:(NSString *)title atIndex:(NSUInteger)segment{
    WTSegmentedItem *item = [[WTSegmentedItem alloc] initWithFrame:CGRectMake(segment * SEGMENTED_WIDTH, 0, SEGMENTED_WIDTH , SEGMENTED_HEIGHT)];
    item.itemIndex = segment;
    item.titleString = title;
    [_itemArray addObject:item];
    [item addTarget:self action:@selector(selectItem:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:item];
}

- (void)setWidth:(CGFloat)width forSegmentAtIndex:(NSUInteger)segment{
    WTSegmentedItem *item = _itemArray[segment];
    item.width = width;
}

- (void)setSelectedSegmentTintColor:(UIColor *)selectedSegmentTintColor{
    for (WTSegmentedItem *item in _itemArray) {
        [item setBackgroundImage:[UIImage imageWithColor:selectedSegmentTintColor] forState:UIControlStateSelected];
    }
}

- (void)setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex{
    _selectedSegmentIndex = selectedSegmentIndex;
    for (WTSegmentedItem *item in _itemArray) {
        if(item.itemIndex == selectedSegmentIndex){
            item.selected = YES;
            item.userInteractionEnabled = NO;
        }else{
            item.selected = NO;
            item.userInteractionEnabled = YES;
        } 
    }
    //将UIControlEventValueChanged 响应发出去
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

#pragma mark - action
-(void)selectItem:(WTSegmentedItem *)sender{
    self.selectedSegmentIndex = sender.itemIndex;
}
 
@end
  
@implementation WTSegmentedItem 

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitle:@"-" forState:UIControlStateNormal];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal]; 
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [self setBackgroundImage:[UIImage imageWithColor:KWhiteColor] forState:UIControlStateNormal];
        [self.titleLabel setFont:tFont(15)];
        self.adjustsImageWhenHighlighted = NO;
    }
    return self;
}

- (void)setTitleString:(NSString *)titleString{
    [self setTitle:titleString forState:UIControlStateNormal];
}
 

@end
