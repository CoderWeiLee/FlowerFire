//
//  ArticlesInfoViewController.m
//  531Mall
//
//  Created by 王涛 on 2020/6/11.
//  Copyright © 2020 Celery. All rights reserved.
//  文章详情
 
#import "ArticlesInfoViewController.h"
#import <JXBWKWebView.h>
#import "EmptyDataView.h"

@interface ArticlesInfoViewController ()<WKNavigationDelegate,UIScrollViewDelegate>
{
    NSInteger _netLockIndex;
}
/// 文章id
@property(nonatomic, strong)NSString     *articlesID;
/// 文章标题
@property(nonatomic, strong)NSString     *articlesTitle;
@property(nonatomic, strong)JXBWKWebView *wkWebView;
/// 滑动到底部就做任务，网络成功，就把任务改为成功
@property(nonatomic, assign)BOOL          isTaskSuccess,isScrollBottom;
@end

@implementation ArticlesInfoViewController

- (instancetype)initWithArticlesID:(NSString *)articlesID articlesTitle:(nonnull NSString *)articlesTitle{
    self = [super init];
    if(self){
        self.articlesID = articlesID;
        self.articlesTitle = articlesTitle;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self createNavBar];
    [self createUI];
    [self initData];
}

- (void)createNavBar{
    self.gk_navigationItem.title = self.articlesTitle;
    self.gk_statusBarStyle = UIStatusBarStyleDefault;
}
 
- (void)createUI{
    [self.view addSubview:self.wkWebView];
    
    self.view.ly_emptyView = [EmptyDataView diyCustomEmptyViewWithTarget:self action:@selector(initData)];
}

- (void)initData{
    NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:1];
    md[@"id"] = self.articlesID;
    [self.afnetWork jsonMallPostDict:@"/api/index/articlesInfo" JsonDict:md Tag:@"1"];
}

- (void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    if(dict[@"data"] != [NSNull null]){
        NSString *htmlStr = NSStringFormat(@"%@",dict[@"data"][@"content"] );
        self.gk_navigationItem.title = NSStringFormat(@"%@",dict[@"data"][@"title"]);
        if([HelpManager isBlankString:htmlStr]){
            printAlert(@"文章无内容", 1.f);
        }else{
            [self.wkWebView loadHTMLString:[self htmlEntityDecode:htmlStr] baseURL:nil];
            [self.view ly_hideEmptyView];
        }
    }else{
        printAlert(@"文章已删除", 1.f);
    }

}

- (NSString*)htmlEntityDecode:(NSString*)string{
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    return string;
}
 
- (void)dataErrorHandle:(NSDictionary *)dict type:(NSString *)type{
    [self.view ly_showEmptyView];
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    // 不执行前段界面弹出列表的JS代码，关闭系统的长按保存图片
    [webView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none';" completionHandler:nil];

    @weakify(self)
    [webView evaluateJavaScript:@"document.body.offsetHeight;" completionHandler:^(id Result, NSError * error) {
        @strongify(self)
        self.wkWebView.scrollView.delegate = self;
    }];
}

#pragma mark - scrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //是任务文章进任务文章
    if(![HelpManager isBlankString:self.taskID]){
        //任务没有完成
        if(!self.isTaskSuccess){
            //滑动到了底部算法
            if (scrollView.isDecelerating || scrollView.isDragging){
                if (scrollView.bounds.size.height + scrollView.contentOffset.y >= scrollView.contentSize.height){
                    self.isScrollBottom = true;
                }
            }
        }
    }


}

- (void)setIsScrollBottom:(BOOL)isScrollBottom{
    _isScrollBottom = isScrollBottom;

    NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:3];
    md[@"userid"] = [WTMallUserInfo shareUserInfo].ID;
    md[@"sessionid"] = [WTMallUserInfo shareUserInfo].sessionid;
    md[@"task_id"] = self.taskID;
    
    //防止走scrollview代理一个滑动多次请求
    if(_netLockIndex == 0){
        _netLockIndex++;
        @weakify(self)
        [[ReqestHelpManager share] requestMallPost:@"/api/task/completeTask" andHeaderParam:md finish:^(NSDictionary *dicForData, ReqestType flag) {
            @strongify(self)
            self.isTaskSuccess = YES;
            if([dicForData[@"status"] integerValue] == 1){
                printAlert(dicForData[@"msg"], 1.f);
            }else if([dicForData[@"status"] integerValue] == 9){ 
                self->_netLockIndex = 0;
                [self jumpLogin];
            }else{
                self->_netLockIndex = 0;
                printAlert(dicForData[@"msg"], 1.f);
            }
        }];
    }

}


-(JXBWKWebView *)wkWebView{
    if(!_wkWebView){
        //自适应文字和图片
        NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta); var imgs = document.getElementsByTagName('img');for (var i in imgs){imgs[i].style.maxWidth='100%';imgs[i].style.height='auto';}";
        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        WKUserContentController *wkUController = [[WKUserContentController alloc] init];
        [wkUController addUserScript:wkUScript];
        WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
        wkWebConfig.userContentController = wkUController;
        wkWebConfig.allowsInlineMediaPlayback = YES;
        
        _wkWebView = [[JXBWKWebView alloc] initWithFrame:CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight - Height_NavBar) configuration:wkWebConfig];
        _wkWebView.navigationDelegate = self;
        _wkWebView.scrollView.contentSize = CGSizeZero;
        
  
    }
    return _wkWebView;
}


@end
