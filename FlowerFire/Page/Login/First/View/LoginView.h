//
//  LoginView.h
//  FlowerFire
//
//  Created by 王涛 on 2020/4/30.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "BaseUIView.h"
#import "LoginTextField.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LoginViewDelegate <NSObject>

-(void)createAccountClick;
-(void)improtAccountClick;
-(void)forgetPwdClick;
-(void)popVC;

@end

@interface LoginView : BaseUIView

@property(nonatomic, weak)id<LoginViewDelegate> delegate;
//@property(nonatomic, strong)LoginTextField   *userNameField;
//@property(nonatomic, strong)LoginTextField   *pwdField;
    

@end 

NS_ASSUME_NONNULL_END
