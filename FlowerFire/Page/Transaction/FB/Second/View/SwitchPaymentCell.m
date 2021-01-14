//
//  SwitchPaymentCell.m
//  FireCoin
//
//  Created by 王涛 on 2019/5/29.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "SwitchPaymentCell.h"
#import "ShowQrCodeVC.h"

@implementation SwitchPaymentCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if(self){
        self.backgroundColor = KWhiteColor;
        
        self.leftLabel = [UILabel new];
        self.leftLabel.textColor = rgba(146, 156, 178, 1);
        self.leftLabel.font = tFont(16);
        [self addSubview:self.leftLabel];
        [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(OverAllLeft_OR_RightSpace);
            make.top.mas_equalTo(self.mas_top).offset(20);
        }];
        
        self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.rightBtn setImage:[UIImage imageNamed:@"copy_number"] forState:UIControlStateNormal];
        [self addSubview:self.rightBtn];
        [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).offset(-OverAllLeft_OR_RightSpace);
            make.centerY.mas_equalTo(self.leftLabel.mas_centerY).offset(0);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];
        [self.rightBtn addTarget:self action:@selector(copyTextStr) forControlEvents:UIControlEventTouchUpInside];
        
        self.rightLabel = [UILabel new];
        self.rightLabel.textAlignment = NSTextAlignmentRight;
        self.rightLabel.textColor = rgba(142, 152, 174, 1);
        self.rightLabel.numberOfLines = 0;
        self.rightLabel.font = tFont(16);
        [self addSubview:self.rightLabel];
        [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.rightBtn.mas_left).offset(-5);
            make.centerY.mas_equalTo(self.leftLabel.mas_centerY).offset(0);
            make.left.mas_equalTo(self.mas_centerX);
            make.bottom.mas_equalTo(self.mas_bottom).offset(-20);
        }];
        
     
    }
    return self;
}

#pragma mark - action
-(void)copyTextStr{
    if([self.leftLabel.text containsString:LocalizationKey(@"QR Code")]){
        ShowQrCodeVC *svc = [ShowQrCodeVC new];
        svc.imageUrlStr = self.rightLabel.text;
        [[self viewController].navigationController pushViewController:svc animated:YES];
    }else{
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.rightLabel.text;
        printAlert(LocalizationKey(@"Successful copy"), 1.f);
    }
}

-(void)doubtClick{
    [[UniversalViewMethod sharedInstance] alertShowMessage:LocalizationKey(@"FiatOrderTip47") WhoShow:[self viewController] CanNilTitle:LocalizationKey(@"Tips")];
}

-(void)setCellData:(NSDictionary *)dic{
    self.leftLabel.text = dic[@"leftText"];
    self.rightLabel.text = dic[@"rightText"];
    if([dic[@"showLeftBtn"] isEqualToString:@"1"]){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"invite_rules_btn"] forState:UIControlStateNormal];
        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.leftLabel.mas_right).offset(5);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];
        [btn addTarget:self action:@selector(doubtClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if([dic[@"showRightBtn"] isEqualToString:@"1"]){
        self.rightBtn.hidden = NO;
    }else{
        self.rightBtn.hidden = YES;
    }
    //如果有二维码，显示实心二维码图片，否则是虚线二维码图片，并且不让点击
    if([dic[@"leftText"] containsString:LocalizationKey(@"QR Code")]){
        if([HelpManager isBlankString:dic[@"rightText"]]){
            [self.rightBtn setImage:[UIImage imageNamed:@"otc_order_erweima_forbiden"] forState:UIControlStateNormal];
            self.rightBtn.enabled = NO;
            self.rightLabel.hidden = YES;
        }else{
            [self.rightBtn setImage:[UIImage imageNamed:@"otc_order_erweima"] forState:UIControlStateNormal];
            self.rightBtn.enabled = YES;
            self.rightLabel.hidden = YES;
        }
        //防止因自动布局，cell高度变高
         self.rightLabel.numberOfLines = 1;
    }else{
         self.rightBtn.enabled = YES;
         self.rightLabel.hidden = NO;
         [self.rightBtn setImage:[UIImage imageNamed:@"copy_number"] forState:UIControlStateNormal];
         self.rightLabel.numberOfLines = 0;
    }
    
    
}

@end
