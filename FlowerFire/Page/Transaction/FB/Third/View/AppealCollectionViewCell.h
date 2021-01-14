//
//  editDynamicCollectionViewCell.h
//  yanyu
//
//  Created by mac on 2018/12/17.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AppealCollectionViewCellDelegate <NSObject>
@optional

-(void)delePhoto:(UICollectionViewCell *)Cell; //删除图片

@end



@interface AppealCollectionViewCell : UICollectionViewCell

@property(nonatomic, strong) UIImageView *dynamicImage;
@property(nonatomic, strong) UIImageView *addImage;
@property(nonatomic, strong) UIButton    *deleImage;

 @property(nonatomic,assign) id <AppealCollectionViewCellDelegate> delegate;
@end
