//
//  DelegateContractViewController.h
//  531Mall
//
//  Created by 王涛 on 2020/6/12.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "BaseViewController.h"
#import <JXBWKWebView.h>

NS_ASSUME_NONNULL_BEGIN

@interface DelegateContractViewController : BaseViewController

@property(nonatomic, strong)JXBWKWebView *wkWebView;

/// 转义
/// @param string html标签
- (NSString*)htmlEntityDecode:(NSString*)string;

@end

NS_ASSUME_NONNULL_END
