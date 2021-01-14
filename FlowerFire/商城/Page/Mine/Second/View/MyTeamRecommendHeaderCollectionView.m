//
//  MyTeamRecommendHeaderCollectionView.m
//  531Mall
//
//  Created by 王涛 on 2020/6/15.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "MyTeamRecommendHeaderCollectionView.h"
 
@interface MyTeamRecommendHeaderCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic, strong)UICollectionView *collectionView;
@end
  
@implementation MyTeamRecommendHeaderCollectionView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = rgba(240, 238, 239, 1);
        
        CGFloat itemWidth = [HelpManager getLabelWidth:13 labelTxt:@"A1"].width + 30 + 21;
        
        UICollectionViewFlowLayout *fl = [[UICollectionViewFlowLayout alloc] init];
        fl.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        fl.minimumLineSpacing = 5;
        fl.minimumInteritemSpacing = 5;
        fl.itemSize = CGSizeMake(itemWidth, 22);
     
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:fl];
        self.collectionView.showsHorizontalScrollIndicator = NO;
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.backgroundColor = self.backgroundColor;
        self.collectionView.contentInset = UIEdgeInsetsMake(0, OverAllLeft_OR_RightSpace, 0, OverAllLeft_OR_RightSpace);
        [self addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left);
            make.top.mas_equalTo(self.mas_top);
            make.size.mas_equalTo(CGSizeMake(ScreenWidth, 40));
        }];
        
       
    }
    return self;
}
  
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    [self.collectionView registerClass:[RecommendHeaderCollectionCell class] forCellWithReuseIdentifier:identifier];
    RecommendHeaderCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if(self.recommendHeaderArray.count>0){
        if(indexPath.row == 0){
            cell.numberLayers.backgroundColor = rgba(255, 221, 148, 1);
        }else{
            cell.numberLayers.backgroundColor = MainColor; 
        }
        cell.numberLayers.text = self.recommendHeaderArray[indexPath.row];
    }
    return cell;
}
 

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.recommendHeaderArray.count;
}

- (void)setRecommendHeaderArray:(NSMutableArray *)recommendHeaderArray{
    _recommendHeaderArray = recommendHeaderArray;
    [self.collectionView reloadData];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row + 1 == self.recommendHeaderArray.count){
        return; //层数没变点击就无效了
    }
    !self.didSwitchLayerClick ? : self.didSwitchLayerClick(indexPath.row+1);
}

@end

@implementation RecommendHeaderCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.numberLayers = [[UILabel alloc] init];
        self.numberLayers.font = tFont(13);
        self.numberLayers.layer.cornerRadius = 11;
        self.numberLayers.layer.masksToBounds = YES;
        self.numberLayers.textColor = KWhiteColor;
        self.numberLayers.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.numberLayers];
        
        self.arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"矩形 11 拷贝"]];
        [self addSubview:_arrow];
        
        CGFloat itemWidth = [HelpManager getLabelWidth:13 labelTxt:@"A1"].width + 30;
        [self.numberLayers mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo( CGSizeMake(itemWidth, 22));
        }];
        
        [self.arrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.numberLayers.mas_centerY);
            make.left.mas_equalTo(self.numberLayers.mas_right).offset(5);
            make.size.mas_equalTo(CGSizeMake(11, 11));
        }];
    }
    return self;
}
 
@end
