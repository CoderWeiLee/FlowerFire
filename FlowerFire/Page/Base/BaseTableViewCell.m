//
//  BaseTableViewCell.m
//  FireCoin
//
//  Created by 赵馨 on 2019/5/25.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "BaseTableViewCell.h"

@implementation BaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if(self){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setTheme_backgroundColor:THEME_CELL_BACKGROUNDCOLOR];
        [self sendSubviewToBack:self.contentView];
    }
    return self;
}

- (void)createUI {
     
}

- (void)layoutSubview {
     
}

- (void)setCellData:(id)dic{
    
}

@end
