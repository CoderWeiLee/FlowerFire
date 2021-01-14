//
//  FBChooseCoinView.m
//  FlowerFire
//
//  Created by 王涛 on 2020/5/8.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "FBChooseCoinView.h"

@interface FBChooseCoinView ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    
}
@property (nonatomic, copy) void(^block)(NSString*,NSString*);
@property(nonatomic, strong)NSArray  *coinInfoArray;
@property(nonatomic, strong)NSString *currentSelectCoinId;
@end

@implementation FBChooseCoinView

- (instancetype)initWithFrame:(CGRect)frame coinInfoArray:(NSArray *)coinInfoArray currentSelectCoinId:(NSString *)coinId chooseCoinIdBlock:(void (^)(NSString * _Nonnull, NSString * _Nonnull))block{
    self = [self initWithFrame:frame];
       if(self){
           _coinInfoArray = coinInfoArray;
           _currentSelectCoinId = coinId;
           
           [self createUI];
           [self layoutSubview];
           
           self.block = block;
       }
       return self;
}
 

- (void)createUI{
    self.theme_backgroundColor = THEME_MAIN_BACKGROUNDCOLOR;
           
    UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, SafeIS_IPHONE_X, ScreenWidth, 20)];
    la.text = LocalizationKey(@"FBTip5");
    la.theme_textColor = THEME_TEXT_COLOR;
    la.font = tFont(15);
    [self addSubview:la];
    
    UICollectionViewFlowLayout *vl = [[UICollectionViewFlowLayout alloc] init];
    vl.minimumInteritemSpacing = 10;
    vl.itemSize = CGSizeMake(60, 30);
    vl.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, la.ly_maxY + 10, ScreenWidth - OverAllLeft_OR_RightSpace * 2, 30) collectionViewLayout:vl];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = self.backgroundColor;
    [self addSubview:collectionView];
}

- (void)layoutSubview{
    
}

#pragma mark - collectionViewDelegate
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    [collectionView registerClass:[FBChooseCoinCollectionViewCell class] forCellWithReuseIdentifier:identifier];
    FBChooseCoinCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.coinName.text = self.coinInfoArray[indexPath.row][@"symbol"];
    NSString *coinId = NSStringFormat(@"%@",self.coinInfoArray[indexPath.row][@"coin_id"]);
    if([self.currentSelectCoinId isEqualToString:coinId]){
        cell.coinName.textColor = MainColor;
    }else{
        cell.coinName.theme_textColor = THEME_GRAY_TEXTCOLOR;
    }
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.coinInfoArray.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *coinId = NSStringFormat(@"%@",self.coinInfoArray[indexPath.row][@"coin_id"]);
    NSString *coinName = NSStringFormat(@"%@",self.coinInfoArray[indexPath.row][@"symbol"]);
    
    !self.block ? : self.block(coinId,coinName);
}

@end

@implementation FBChooseCoinCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.coinName = [[UILabel alloc] initWithFrame:self.bounds];
        self.coinName.textColor = MainColor;
        self.coinName.font = tFont(14);
        self.coinName.text = @"--";
        [self addSubview:self.coinName];
    }
    return self;
}

@end
