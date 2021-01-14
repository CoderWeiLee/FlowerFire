//
//  HomeNavtionView.m
//  531Mall
//
//  Created by 王涛 on 2020/5/18.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "HomeNavtionView.h"
#import "PYSearchViewController.h"
#import "SearchResultViewController.h"
#import "NewsViewController.h"

@interface HomeNavtionView ()
{
    UIView      *_bacView;
    UIButton    *_address;
    UITextField *_searchField;
    UIButton    *_customerServiceButton;
    UIView      *_statusBarView;
    UIButton    *_jumpSearchVCButton;
}
@end

@implementation HomeNavtionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
        [self layoutSubview];
           
        [_customerServiceButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            //联系客服
            [MBManager showLoading];
            [[ReqestHelpManager share] requestMallPost:@"/api/login/system_info" andHeaderParam:nil finish:^(NSDictionary *dicForData, ReqestType flag) {
                [MBManager hideAlert];
                if([dicForData[@"status"] integerValue] == 1){
                    NSString *customerPhoneNumber = NSStringFormat(@"%@",dicForData[@"data"][@"tels"]);
                    
                    if([HelpManager isBlankString:customerPhoneNumber]){
                        printAlert(@"未设置客服电话,请返回重试", 1.f);
                        return;
                    }
                    NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",customerPhoneNumber];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:nil];
                }else{
                    printAlert(dicForData[@"msg"], 1.f);
                }
            }];
        }];
    }
    return self;
}

#pragma mark - action
-(void)jumpSearchClick{
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:nil searchBarPlaceholder:@"请输入搜索内容" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
            SearchResultViewController *searchVC = [[SearchResultViewController alloc] init];
            searchVC.searchText = searchText;
            [searchViewController.navigationController pushViewController:searchVC animated:YES];
        }];
    searchViewController.searchHistoryStyle = PYHotSearchStyleNormalTag;
    
    searchViewController.searchViewControllerShowMode = PYSearchViewControllerShowModePush;
    [[self viewController].navigationController pushViewController:searchViewController animated:YES];
}

- (void)createUI{
    self.backgroundColor = rgba(0, 0, 0, 0.35);
    
    _statusBarView = [[UIView alloc] init];
    [self addSubview:_statusBarView];
    
    _bacView = [[UIView alloc] init];
    [self addSubview:_bacView];
    
    _address = [UIButton buttonWithType:UIButtonTypeCustom];
    [_address setImage:[UIImage imageNamed:@"weiz"] forState:UIControlStateNormal];
    [_address.titleLabel setFont:tFont(14)];
    [_bacView addSubview:_address];
    [self updateAddress];
     
    _searchField = [UITextField new];
    _searchField.backgroundColor = KWhiteColor;
    _searchField.placeholder = @"搜索你想要的商品";
    _searchField.font = tFont(12);
    _searchField.layer.cornerRadius = 10;
    _searchField.layer.masksToBounds = YES;
    _searchField.userInteractionEnabled = NO;
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    UIImageView *leftImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fdj"]];
    [leftView addSubview:leftImage];
    leftImage.frame = CGRectMake(0, 0, 12.5, 12.5);
    leftImage.center = leftView.center;
    _searchField.leftView = leftView;
    _searchField.leftViewMode = UITextFieldViewModeAlways;
    [_bacView addSubview:_searchField];
    
    _customerServiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_customerServiceButton setImage:[UIImage imageNamed:@"kef"] forState:UIControlStateNormal];
    [_bacView addSubview:_customerServiceButton];
     
    _jumpSearchVCButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bacView addSubview:_jumpSearchVCButton];
    
    [_jumpSearchVCButton addTarget:self action:@selector(jumpSearchClick) forControlEvents:UIControlEventTouchUpInside];
  
}

-(void)updateAddress{
    if([HelpManager isBlankString:[WTMallUserInfo shareUserInfo].addr]){
        [_address setTitle:@"未知" forState:UIControlStateNormal];
     }else{
         [_address setTitle:[[WTMallUserInfo shareUserInfo].addr componentsSeparatedByString:@" "][0] forState:UIControlStateNormal];
         [_address mas_updateConstraints:^(MASConstraintMaker *make) {
             make.size.mas_equalTo(CGSizeMake([HelpManager getLabelWidth:14 labelTxt:_address.titleLabel.text].width+20 + _address.imageView.width + 10, 40));
         }];
     }
}

- (void)layoutSubview{
    _statusBarView.frame = CGRectMake(0,0,ScreenWidth,Height_StatusBar);
    _bacView.frame = CGRectMake(0,Height_StatusBar,ScreenWidth,44.5 );
    [_address mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(OverAllLeft_OR_RightSpace).priorityHigh();
        make.centerY.mas_equalTo(_bacView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake([HelpManager getLabelWidth:14 labelTxt:_address.titleLabel.text].width+20 + _address.imageView.width + 10, 40));
    }];
    
    [_customerServiceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-OverAllLeft_OR_RightSpace);
        make.centerY.mas_equalTo(_address.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(23.5, 23.5));
    }];
    
    [_searchField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_address.mas_right).offset(15.5).priorityHigh();
        make.centerY.mas_equalTo(_address.mas_centerY);
        make.height.mas_equalTo(21);
        make.right.mas_equalTo(_customerServiceButton.mas_left).offset(-30);
    }];
    
    [_jumpSearchVCButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_address.mas_right).offset(15.5).priorityHigh();
        make.centerY.mas_equalTo(_address.mas_centerY);
        make.height.mas_equalTo(21);
        make.right.mas_equalTo(_customerServiceButton.mas_left).offset(-30);
    }];
}
 
    
@end
