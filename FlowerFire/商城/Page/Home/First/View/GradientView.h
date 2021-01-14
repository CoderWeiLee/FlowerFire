//
//  GradientView.h
//  531Mall
//
//  Created by 王涛 on 2020/5/18.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "BaseUIView.h"
#import "UIImage+jianbianImage.h"

NS_ASSUME_NONNULL_BEGIN

@interface GradientView : UIImageView

-(instancetype)initWithFrame:(CGRect)frame gradientColorImageFromColors:(NSArray*)colors gradientType:(GradientType)gradientType;
 
-(void)setGradientColorImageFromColors:(NSArray*)colors gradientType:(GradientType)gradientType;

@end

NS_ASSUME_NONNULL_END
