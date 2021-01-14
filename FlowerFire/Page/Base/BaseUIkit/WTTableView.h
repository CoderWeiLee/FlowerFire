//
//  WTTableView.h
//  FireCoin
//
//  Created by 王涛 on 2019/7/11.
//  Copyright © 2019 王涛. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^didEmptyViewBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface WTTableView  : UITableView

@property(nonatomic,copy)didEmptyViewBlock didEmptyViewBlock;

-(void)hideEmptyView;
-(void)setEmptyViewContentViewY:(CGFloat)offset;
@end

NS_ASSUME_NONNULL_END
