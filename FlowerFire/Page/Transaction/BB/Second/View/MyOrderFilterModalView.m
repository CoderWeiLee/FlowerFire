//
//  MyOrderFilterModalView.m
//  FireCoin
//
//  Created by 王涛 on 2019/6/26.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "MyOrderFilterModalView.h"
#import "OrderRecordFilterModalCell.h"

static const CGFloat viewHeight = 260;

@interface MyOrderFilterModalView ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UIButton *_transparentBtn;
}

@property(nonatomic, strong) UICollectionView      *collectionView;
@property(nonatomic, strong) NSArray<NSArray  *>   *dataArray;
@property(nonatomic, strong) NSArray<NSString *>   *sectionArray;
/**
 选中的交易类型
 */
@property(nonatomic, strong) NSMutableArray <NSIndexPath *> *selectedTypeArray;
/**
 选中的订单状态
 */
@property(nonatomic, strong) NSMutableArray <NSIndexPath *> *selectedStatusArray;
@end

@implementation MyOrderFilterModalView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      //  [self initData];
        [self setUpView];
    }
    return self;
}

-(void)cleanClick{//重置数据
    [self hideView];
    self.paramsType = @"all";
    self.paramsStatus = @"all";
    [self.selectedTypeArray removeAllObjects];
    [self.selectedStatusArray removeAllObjects];
    [self.collectionView reloadData];
    !self.myOrderFilterBlock ? : self.myOrderFilterBlock(self.paramsType,self.paramsStatus);
}

-(void)submitClick{
    [self hideView];
    !self.myOrderFilterBlock ? : self.myOrderFilterBlock(self.paramsType,self.paramsStatus);
}

#pragma mark - dataSouce
-(void)initData{
    [self.selectedTypeArray removeAllObjects];
    [self.selectedStatusArray removeAllObjects];
//    if(self.myOrderPageType == MyOrderPageTypeAll){
//        self.sectionArray = @[@"订单状态"];
//        self.dataArray = @[@[@{@"btnName":@"购买"},@{@"btnName":@"出售"}]];
//        [self.collectionView reloadData];
//    }else{
        self.sectionArray = @[LocalizationKey(@"Order Type"),LocalizationKey(@"Order Status")];
        self.dataArray = @[@[@{@"btnName":LocalizationKey(@"Buy1")},@{@"btnName":LocalizationKey(@"Sell1")}],@[@{@"btnName":LocalizationKey(@"Deal done")},@{@"btnName":LocalizationKey(@"cancel2")}]];
        [self.collectionView reloadData];
   // }
}

#pragma mark - collecionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        self.selectedTypeArray = [NSMutableArray array];
        [self.selectedTypeArray addObject:indexPath];
        [collectionView reloadData];
    }else{
        self.selectedStatusArray = [NSMutableArray array];
        [self.selectedStatusArray addObject:indexPath];
        [collectionView reloadData];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    [self.collectionView registerClass:[OrderRecordFilterModalCell class] forCellWithReuseIdentifier:identifier];
    OrderRecordFilterModalCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath]; 
    [cell.button setTitle:self.dataArray[indexPath.section][indexPath.row][@"btnName"] forState:UIControlStateNormal];
    if(indexPath.section == 0){
        if([self.selectedTypeArray containsObject:indexPath]){
            cell.button.layer.borderWidth = 1;
            [cell.button setTitleColor:MainColor forState:UIControlStateNormal];
            cell.button.layer.borderColor = MainColor.CGColor;
            self.paramsType = cell.button.titleLabel.text;
        }else{
            cell.button.layer.borderWidth = 0;
            [cell.button theme_setTitleColor:THEME_TEXT_COLOR forState:UIControlStateNormal];
        }
    }else{
        if([self.selectedStatusArray containsObject:indexPath]){
            cell.button.layer.borderWidth = 1;
            [cell.button setTitleColor:MainColor forState:UIControlStateNormal];
            cell.button.layer.borderColor = MainColor.CGColor;
            self.paramsStatus = cell.button.titleLabel.text;
        }else{
            cell.button.layer.borderWidth = 0;
            [cell.button theme_setTitleColor:THEME_TEXT_COLOR forState:UIControlStateNormal];
        }
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView"];
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView" forIndexPath:indexPath];
    if(kind == UICollectionElementKindSectionHeader){
        for (UIView *view in headerView.subviews) {
            [view removeFromSuperview];
        }
        UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
        la.text = self.sectionArray[indexPath.section];
        la.theme_textColor = THEME_TEXT_COLOR;
        la.font = tFont(16);
        [headerView addSubview:la];
        
        return headerView;
    }
    return headerView;
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.sectionArray.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray[section].count;
}

