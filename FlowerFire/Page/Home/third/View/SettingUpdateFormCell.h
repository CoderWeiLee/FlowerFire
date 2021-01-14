//
//  SettingUpdateFormCell.h
//  FlowerFire
//
//  Created by 王涛 on 2020/5/5.
//  Copyright © 2020 Celery. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface SettingUpdateFormCell : BaseTableViewCell

@property(nonatomic, strong)UILabel     *title;
@property(nonatomic, strong)UITextField *loginInputView;
@property(nonatomic, strong)UIButton    *rightButton;

-(void)setCellData:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
