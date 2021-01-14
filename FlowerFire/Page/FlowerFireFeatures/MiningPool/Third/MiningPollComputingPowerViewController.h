//
//  MiningPollComputingPowerViewController.h
//  FlowerFire
//
//  Created by 王涛 on 2020/7/14.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "BaseTableViewController.h"
#import "BaseUIView.h"
#import "MiningPollDetailModel.h"
#import "NoteModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MiningPollComputingPowerViewController : BaseTableViewController
@property(nonatomic, strong)NSMutableArray<NoteModel *> *dataSource;
@property(nonatomic,strong)NSString *coinName;


@end

@interface MiningPollComputingHeaderView : BaseUIView

-(instancetype)initWithFrame:(CGRect)frame coinName:(NSString *)coinName;

-(void)setHeaderData:(MiningPollDetailModel *)model;

@end

NS_ASSUME_NONNULL_END
