//
//  WTSegmentedControl.h
//  FlowerFire
//
//  Created by 王涛 on 2020/4/28.
//  Copyright © 2020 Celery. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WTSegmentedControl : UIControl
 
@property(nonatomic, assign)NSInteger  selectedSegmentIndex;
@property(nonatomic, strong)UIColor   *selectedSegmentTintColor;

 
- (void)insertSegmentWithTitle:(NSString *)title atIndex:(NSUInteger)segment; 
- (void)setWidth:(CGFloat)width forSegmentAtIndex:(NSUInteger)segment;

@end

@interface WTSegmentedItem : UIButton
 
@property(nonatomic, strong)NSString *titleString;
@property(nonatomic, assign)NSInteger itemIndex; 

@end

NS_ASSUME_NONNULL_END
