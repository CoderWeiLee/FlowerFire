//
//  QRCodeVC.m
//  FireCoin
//
//  Created by 王涛 on 2019/8/2.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "QRCodeVC.h"
#import "PermissionUtil.h"

@interface QRCodeVC ()

@end

@implementation QRCodeVC

- (void)dealloc
{
    NSLog(@"dealloc了");
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
 

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [PermissionUtil checkCameraPermission];
    
    self.title = @"";
    self.view.backgroundColor = [UIColor blackColor];
     
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 100, 30);
    [rightBtn sizeToFit];
    [rightBtn setTitle:LocalizationKey(@"Album") forState:UIControlStateNormal];
    [rightBtn setTitleColor:KWhiteColor forState:UIControlStateNormal];
    //[rightBtn theme_setTitleColor:THEME_TEXT_COLOR forState:UIControlStateNormal];
    self.gk_navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [rightBtn addTarget:self action:@selector(openPhoto) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.titleLabel.font = tFont(15);
    
    //设置扫码后需要扫码图像
    self.isNeedScanImage = YES;
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    [self drawTitle];
    [self.view bringSubviewToFront:_topTitle];
    self.gk_navigationBar.hidden = NO;
    [self.view bringSubviewToFront:self.gk_navigationBar];
}

//绘制扫描区域
- (void)drawTitle
{
    if (!_topTitle)
    {
        self.topTitle = [[UILabel alloc]init];
//        _topTitle.bounds = CGRectMake(0, 0, ScreenWidth - 100, 60);
//        _topTitle.center = CGPointMake(CGRectGetWidth(self.view.frame)/2, 50);
//
//        //3.5inch iphone
//        if ([UIScreen mainScreen].bounds.size.height <= 568 )
//        {
//            _topTitle.center = CGPointMake(CGRectGetWidth(self.view.frame)/2, 38);
//            _topTitle.font = [UIFont systemFontOfSize:14];
//        }
        
        _topTitle.textAlignment = NSTextAlignmentCenter;
        _topTitle.numberOfLines = 0;
        _topTitle.text = LocalizationKey(@"qrCodeTip2");
        _topTitle.textColor = [UIColor whiteColor];
        [self.view addSubview:_topTitle];
        [_topTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.qRScanView.mas_bottom).offset(-50);
            make.centerX.mas_equalTo(self.view.mas_centerX);
            
        }];
    }
}



- (void)showError:(NSString*)str
{
    [[UniversalViewMethod sharedInstance] alertShowMessage:str WhoShow:self CanNilTitle:nil];
}

- (void)scanResultWithArray:(NSArray<LBXScanResult*>*)array
{
    if (array.count < 1)
    {
        [self popAlertMsgWithScanResult:nil];
        
        return;
    }
    
    //经测试，可以同时识别2个二维码，不能同时识别二维码和条形码
    for (LBXScanResult *result in array) {
        
        [self analyzeQRCode:result.strScanned];
        NSLog(@"scanResult:%@",result.strScanned);
    }
    
    LBXScanResult *scanResult = array[0];
    
    NSString*strResult = scanResult.strScanned;
    
    self.scanImage = scanResult.imgScanned;
    
    if (!strResult) {
        
        [self popAlertMsgWithScanResult:nil];
        
        return;
    }
    
    //加入震动感反馈
    UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle: UIImpactFeedbackStyleHeavy];
    [generator prepare];
    [generator impactOccurred];
    
    
}

-(void)analyzeQRCode:(NSString *)codeStr{
    !self.qrCodeBlock ? : self.qrCodeBlock(codeStr);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)popAlertMsgWithScanResult:(NSString*)strResult
{
    if (!strResult) {
        
        strResult =  LocalizationKey(@"qrCodeTip1");
    }
    printAlert(strResult, 1.f);
}

//打开相册
- (void)openPhoto
{
    [PermissionUtil checkPhotoPermission]; 
    [self openLocalPhoto:NO];
}

@end
