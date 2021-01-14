//
//  WTLabel.h
//  FilmCrowdfunding
//
//  Created by 王涛 on 2019/11/13.
//  Copyright © 2019 Celery. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYText.h>

NS_ASSUME_NONNULL_BEGIN

 
@interface WTLabel : YYLabel

-(instancetype)initWithFrame:(CGRect)frame
                        Text:(NSString *)text
                        Font:(UIFont *)font
                   textColor:(UIColor *)textColor
                  parentView:(UIView * _Nullable )parentView;
 

@end

NS_ASSUME_NONNULL_END
