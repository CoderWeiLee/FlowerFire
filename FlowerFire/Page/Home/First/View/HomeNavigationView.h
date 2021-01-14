//
//  HomeNavigationView.h
//  FireCoin
//
//  Created by 王涛 on 2020/4/27.
//  Copyright © 2020 王涛. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HomeNavigationViewDelegate <NSObject>

-(void)jumpHomeSikdVC;

@end

@interface HomeNavigationView : BaseUIView 
 
@property(nonatomic, weak)id<HomeNavigationViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