#pragma mark - ui
-(void)setUpView{
    self.frame = CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight - Height_NavBar);
    self.mainView = [[UIView alloc] initWithFrame:CGRectMake(0, -300, ScreenWidth, viewHeight)];
    self.mainView.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
    [self addSubview:self.mainView];
    
    [self.mainView addSubview:self.collectionView];
    
    UIButton *cleanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cleanBtn setTitle:LocalizationKey(@"Reset") forState:UIControlStateNormal];
    [cleanBtn theme_setTitleColor:THEME_TEXT_COLOR forState:UIControlStateNormal];
    cleanBtn.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
    [self.mainView addSubview:cleanBtn];
    [cleanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mainView.mas_left).offset(0);
        make.size.mas_equalTo(CGSizeMake(self.mainView.width/2, 50));
        make.bottom.mas_equalTo(self.mainView.mas_bottom).offset(0);
    }];
    
    UIButton *submitBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitBtn setTitle:LocalizationKey(@"determine") forState:UIControlStateNormal];
    submitBtn.backgroundColor = MainColor;
    [self.mainView addSubview:submitBtn];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mainView.mas_right).offset(-0);
        make.size.mas_equalTo(CGSizeMake(self.mainView.width/2, 50));
        make.bottom.mas_equalTo(self.mainView.mas_bottom).offset(0);
    }];
    
    UIView *line = [UIView new];
    line.theme_backgroundColor = THEME_LINE_TABLEVIEW_SEPARATOR_COLOR;
    [self.mainView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(submitBtn.mas_top);
        make.left.mas_equalTo(self.mainView);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, 1));
    }];
    
    _transparentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _transparentBtn.frame = CGRectMake(0, CGRectGetMaxY(self.mainView.frame), ScreenWidth, ScreenHeight - self.mainView.height);
    [self addSubview:_transparentBtn];
    
    
    [_transparentBtn addTarget:self action:@selector(hideView) forControlEvents:UIControlEventTouchUpInside];
    [cleanBtn addTarget:self action:@selector(cleanClick) forControlEvents:UIControlEventTouchUpInside];
    [submitBtn addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
}

-(void)updateConstraints{
    [super updateConstraints];
    _transparentBtn.frame = CGRectMake(0, CGRectGetMaxY(self.mainView.frame), ScreenWidth, ScreenHeight - self.mainView.height);
}

#pragma mark - publicMethod
-(void)showView:(UIViewController *)vc{
    self.isShow = YES;
    [UIView animateWithDuration:.2 animations:^{
        self.backgroundColor = rgba(0, 0, 0, 0.5);
        self.mainView.frame = CGRectMake(0, 0, ScreenWidth, viewHeight);
        [vc.view addSubview:self];
        
        //    [_transparentBtn setNeedsLayout];
        //   [_transparentBtn updateConstraintsIfNeeded];
    }];
    
}

-(void)hideView{
    [UIView animateWithDuration:.2 animations:^{
        self.mainView.frame = CGRectMake(0, -300, ScreenWidth, viewHeight);
    } completion:^(BOOL finished) {
        self.backgroundColor = rgba(0, 0, 0, 0 );
        [self removeFromSuperview];
        self.isShow = NO;
    }];
}

#pragma mark - lazyInit
-(void)setMyOrderPageType:(MyOrderPageType)myOrderPageType{
    _myOrderPageType = myOrderPageType;
    [self initData];
}

-(void)setParamsType:(NSString *)paramsType{
    if([paramsType isEqualToString:LocalizationKey(@"Buy1")]){
        _paramsType = @"0";
    }else if([paramsType isEqualToString:LocalizationKey(@"Sell1")]){
        _paramsType = @"1";
    }else{
        _paramsType = paramsType;
    }
}

-(void)setParamsStatus:(NSString *)paramsStatus{
    if ([paramsStatus isEqualToString:LocalizationKey(@"cancel2")]){
        _paramsStatus = @"-1";
    }else if ([paramsStatus isEqualToString:LocalizationKey(@"Deal done")]){
        _paramsStatus = @"1";
    }else{
        _paramsStatus = paramsStatus;
    }
}

-(UICollectionView *)collectionView{
    if(!_collectionView){
        UICollectionViewFlowLayout *ufl = [[UICollectionViewFlowLayout alloc] init];
        ufl.minimumInteritemSpacing = 10;
        ufl.minimumLineSpacing = 20;
        ufl.headerReferenceSize = CGSizeMake(ScreenWidth-40, 50);
        ufl.itemSize = CGSizeMake((ScreenWidth - 40 - 10*2)/3, 40);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(20, 0, ScreenWidth - 40, viewHeight - 60) collectionViewLayout:ufl];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
    }
    return _collectionView;
}


@end
