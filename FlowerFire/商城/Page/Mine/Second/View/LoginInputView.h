//
//  LoginInputView.h
//  531Mall
//
//  Created by 王涛 on 2020/5/22.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "BaseUIView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginInputView : UITextField

-(instancetype)initWithFrame:(CGRect)frame placeholderStr:(NSString *)placeholderStr rightView:(UIView *)rightView;
 
 
@end 

NS_ASSUME_NONNULL_END
