//
//  EditAddressCell.h
//  531Mall
//
//  Created by 王涛 on 2020/5/20.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface EditAddressCell : BaseTableViewCell

-(void)setCellData:(NSDictionary *)dic;

@property(nonatomic, strong)UITextField *textField;

@end

NS_ASSUME_NONNULL_END
