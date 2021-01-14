//
//  UserProtocolViewController.m
//  531Mall
//
//  Created by 王涛 on 2020/6/13.
//  Copyright © 2020 Celery. All rights reserved.
//  用户协议

#import "UserProtocolViewController.h"

@interface UserProtocolViewController ()

@end

@implementation UserProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)createNavBar{
    self.gk_navigationItem.title = @"用户协议";
    self.gk_statusBarStyle = UIStatusBarStyleDefault;
}

- (void)initData{
    [self.afnetWork jsonMallPostDict:@"/api/Webmember/protocol" JsonDict:nil Tag:@"1"];
}

- (void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    if(dict[@"data"] != [NSNull null]){
        if([dict[@"data"] isKindOfClass:[NSString class]]){
            NSString *htmlStr = NSStringFormat(@"%@",dict[@"data"] );
            if([HelpManager isBlankString:htmlStr]){
                printAlert(@"协议无内容", 1.f);
            }else{
                [self.wkWebView loadHTMLString:[self htmlEntityDecode:htmlStr] baseURL:nil];
                [self.view ly_hideEmptyView];
            }
        }else{
            printAlert(@"协议无内容", 1.f);
        }
    }else{
        printAlert(@"协议已删除", 1.f);
    }

}

@end
