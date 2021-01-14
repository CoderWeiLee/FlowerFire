//
//  BDFCustomPhotoAlbum.h
//  SavePhotoDemo
//
//  Created by allison on 2018/8/13.
//  Copyright © 2018年 allison. All rights reserved.
//

 
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
 
NS_ASSUME_NONNULL_BEGIN

@interface BDFCustomPhotoAlbum : NSObject
+ (instancetype)shareInstance;
- (void)saveToNewThumb:(UIImage *)image;
- (void)showAlertMessage:(NSString *)message;
@end


NS_ASSUME_NONNULL_END
