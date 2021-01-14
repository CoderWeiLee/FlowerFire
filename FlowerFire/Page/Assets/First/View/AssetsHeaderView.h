//
//  AssetsHeaderView.h
//  FireCoin
//
//  Created by 赵馨 on 2019/5/27.
//  Copyright © 2019 王涛. All rights reserved.
//

 
NS_ASSUME_NONNULL_BEGIN

@interface AssetsHeaderView : UIView

-(void)setSumData:(NSString *)data CNYStr:(NSString *)CNYStr;

@property(nonatomic, strong)WTButton *addNetSwitch;

@end

NS_ASSUME_NONNULL_END
