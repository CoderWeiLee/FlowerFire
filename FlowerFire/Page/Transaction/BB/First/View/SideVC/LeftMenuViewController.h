//
//  LeftMenuViewController.h
//  FireCoin
//
//  Created by 王涛 on 2019/6/5.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LeftMenuViewController : BaseViewController

@property(nonatomic, strong) UILabel *topLabel;

- (void)showFromLeft;

@end

NS_ASSUME_NONNULL_END
