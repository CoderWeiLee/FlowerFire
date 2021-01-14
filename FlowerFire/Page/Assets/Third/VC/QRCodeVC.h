//
//  QRCodeVC.h
//  FireCoin
//
//  Created by 王涛 on 2019/8/2.
//  Copyright © 2019 王涛. All rights reserved.
//

#import <LBXScanViewController.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^QRCodeBlock)(NSString *scanResult);

@interface QRCodeVC : LBXScanViewController

/**
 @brief  扫码区域上方提示文字
 */
@property (nonatomic, strong) UILabel *topTitle;

#pragma mark --增加拉近/远视频界面
@property (nonatomic, assign) BOOL      isVideoZoom;
@property(nonatomic, copy) QRCodeBlock  qrCodeBlock;
@end

NS_ASSUME_NONNULL_END
