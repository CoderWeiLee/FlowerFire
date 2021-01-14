//
//  MoreApplicationViewController.m
//  FlowerFire
//
//  Created by 王涛 on 2020/5/27.
//  Copyright © 2020 Celery. All rights reserved.
//。更多应用

#import "MoreApplicationViewController.h"
#import "MoreApplicationCell.h"
#import <MagicalRecord/MagicalRecord.h>
#import "ChooseCoinTBVC.h"
#import "WTWebViewController.h"
#import "MyOrderPageTBVC.h"
#import "WTMallMainRootViewController.h"
#import "FFBuyRecordViewController.h"
#import "AnnouncementViewController.h"

NSNotificationName const SortHomeButtonNotice = @"SortHomeButtonNotice";
 
extern NSArray *NoticeListArray;
@interface MoreApplicationViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UIButton *_sortButton;
}
@property(nonatomic, strong)UICollectionView *collectionView;
@end

@implementation MoreApplicationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self createNavBar];
    [self createUI];
    [self initData];
}

- (void)createNavBar{
    self.gk_navigationItem.title = LocalizationKey(@"homeButtonTip8");
    //578去掉排序
//    _sortButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_sortButton setTitle:LocalizationKey(@"MoreApplicationTip1") forState:UIControlStateNormal];
//    [_sortButton setTitle:LocalizationKey(@"MoreApplicationTip2") forState:UIControlStateSelected];
//    [_sortButton setTitleColor:MainColor forState:UIControlStateNormal];
//    _sortButton.titleLabel.font = tFont(14);
//    _sortButton.frame = CGRectMake(0, 0, 40, 40);
//    [_sortButton addTarget:self action:@selector(sortClick:) forControlEvents:UIControlEventTouchUpInside];
//    self.gk_navRightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_sortButton];
   
}

- (void)createUI{
    [self.view addSubview:self.collectionView];
}

- (void)initData{
//    self.dataArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"stuHomeBtns"]];
    for (NSDictionary *dic in [[NSUserDefaults standardUserDefaults] objectForKey:@"stuHomeBtns"]) {
        if([dic[@"buttonID"] isEqualToString:@"9"]){
            continue;
        }
        [self.dataArray addObject:dic];
    }
}

- (void)theme_didChanged{ 
     self.gk_navLineHidden = NO;
}

#pragma mark - action 按完成结束
-(void)sortClick:(UIButton *)button{
    button.selected = !button.selected;
//    [_collectionView setUserInteractionEnabled:button.isSelected];
    if(button.isSelected){
        [[UniversalViewMethod sharedInstance] alertShowMessage:nil WhoShow:self CanNilTitle:LocalizationKey(@"MoreApplicationTip3")];
    }else{
        NSArray *tempBtns = [self.dataArray copy];
        [[NSUserDefaults standardUserDefaults] setObject:tempBtns forKey:@"stuHomeBtns"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:SortHomeButtonNotice object:nil];
    }
}

- (void)handlelongGesture:(UILongPressGestureRecognizer *)longGesture {
    //判断手势状态
    switch (longGesture.state) {
        case UIGestureRecognizerStateBegan:{
            //判断手势落点位置是否在路径上
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[longGesture locationInView:self.collectionView]];
            if (indexPath == nil) {
                break;
            }
            //在路径上则开始移动该路径上的cell
            [self.collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
        }
            break;
        case UIGestureRecognizerStateChanged:
            //移动过程当中随时更新cell位置
            [self.collectionView updateInteractiveMovementTargetPosition:[longGesture locationInView:self.collectionView]];
            break;
        case UIGestureRecognizerStateEnded:
            //移动结束后关闭cell移动
            [self.collectionView endInteractiveMovement];
            break;
        default:
            [self.collectionView cancelInteractiveMovement];
            break;
    }
}

