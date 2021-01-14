//
//  LeftMenuPageCell.m
//  FireCoin
//
//  Created by 王涛 on 2019/6/5.
//  Copyri/Users/celery/Downloads/ZTuoExchange_IOS/digitalCurrency/Controllers/交易ght © 2019 王涛. All rights reserved.
//  侧边栏的cell

#import "LeftMenuPageCell.h"

@implementation LeftMenuPageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.namelabel = [UILabel new];
        self.namelabel.text = @"--/--";
        self.namelabel.theme_textColor = THEME_TEXT_COLOR;
        self.namelabel.font = tFont(16);
        self.namelabel.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        self.namelabel.layer.masksToBounds = YES;
        [self addSubview:self.namelabel];
        [self.namelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).offset(20);
            make.left.mas_equalTo(self.mas_left).offset(OverAllLeft_OR_RightSpace);
            make.bottom.mas_equalTo(self.mas_bottom).offset(-20);
        }];
        
        self.changelabel = [UILabel new];
        self.changelabel.text = @"0.00";
        self.changelabel.textColor = qutesRedColor;
        self.changelabel.font = tFont(16);
        self.changelabel.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        self.changelabel.layer.masksToBounds = YES;
        [self addSubview:self.changelabel];
        [self.changelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.namelabel.mas_centerY);
            make.right.mas_equalTo(self.mas_right).offset(-OverAllLeft_OR_RightSpace);
        }];
        
        
    }
    return self;
}

-(void)setCellData:(QuotesTransactionPairModel *)model{
     self.namelabel.attributedText = [self changefondstr:model.from_symbol fondstr:model.to_symbol];
    
    double change = [model.change doubleValue];
    double price  = [model.New_price doubleValue];
    if (change <0) {
        self.changelabel.textColor = qutesRedColor;
        self.changelabel.text = [NSString stringWithFormat:@"%@",[ToolUtil stringFromNumber:price withlimit:model.dec]];
        
    }else{
        self.changelabel.textColor = qutesGreenColor;
        self.changelabel.text = [NSString stringWithFormat:@"%@",[ToolUtil stringFromNumber:price withlimit:model.dec]];
    }
//    else{
//        self.changelabel.textColor = qutesDefaultColor;
//        self.changelabel.text = [NSString stringWithFormat:@"%@",[ToolUtil stringFromNumber:0 withlimit:model.dec]];
//    }
}

-(void)setSecuritiesCellData:(NSDictionary *)dic{
    self.namelabel.text = dic[@"title"];
    self.changelabel.text = dic[@"price"];
}

-(NSMutableAttributedString *)changefondstr:(NSString *)firststr fondstr:(NSString *)fondstr{
    NSMutableAttributedString *Str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@/%@",firststr,fondstr]];
    [Str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFang SC" size:13] range:NSMakeRange(firststr.length, fondstr.length + 1)];
    [Str addAttribute:NSForegroundColorAttributeName value:rgba(105, 122, 149, 1) range:NSMakeRange(firststr.length, fondstr.length + 1)];
    
    return Str;
    
}

@end
