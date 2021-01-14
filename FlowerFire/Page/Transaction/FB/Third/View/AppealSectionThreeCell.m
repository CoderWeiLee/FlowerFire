//
//  AppealSectionThreeCell.m
//  FireCoin
//
//  Created by 王涛 on 2019/6/4.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "AppealSectionThreeCell.h"
#import "TZImagePickerController.h"
#import "AppealCollectionViewCell.h"
#import "YYPhotoGroupView.h"

@interface AppealSectionThreeCell ()<AFNetworkDelege,UIImagePickerControllerDelegate,UICollectionViewDelegate,TZImagePickerControllerDelegate,UICollectionViewDataSource,AppealCollectionViewCellDelegate>
{
    UICollectionViewFlowLayout *layout;
    NSIndexPath *deleIndex;
    NSInteger    seleCount;
    
}
@property (nonatomic, strong) AFNetworkClass   *afnetWork;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation AppealSectionThreeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if(self){
        //self.backgroundColor = navBarColor;
        [self setTheme_backgroundColor:THEME_CELL_BACKGROUNDCOLOR];
        UIView *line = [[UIView alloc] init];
        line.theme_backgroundColor = THEME_TABBAR_BACKGROUNDCOLOR;
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top);
            make.left.mas_equalTo(self.mas_left);
            make.size.mas_equalTo(CGSizeMake(ScreenWidth, 5));
        }];
        
        UILabel *tip = [UILabel new];
        tip.textColor = rgba(149, 158, 188, 1);
        
        tip.font = [UIFont boldSystemFontOfSize:18];
        [self addSubview:tip];
        [tip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(line.mas_bottom).offset(15);
            make.left.mas_equalTo(self.mas_left).offset(OverAllLeft_OR_RightSpace);
            
        }];
        
        if(self.isJumpDetails){
            tip.text = LocalizationKey(@"AppealTip5");
        }else{
            tip.text = LocalizationKey(@"AppealTip6");
        }
        
        layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(20, 51, ScreenWidth - 40, ScreenWidth - 20) collectionViewLayout:layout];
        _collectionView.showsVerticalScrollIndicator = NO;
        //_collectionView.backgroundColor = navBarColor;
        [_collectionView setTheme_backgroundColor:THEME_CELL_BACKGROUNDCOLOR];
        [_collectionView registerClass:[AppealCollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
     
        //4.设置代理
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [self addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(tip.mas_bottom).offset(10);
            make.left.mas_equalTo(self.mas_left).offset(OverAllLeft_OR_RightSpace);
            make.width.mas_equalTo(ScreenWidth - 30);
            make.height.mas_equalTo(ScreenWidth-30 - 15);
            make.bottom.mas_equalTo(self.mas_bottom).offset(-20);
        }];
        
        self.photosArray = [NSMutableArray array];
    }
    return self;
}
 
#pragma mark - UIImagePickerController
- (void)showUIImagePickerController{
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:(9-seleCount) delegate:self];
    
    if([[SDThemeManager sharedInstance].themeName isEqualToString:WHITE_THEME]){
        imagePicker.naviTitleColor = MainColor;
        imagePicker.barItemTextColor = MainColor;
        imagePicker.statusBarStyle = UIStatusBarStyleDefault;
    }else{
        imagePicker.naviTitleColor = KWhiteColor;
        imagePicker.barItemTextColor = KWhiteColor;
        imagePicker.statusBarStyle = UIStatusBarStyleLightContent;
    }
    
    
    // 是否显示可选原图按钮
    imagePicker.allowPickingOriginalPhoto = NO;
    // 是否允许显示视频
    imagePicker.allowPickingVideo = NO;
    // 是否允许显示图片
    imagePicker.allowPickingImage = YES;
    imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
    // 这是一个navigation 只能present
    [[self viewController] presentViewController:imagePicker animated:YES completion:nil];
    
}

// 选择照片的回调
-(void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    
    for(int i = 0 ;i<photos.count;i++){
        UIImage *image = photos[i];
    
        NSData *scaleImgData=[[ HelpManager sharedHelpManager]imageWithImageSimple:image];
        [self.afnetWork uploadDataPost:scaleImgData parameters:nil urlString:@"" LoadingInView:[self viewController].view]; 
    }
}

