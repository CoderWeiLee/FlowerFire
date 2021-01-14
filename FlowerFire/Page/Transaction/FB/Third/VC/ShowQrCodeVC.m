//
//  ShowQrCodeVC.m
//  FireCoin
//
//  Created by 王涛 on 2019/6/15.
//  Copyright © 2019 王涛. All rights reserved.
//  显示收款二维码页面

#import "ShowQrCodeVC.h"

@interface ShowQrCodeVC ()

@end

@implementation ShowQrCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.gk_navigationItem.title = LocalizationKey(@"FiatOrderTip39");
    
    UIImageView *qrCode = [[UIImageView alloc] initWithFrame:CGRectMake(0, Height_NavBar + 50, ScreenWidth, ScreenWidth)]; 
    qrCode.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:qrCode];
    
    [qrCode sd_setImageWithURL:[NSURL URLWithString:self.imageUrlStr] placeholderImage:[UIImage imageNamed:@"address_unabled_image"]];
}



@end
