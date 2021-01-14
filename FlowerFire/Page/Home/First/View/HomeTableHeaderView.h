//
//  HomeTableHeaderView.h
//  FlowerFire
//
//  Created by 王涛 on 2020/4/27.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "BaseUIView.h"
#import "HomeHornView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeTableHeaderView : BaseUIView

-(instancetype)initWithFrame:(CGRect)frame;

-(void)setBanner:(NSArray *)bannerArray; 

/// 喇叭视图
@property(nonatomic, strong)HomeHornView    *hornView;
@property(nonatomic, strong)NSString        *noticeUrlString;
@end

//@interface headerButtonModel : NSObject
//
//@property(nonatomic, copy)NSString *buttonImageName;
//@property(nonatomic, copy)NSString *buttonTitle;
//@property(nonatomic, copy)NSString *viewControllerName;
//@property(nonatomic, copy)NSString *buttonID;
//@property(nonatomic, assign,getter=isWebView)Boolean webView;
//
//@end


NS_ASSUME_NONNULL_END

