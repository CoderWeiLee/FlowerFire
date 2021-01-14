//
//  RegisteredTableViewCell.h
//  FlowerFire
//
//  Created by 王涛 on 2020/5/14.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "RegisteredTextField.h"

NS_ASSUME_NONNULL_BEGIN

@interface RegisteredTableViewCell : BaseTableViewCell

-(void)setCellData:(NSDictionary *)dic;

@property(nonatomic, strong)RegisteredTextField *textField;

@end

NS_ASSUME_NONNULL_END