//网络上传图片
-(void)getHttpData:(NSDictionary *)dict response:(Response)flag{
    [MBManager hideAlert];
    if(flag == Success){
        if([dict[@"code"] integerValue] == 1){
            NSString *restr = [NSString stringWithFormat:@"%@",dict[@"data"][@"url"]]  ;
            NSLog(@"++++++++++++%@",restr);
            if(self.photosArray.count >=9 ){
                return;
            }
            seleCount++;
            [self.photosArray addObject:restr];
            [self.collectionView reloadData];
        }else{
            NSString *msg = [NSString stringWithFormat:@"%@",dict[@"msg"]];
            printAlert(msg, 1.f);
         }
    }else{
        printAlert(LocalizationKey(@"upload failed"), 1.f);
    }
}

#pragma mark - collectionViewdegeta

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(self.isJumpDetails){
        return self.photosArray.count;
    }
    return self.photosArray.count+1;
}
#pragma mark  设置CollectionView所展示出来的cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
        AppealCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
        //最后一条不出现删除按钮
        if(indexPath.row == self.photosArray.count){
            cell.dynamicImage.image = [UIImage imageNamed:@"content_icon_tianjia-1"];
            cell.deleImage.hidden = YES;
        }else{
            cell.deleImage.hidden = NO;
            NSString *imgUrlStr = [NSString stringWithFormat:@"%@",self.photosArray[indexPath.row]];
            if(![imgUrlStr containsString:BASE_URL]){
                imgUrlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,imgUrlStr];
            }
            [cell.dynamicImage sd_setImageWithURL:[NSURL URLWithString:imgUrlStr]  placeholderImage:[UIImage imageNamed:@"placeholder"]];
        }
        //第9图后不让再添加
        if(indexPath.row == 9){
            cell.dynamicImage.hidden = YES;
        }else{
            cell.dynamicImage.hidden = NO;
        }
        if(!self.isJumpDetails){
             cell.delegate = self;
        }else{
            cell.deleImage.hidden = YES;
        }
    
        return cell;
}


#pragma mark  点击CollectionView触发事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
        if(self.isJumpDetails){
            UIView *fromView = nil;
            
            AppealCollectionViewCell * cell = (AppealCollectionViewCell *)[self collectionView:collectionView cellForItemAtIndexPath:indexPath];
            //查看图片集
            NSMutableArray * items = [NSMutableArray array];
            for (int i = 0; i < self.photosArray.count; i++) {
                UIView * imgView = cell.dynamicImage;
                YYPhotoGroupItem * item = [YYPhotoGroupItem new];
                item.thumbView = imgView;
                item.largeImageURL = [NSURL URLWithString:self.photosArray[i]];
                [items addObject:item];
                fromView = imgView;
            }
            YYPhotoGroupView *v = [[YYPhotoGroupView alloc] initWithGroupItems:items];
            [v presentFromImageView:fromView toContainer:[self viewController].view animated:YES completion:nil];
            return;
        }
        if(indexPath.row == 9){
            return;
        }
        
        if(indexPath.row == self.photosArray.count){
            [self showUIImagePickerController];
        }else{
            UIView *fromView = nil;
            
            AppealCollectionViewCell * cell = (AppealCollectionViewCell *)[self collectionView:collectionView cellForItemAtIndexPath:indexPath];
            //查看图片集
            NSMutableArray * items = [NSMutableArray array];
            for (int i = 0; i < self.photosArray.count; i++) {
                UIView * imgView = cell.dynamicImage;
                YYPhotoGroupItem * item = [YYPhotoGroupItem new];
                item.thumbView = imgView;
                item.largeImageURL = [NSURL URLWithString:self.photosArray[i]];
                [items addObject:item];
                fromView = imgView;
            }
            
            YYPhotoGroupView *v = [[YYPhotoGroupView alloc] initWithGroupItems:items];
            // v.superView = self.v;
            [v presentFromImageView:fromView toContainer:[self viewController].view animated:YES completion:nil];
        }
    
}
#pragma mark headView大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeZero;
}

// 设置区尾尺寸高度
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeZero;
}


//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
   return CGSizeMake((ScreenWidth-40 - 15) /3, (ScreenWidth-40 - 15) /3); 
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
  
        return 5;
  
}


//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
        return 5;
}
#pragma mark - cellDelegate
-(void)delePhoto:(UICollectionViewCell *)Cell{
    deleIndex =  [_collectionView indexPathForCell:Cell];
    seleCount--;
    [self.photosArray removeObjectAtIndex:deleIndex.row];
    [_collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:deleIndex]];
    //   [_collectionView reloadData];
}

#pragma mark - lazyInit
-(AFNetworkClass *)afnetWork{
    if(!_afnetWork){
        _afnetWork = [AFNetworkClass new];
        _afnetWork.delegate = self;
    }
    return _afnetWork;
}

@end