#pragma mark - collectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(_sortButton.isSelected){
        return;
    }
     NSDictionary *info = [self.dataArray objectAtIndex:indexPath.item];
     NSInteger buttonId = [info[@"buttonID"] integerValue];
    
     if(buttonId != 7 && buttonId != 9){
        [[UniversalViewMethod sharedInstance] activationStatusCheck:self]; 
     }
    
        switch (buttonId) {
            case 0:
            {
                ChooseCoinTBVC *tvc = [[ChooseCoinTBVC alloc] initWithChooseCoinType:ChooseCoinTypeDeposit];
                [self.navigationController pushViewController:tvc animated:YES];
            }
                break;
            case 2:
            {
                ChooseCoinTBVC *tvc = [[ChooseCoinTBVC alloc] initWithChooseCoinType:ChooseCoinTypeWithdraw];
                [self.navigationController pushViewController:tvc animated:YES];
            }
                break;
            case 4:
            {
                FFBuyRecordViewController *mvc = [[FFBuyRecordViewController alloc] initWithFFBuyRecordType:FFBuyRecordTypeCommission];
                [self.navigationController pushViewController:mvc animated:YES];
                break;
            }
            case 5:
            {
                FFBuyRecordViewController *mvc = [[FFBuyRecordViewController alloc] initWithFFBuyRecordType:FFBuyRecordTypeHidtoryRecord];
                [self.navigationController pushViewController:mvc animated:YES];
                break;
            }
            case 6:
            {
                FFBuyRecordViewController *mvc = [[FFBuyRecordViewController alloc] initWithFFBuyRecordType:FFBuyRecordTypeOrderRecord];
                [self.navigationController pushViewController:mvc animated:YES];
            }
                break;
//            case 7:
//            { //@"http://www.unionexs.com/web/#/help/articlelist/1"
//                [[WTPageRouterManager sharedInstance] jumpToWebView:self.navigationController urlString:NSStringFormat(@"%@%@",BASE_URL,@"/web/#/help/articlelist/1")];
//            }
//                break;
            case 7:
            {
                AnnouncementViewController *avc =[AnnouncementViewController new];
                avc.dataArray = NoticeListArray.mutableCopy;
                [self.navigationController pushViewController:avc animated:YES];
            }
                break;
            case 9:
                break;
//            case 15:
//            {
//                CYLTabBarController *wvc = [[WTMallMainRootViewController new] createNewTabBarWithContext:nil];
//                [self.navigationController pushViewController:wvc animated:YES];
//            }
//                break;
            default:
            {
                Class class = NSClassFromString(info[@"viewControllerName"]);
                if(class){
                    UIViewController *vc = [class new];
                    [self.navigationController pushViewController:vc animated:true];
                }else{
                    printAlert(LocalizationKey(@"homeButtonTip9"), 1.f);
                } 
            }
                break;
        }
         
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    if(_sortButton.isSelected){    //返回YES允许其item移动
        return YES;
    }
    return NO;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath {
    //取出移动row 数据
     NSDictionary *dic = self.dataArray[sourceIndexPath.row];
     //从数据源中移除该数据
     [self.dataArray removeObject:dic];
     //将数据插入到数据源中目标位置
     [self.dataArray insertObject:dic atIndex:destinationIndexPath.row];
    
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    [self.collectionView registerClass:[MoreApplicationCell class] forCellWithReuseIdentifier:identifier];
    MoreApplicationCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    NSDictionary *info = [self.dataArray objectAtIndex:indexPath.item];
    cell.imageView.image = [UIImage imageNamed:info[@"buttonImageName"]];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.title.text = LocalizationKey(info[@"buttonTitle"]);
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section  {
    return self.dataArray.count ;
}
 
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
     
#pragma mark - lazyInit
-(UICollectionView *)collectionView{
    if(!_collectionView){
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.itemSize = CGSizeMake((ScreenWidth - 15 * 2 - 10 * 3)/4, (ScreenWidth - 15 * 2 - 10 * 3)/4);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [self.view addSubview:_collectionView];
        _collectionView.frame = CGRectMake(0, Height_NavBar + 20, ScreenWidth, ScreenHeight - 20);
        _collectionView.contentInset = UIEdgeInsetsMake(0, 15, 0, 15);
        UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlelongGesture:)];
        longGesture.minimumPressDuration = 0.5;
        [_collectionView addGestureRecognizer:longGesture];
    }
    return _collectionView;
}

@end
