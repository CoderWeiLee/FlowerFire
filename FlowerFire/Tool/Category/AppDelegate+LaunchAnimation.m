//
//  AppDelegate+LaunchAnimation.m
//  FireCoin
//
//  Created by 王涛 on 2019/7/17.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "AppDelegate+LaunchAnimation.h"
#import "XHLaunchAd.h"

@implementation AppDelegate (LaunchAnimation)

-(void)startLaunchAnimation{
    //2.自定义配置
    XHLaunchVideoAdConfiguration *videoAdconfiguration = [XHLaunchVideoAdConfiguration new];
    //广告停留时间
    videoAdconfiguration.duration = 3;
    //广告frame
    videoAdconfiguration.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    //广告视频URLString/或本地视频名(请带上后缀)
    videoAdconfiguration.videoNameOrURLString = @"Launch.mp4";
    //是否关闭音频
    videoAdconfiguration.muted = NO;
    //视频填充模式
    videoAdconfiguration.videoGravity = AVLayerVideoGravityResizeAspectFill;
    //是否只循环播放一次
    videoAdconfiguration.videoCycleOnce = YES;
    //广告点击打开页面参数(openModel可为NSString,模型,字典等任意类型)
    videoAdconfiguration.openModel =  @"http://www.it7090.com";
    //广告显示完成动画
    videoAdconfiguration.showFinishAnimate = ShowFinishAnimateFadein;
    //广告显示完成动画时间
    videoAdconfiguration.showFinishAnimateTime = 1;
    //跳过按钮类型
    videoAdconfiguration.skipButtonType = SkipTypeNone;
    //后台返回时,是否显示广告
    videoAdconfiguration.showEnterForeground = NO;
    
    //设置要添加的子视图(可选)
    //videoAdconfiguration.subViews = ...
    
    //显示视频开屏广告 
    [XHLaunchAd setLaunchSourceType:SourceTypeLaunchScreen];
    [XHLaunchAd videoAdWithVideoAdConfiguration:videoAdconfiguration delegate:self];
}

@end
