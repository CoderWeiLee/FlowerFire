//
//  suocangcell.h
//  FlowerFire
//
//  Created by work on 2020/12/5.
//  Copyright © 2020 Celery. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol jiesuo <NSObject>

-(void)jiesuo;

@end
NS_ASSUME_NONNULL_BEGIN

@interface suocangcell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *labeltime;
@property (weak, nonatomic) IBOutlet UIButton *labenbtn;
@property (weak, nonatomic) IBOutlet UILabel *labelday;

+(suocangcell *)cellwithtableview:(UITableView *)tableview;

@end

NS_ASSUME_NONNULL_END
