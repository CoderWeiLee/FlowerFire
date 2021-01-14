//
//  IntroductionFotterView.h
//  FireCoin
//
//  Created by 王涛 on 2019/7/5.
//  Copyright © 2019 王涛. All rights reserved.
//  简介足部视图

#import "BaseUIView.h"

NS_ASSUME_NONNULL_BEGIN

@interface IntroductionFooterView : BaseUIView

/**
 简介内容
 */
@property (nonatomic, strong) UITextView *content;

-(void)setTextStr:(NSString *)textStr bacHeight:(CGFloat) bacHeight;

@end

NS_ASSUME_NONNULL_END
