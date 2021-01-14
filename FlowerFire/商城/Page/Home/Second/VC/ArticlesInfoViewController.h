//
//  ArticlesInfoViewController.h
//  531Mall
//
//  Created by 王涛 on 2020/6/11.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ArticlesInfoViewController : BaseViewController

-(instancetype)initWithArticlesID:(NSString *)articlesID
                    articlesTitle:(NSString *)articlesTitle;

/// 任务id，做任务才有的id
@property(nonatomic, strong)NSString *taskID;

@end

NS_ASSUME_NONNULL_END
