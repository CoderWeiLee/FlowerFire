//
//  SearchCoinTextField.h
//  FireCoin
//
//  Created by 王涛 on 2020/4/8.
//  Copyright © 2020 王涛. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SearchCoinTextFieldDelegate <NSObject>

/// 监听输入框
-(void)changedTextField:(UITextField *)textField;

/// 清空输入框
-(void)cleanFieldClick;

@end

@interface SearchCoinTextField : UITextField

@property(nonatomic, weak)id<SearchCoinTextFieldDelegate> searchTextFieldDelegate;

-(instancetype)initWithFrame:(CGRect)frame delegate:(id)delegate;



@end

NS_ASSUME_NONNULL_END
