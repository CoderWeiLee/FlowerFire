//
//  ApplyCoinViewController.m
//  FlowerFire
//
//  Created by 王涛 on 2020/7/15.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "ApplyCoinViewController.h"
#import "SettingUpdateSubmitButton.h"
#import "ApplyCoinCell.h"

@interface ApplyCoinViewController ()<YYTextViewDelegate>
{
    SettingUpdateSubmitButton *_bottomView;
    NSString *_one,*_two,*_three,*_four,*_five,*_six,*_seven,*_eight,*_night;
}
@end

@implementation ApplyCoinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self createNavBar];
    [self initData];
    [self createUI];
    
}

#pragma mark - action
/// 提交修改
-(void)submitClick{
    [self closeVC];
}

- (void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    if([type isEqualToString:@"1"]){
 
    }else{
        printAlert(dict[@"msg"], 1.f);
        [self closeVC];
    }
}

#pragma mark - initViewDelegate
- (void)createNavBar{
    self.gk_navigationItem.title = LocalizationKey(@"RaiseTip9");
}

- (void)createUI{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight - Height_NavBar)];
    scrollView.bounces = NO;
    [self.view addSubview:scrollView];
    
    WTBacView *redTopBac = [[WTBacView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100) backGroundColor:MainColor parentView:scrollView];
    //ScreenHeight - 0 - 100 + 30 - 30 - Height_NavBar
    self.view.backgroundColor = KGrayBacColor;
 
    self.tableView.backgroundColor = KWhiteColor;
    self.tableView.layer.cornerRadius = 5;
    self.tableView.scrollEnabled = NO;
    
    _bottomView = [[SettingUpdateSubmitButton alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 150)];
    
    WTBacView *line = [[WTBacView alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, _bottomView.top+10, ScreenWidth - 2 * OverAllLeft_OR_RightSpace, 1) backGroundColor:FlowerFirexianColor parentView:_bottomView];
    
    WTLabel *tip = [[WTLabel alloc] initWithFrame:CGRectMake(line.left, line.bottom + 10, line.width, 20) Text:LocalizationKey(@"RaiseTip45") Font:tFont(15) textColor:grayTextColor parentView:_bottomView];
    _bottomView.submitButton.top = tip.bottom + 20;
    [_bottomView.submitButton setTitle:LocalizationKey(@"RaiseTip46") forState:UIControlStateNormal];
    [_bottomView.submitButton addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    _bottomView.bottom = _bottomView.submitButton.bottom + 25;
    
    self.tableView.tableFooterView = _bottomView;
    [scrollView addSubview:self.tableView];
    
    self.tableView.frame = CGRectMake(OverAllLeft_OR_RightSpace, redTopBac.bottom - 30, ScreenWidth - 2 * OverAllLeft_OR_RightSpace, 30 + 70 * self.dataArray.count +  _bottomView.height);
     
    scrollView.contentSize = CGSizeMake(ScreenWidth, self.tableView.bottom + 30);
}

- (void)theme_didChanged{
     self.gk_navLineHidden = NO;
}

- (void)initData{
    self.dataArray = @[@{@"tip":@"RaiseTip27",@"placeholderText":@"RaiseTip28",@"start":@"1"},
    @{@"tip":@"RaiseTip29",@"placeholderText":@"RaiseTip30",@"start":@"1"},
    @{@"tip":@"RaiseTip31",@"placeholderText":@"RaiseTip32",@"start":@"1"},
    @{@"tip":@"RaiseTip33",@"placeholderText":@"RaiseTip34",@"start":@"1"},
    @{@"tip":@"RaiseTip35",@"placeholderText":@"RaiseTip36",@"start":@"1"},
    @{@"tip":@"RaiseTip37",@"placeholderText":@"RaiseTip38",@"start":@"0"},
    @{@"tip":@"RaiseTip39",@"placeholderText":@"RaiseTip40",@"start":@"1"},
    @{@"tip":@"RaiseTip41",@"placeholderText":@"RaiseTip42",@"start":@"1"},
    @{@"tip":@"RaiseTip43",@"placeholderText":@"RaiseTip44",@"start":@"1"},
    ].copy;
}

#pragma mark - tableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    [self.tableView registerClass:[ApplyCoinCell class] forCellReuseIdentifier:identifier];
    ApplyCoinCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if(self.dataArray.count>0){
        [cell setCellData:self.dataArray[indexPath.row]];
    }
    cell.textView.tag = indexPath.row;
    cell.textView.delegate = self;

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 0){
        WTBacView *bac = [[WTBacView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30) backGroundColor:KWhiteColor parentView:nil];
        WTLabel *_redStart = [[WTLabel alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, 10, 15, 15) Text:@"*" Font:tFont(15) textColor:MainColor parentView:bac];
        
        WTLabel *allNum = [[WTLabel alloc] initWithFrame:CGRectMake(_redStart.right, 10, ScreenWidth - OverAllLeft_OR_RightSpace, 20) Text:LocalizationKey(@"RaiseTip26") Font:tFont(15) textColor:grayTextColor parentView:bac];
        _redStart.centerY = allNum.centerY;
        return bac;
    }else{
        return nil;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return 30;
    }
    return 0;
}

- (void)textViewDidChange:(YYTextView *)textView{
    switch (textView.tag) {
        case 0:
            _one = textView.text;
            break;
        case 1:
            _two = textView.text;
            break;
        case 2:
            _three = textView.text;
            break;
        case 3:
            _four = textView.text;
            break;
        case 4:
            _five = textView.text;
            break;
        case 5:
            _six = textView.text;
            break;
        case 6:
            _seven = textView.text;
            break;
        case 7:
            _eight = textView.text;
            break;
        default:
            _night = textView.text;
            break;
    }
    if(_one.length && _two.length
       && _three.length
       && _four.length
       && _five.length
       && _seven.length
       && _eight.length
       && _night.length){
        _bottomView.submitButton.enabled = YES;
    }else{
        _bottomView.submitButton.enabled = NO;
    }
}
 
 

@end
