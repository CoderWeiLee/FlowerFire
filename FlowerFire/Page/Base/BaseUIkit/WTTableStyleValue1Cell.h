//
//  WTTableStyleValue1Cell.h
//  FilmCrowdfunding
//
//  Created by 王涛 on 2019/11/16.
//  Copyright © 2019 Celery. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InitViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface WTTableStyleValue1Cell : UITableViewCell<InitViewProtocol>

@property(nonatomic, strong)WTLabel *leftLabel,*rightLabel;
@property(nonatomic, strong)UIView  *line;
@property(nonatomic, assign)BOOL    isHiddenSplitLine;
 
@end

NS_ASSUME_NONNULL_END
