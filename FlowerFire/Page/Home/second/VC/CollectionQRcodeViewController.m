//
//  CollectionQRcodeViewController.m
//  FlowerFire
//
//  Created by 王涛 on 2020/7/15.
//  Copyright © 2020 Celery. All rights reserved.
//  收款码

#import "CollectionQRcodeViewController.h"
#import <LBXScanNative.h>
#import "SQCustomButton.h"
#import "ScanCodeViewController.h"
#import "LedgerViewController.h"
#import "FFBuyRecordViewController.h"

@interface CollectionQRcodeViewController ()
{
    UIImageView *_qrCodeImage;
    UILabel     *_address;
}
@end

@implementation CollectionQRcodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     
    [self createNavBar];
    [self createUI];
    [self initData];
}

#pragma mark - action
- (void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    if([type isEqualToString:@"1"]){
        NSString *qr_code = NSStringFormat(@"%@",dict[@"data"][@"qr_code"]);
        [_qrCodeImage sd_setImageWithURL:[NSURL URLWithString:qr_code]];

    }else{
        printAlert(dict[@"msg"], 1.f);
        [self closeVC];
    }
}

#pragma mark - initViewDelegate
- (void)createNavBar{
    self.gk_navBackgroundColor = KGrayBacColor;
    self.gk_navigationItem.title = LocalizationKey(@"CollectionQRcodeTip1");
   
    WTButton *button = [[WTButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40) titleStr:@"记录" titleFont:tFont(15) titleColor:[UIColor grayColor] parentView:nil];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    @weakify(self)
    [button addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        @strongify(self)
        FFBuyRecordViewController *jvc = [[FFBuyRecordViewController alloc] initWithFFBuyRecordType:FFBuyRecordTypeHidtoryRecord];
        [self.navigationController pushViewController:jvc animated:YES];
    }];
    
    self.gk_navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)createUI{
    self.view.backgroundColor = KGrayBacColor;
    
    WTBacView *bacView = [[WTBacView alloc] initWithFrame:CGRectMake(50, self.view.centerY - 180 - Height_NavBar, ScreenWidth - 2 * 50, ScreenWidth - 2 * 50) backGroundColor:KWhiteColor parentView:self.view];
    bacView.layer.cornerRadius = 5;
    
    _qrCodeImage = [[UIImageView alloc] initWithFrame:CGRectMake(40, 40, bacView.width - 80, bacView.width - 80)];
    [bacView addSubview:_qrCodeImage];
      
//    WTLabel *_line = [[WTLabel alloc] initWithFrame:CGRectMake(bacView.left + 2.5, bacView.bottom-1, bacView.width - 2.5, 1) Text:@"- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - " Font:tFont(11) textColor:grayTextColor parentView:self.view];
//
//    WTBacView *grayBac = [[WTBacView alloc] initWithFrame:CGRectMake(bacView.left, _line.bottom, bacView.width, 90) backGroundColor:RGB(244, 249, 252) parentView:self.view];
//    grayBac.layer.cornerRadius = 5;
//
//    _address = [[UILabel alloc] initWithFrame:CGRectZero ];
//    _address.text = @"rNgLX7BQv&CQFgYGZxYUK8QajGUSNWREQyV";
//    _address.font = [UIFont boldSystemFontOfSize:14];
//    _address.adjustsFontSizeToFitWidth = YES;
//
//    [grayBac addSubview:_address];
//    [_address mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(grayBac.mas_top).offset(20);
//        make.left.mas_equalTo(grayBac.mas_left).offset(15);
//        make.right.mas_equalTo(grayBac.mas_right).offset(-15);
//        make.height.mas_equalTo(30);
//    }];
//
//
//    WTButton *copyButton = [[WTButton alloc] initWithFrame:CGRectZero titleStr:LocalizationKey(@"CollectionQRcodeTip2") titleFont:tFont(14) titleColor:RGB(73, 134, 236) parentView:grayBac];
//    [copyButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(grayBac.mas_left).offset(5);
//        make.right.mas_equalTo(grayBac.mas_right).offset(-5);
//        make.top.mas_equalTo(_address.mas_bottom).offset(5);
//        make.height.mas_equalTo(30);
//    }];
//
//    CGFloat roundWidth = 15;
//    WTBacView *leftRoundView = [[WTBacView alloc] initWithFrame:CGRectMake(bacView.left - roundWidth /2, bacView.bottom - roundWidth /2, roundWidth, roundWidth) backGroundColor:self.view.backgroundColor parentView:self.view];
//    leftRoundView.layer.cornerRadius = roundWidth/2;
//
//    WTBacView *rightRoundView = [[WTBacView alloc] initWithFrame:CGRectMake(bacView.right - roundWidth/2, bacView.bottom - roundWidth/2, roundWidth, roundWidth) backGroundColor:self.view.backgroundColor parentView:self.view];
//    rightRoundView.layer.cornerRadius = roundWidth/2;
    
    SQCustomButton *scanButton = [[SQCustomButton alloc] initWithFrame:CGRectMake(bacView.left + 20, ScreenHeight - Height_NavBar - SafeAreaBottomHeight - 30, 50, 50) type:SQCustomButtonTopImageType imageSize:CGSizeMake(30, 30) midmargin:5];
    scanButton.titleLabel.text = LocalizationKey(@"CollectionQRcodeTip3");
    scanButton.titleLabel.font = tFont(12);
    scanButton.titleLabel.textColor = [UIColor grayColor];
    scanButton.imageView.image = [UIImage imageNamed:@"img34"];
    [self.view addSubview:scanButton];
    
    SQCustomButton *collectionButton = [[SQCustomButton alloc] initWithFrame:CGRectMake(bacView.right - 50 - 20, ScreenHeight - Height_NavBar - SafeAreaBottomHeight - 30, 50, 50) type:SQCustomButtonTopImageType imageSize:CGSizeMake(30, 30) midmargin:5];
    collectionButton.titleLabel.text = LocalizationKey(@"CollectionQRcodeTip1");
    collectionButton.titleLabel.font = tFont(12);
    collectionButton.titleLabel.textColor = [UIColor grayColor];
    collectionButton.imageView.image = [UIImage imageNamed:@"img45"];
    [self.view addSubview:collectionButton];
    
   
    @weakify(self)
//    [copyButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
//        @strongify(self)
//        if([self->_address.text isEqualToString:@"--"]){
//            printAlert(LocalizationKey(@"CollectionQRcodeTip4"), 1.f);
//        }else{
//            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
//            pasteboard.string = self->_address.text;
//            printAlert(LocalizationKey(@"Successful copy"), 1.f);
//        }
//    }];
     
    [scanButton touchAction:^(SQCustomButton * _Nonnull button) {
        @strongify(self)
        ScanCodeViewController *svc = [ScanCodeViewController new];
        [self.navigationController pushViewController:svc animated:YES];
    }];
    NSLog(@"%@", [WTUserInfo shareUserInfo].token);
}

//获取转账二维码 /api/user/qrCode
- (void)initData{
    [self.afnetWork jsonGetDict:@"/api/user/qrCode" JsonDict:nil Tag:@"1"];
}

@end
