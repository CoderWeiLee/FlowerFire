//
//  BaseUIView.h
//  FireCoin
//
//  Created by 王涛 on 2019/5/30.
//  Copyright © 2019 王涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InitViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseUIView : UIView<AFNetworkDelege,InitViewProtocol>

@property(nonatomic, strong) AFNetworkClass *afnetWork;

@property(nonatomic, assign) CGSize intrinsicContentSize;

-(void)getHttpData_array:(NSDictionary *)dict response:(Response)flag Tag:(NSString *)tag;
-(void)dataNormal:(NSDictionary *)dict type:(NSString *)type;

-(void)initData;

@end

NS_ASSUME_NONNULL_END
