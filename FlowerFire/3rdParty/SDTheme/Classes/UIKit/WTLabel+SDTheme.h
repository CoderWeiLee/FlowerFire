//
//  WTLabel+SDTheme.h
//  FlowerFire
//
//  Created by 王涛 on 2020/7/14.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "WTLabel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WTLabel (SDTheme)

@property (nonatomic, copy) NSString *theme_textColor;
@property (nonatomic, copy) IBInspectable NSString *sd_textColor;
@property (nonatomic, copy) NSAttributedString *theme_attributedText;


@end

NS_ASSUME_NONNULL_END
