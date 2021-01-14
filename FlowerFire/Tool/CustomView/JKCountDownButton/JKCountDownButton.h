//
//  JKCountDownButton.h
//  JKCountDownButton
//
//  Created by Jakey on 15/3/8.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
#pragma mark - 验证码倒计时按钮用法
//  _countDownCode = [JKCountDownButton buttonWithType:UIButtonTypeCustom];
//  _countDownCode.frame = CGRectMake(81, 200, 108, 32);
//  [_countDownCode setTitle:@"开始" forState:UIControlStateNormal];
//  _countDownCode.backgroundColor = [UIColor blueColor];
//  [self.view addSubview:_countDownCode];
//
//
//  [_countDownCode countDownButtonHandler:^(JKCountDownButton*sender, NSInteger tag) {
//      sender.enabled = NO;
//
//      [sender startCountDownWithSecond:10];
//
//      [sender countDownChanging:^NSString *(JKCountDownButton *countDownButton,NSUInteger second) {
//          NSString *title = [NSString stringWithFormat:@"剩余%zd秒",second];
//          return title;
//      }];
//      [sender countDownFinished:^NSString *(JKCountDownButton *countDownButton, NSUInteger second) {
//          countDownButton.enabled = YES;
//          return @"点击重新获取";
//
//      }];
//
//  }];

//

#import <UIKit/UIKit.h>
@class JKCountDownButton;
typedef NSString* (^CountDownChanging)(JKCountDownButton *countDownButton,NSUInteger second);
typedef NSString* (^CountDownFinished)(JKCountDownButton *countDownButton,NSUInteger second);
typedef void (^TouchedCountDownButtonHandler)(JKCountDownButton *countDownButton,NSInteger tag);

@interface JKCountDownButton : UIButton
@property(nonatomic,strong) id userInfo;
///倒计时按钮点击回调
- (void)countDownButtonHandler:(TouchedCountDownButtonHandler)touchedCountDownButtonHandler;
//倒计时时间改变回调
- (void)countDownChanging:(CountDownChanging)countDownChanging;
//倒计时结束回调
- (void)countDownFinished:(CountDownFinished)countDownFinished;
///开始倒计时
- (void)startCountDownWithSecond:(NSUInteger)second;
///停止倒计时
- (void)stopCountDown;
@end



