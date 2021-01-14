//
//  LoginTextField.h
//  FlowerFire
//
//  Created by 王涛 on 2020/4/30.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "BaseUIView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginTextField : BaseUIView

@property(nonatomic, strong)UILabel     *title;
@property(nonatomic, strong)UITextField *loginInputView;
@property(nonatomic, strong)UIButton    *rightButton;
@property(nonatomic, strong)UIView      *rightView;
@property(nonatomic, strong)UIView      *line;

-(instancetype)initWithFrame:(CGRect)frame
                    titleStr:(NSString *)str
              placeholderStr:(NSString *)placeholderStr;
                    
@end

NS_ASSUME_NONNULL_END
