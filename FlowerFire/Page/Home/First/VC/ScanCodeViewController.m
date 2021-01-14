//
//  ScanCodeViewController.m
//  FlowerFire
//
//  Created by 王涛 on 2020/5/25.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "ScanCodeViewController.h"
#import "WithdrawCoinTBVC.h"
#import "PermissionUtil.h"
#import "StyleDIY.h"
#import "TransferViewController.h"
#import "RechargeTransferViewController.h"

@interface ScanCodeViewController ()

@end

@implementation ScanCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     
    self.libraryType = SLT_Native;
    self.scanCodeType = SCT_QRCode;
    self.style = [StyleDIY qqStyle];
    self.isVideoZoom = YES;
    
    self.gk_statusBarStyle = UIStatusBarStyleLightContent;
    self.gk_navBarAlpha = 0;
    self.gk_navTitleColor = KWhiteColor;
    self.gk_navigationItem.title = @"扫一扫";
    self.gk_backStyle = GKNavigationBarBackStyleWhite;
}

-(void)analyzeQRCode:(NSString *)codeStr{
    NSError * error;
    NSData * data = [codeStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *resdic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:&error];
     
    if([resdic[@"type"] isEqualToString:@"transfer"]){
        NSString *herName = resdic[@"data"];
        if(![HelpManager isBlankString:herName]){
            if(self.qrCodeBlock){
                self.qrCodeBlock(herName);
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                TransferViewController *wtbvc = [TransferViewController new];
                wtbvc.herName = herName;
                wtbvc.hidesBottomBarWhenPushed = YES;
                [[WTPageRouterManager sharedInstance] pushNextCloseCurrentViewController:self nextVC:wtbvc];
            }
        }
    }else if([codeStr hasPrefix:@"SD"]){
        RechargeTransferViewController *wtbvc = [RechargeTransferViewController new];
        wtbvc.herName = codeStr;
        wtbvc.hidesBottomBarWhenPushed = YES;
        [[WTPageRouterManager sharedInstance] pushNextCloseCurrentViewController:self nextVC:wtbvc];
         
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
 
@end
