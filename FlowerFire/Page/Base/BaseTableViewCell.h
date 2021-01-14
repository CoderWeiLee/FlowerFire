//
//  BaseTableViewCell.h
//  FireCoin
//
//  Created by 赵馨 on 2019/5/25.
//  Copyright © 2019 王涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InitViewProtocol.h"
 
@interface BaseTableViewCell : UITableViewCell<InitViewProtocol>

-(void)setCellData:(id )dic;

@end

