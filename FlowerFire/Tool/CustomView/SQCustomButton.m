//
//  SQCustomButton.m
//  SQCustomButton
//
//  Created by yangsq on 2017/9/12.
//  Copyright © 2017年 yangsq. All rights reserved.
//

#import "SQCustomButton.h"


@interface SQCustomButton ()

@property (nonatomic, strong) UIView *backgroudView;

@end

@implementation SQCustomButton


- (id)initWithFrame:(CGRect)frame type:(SQCustomButtonType)type imageSize:(CGSize)imageSize midmargin:(CGFloat)midmargin{
    if (self = [super initWithFrame:frame]) {
        
        
        UIView *tempView = [UIView new];
        [self addSubview:tempView];
        tempView.translatesAutoresizingMaskIntoConstraints = NO;
        
        _imageView = [UIImageView new];
        [tempView addSubview:_imageView];
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        
        
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        [tempView addSubview:_titleLabel];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        
        _backgroudView = [UIView new];
        _backgroudView.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.3];
        _backgroudView.translatesAutoresizingMaskIntoConstraints = NO;
        _backgroudView.hidden = YES;
        [self addSubview:_backgroudView];
        
        NSLayoutConstraint *bg_top = [NSLayoutConstraint constraintWithItem:_backgroudView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0];
        NSLayoutConstraint *bg_left = [NSLayoutConstraint constraintWithItem:_backgroudView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
        
        NSLayoutConstraint *bg_bottom = [NSLayoutConstraint constraintWithItem:_backgroudView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
        
         NSLayoutConstraint *bg_right = [NSLayoutConstraint constraintWithItem:_backgroudView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0];
        [self addConstraints:@[bg_top,bg_left,bg_bottom,bg_right]];

        NSLayoutConstraint *temp_centerX = [NSLayoutConstraint constraintWithItem:tempView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
        NSLayoutConstraint *temp_centerY = [NSLayoutConstraint constraintWithItem:tempView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    
        [self addConstraints:@[temp_centerX,temp_centerY]];
        
        
        if (type == SQCustomButtonLeftImageType) {
            
            [self removeConstraint:temp_centerY];
            NSLayoutConstraint *temp_top = [NSLayoutConstraint constraintWithItem:tempView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0];
            NSLayoutConstraint *temp_bottom = [NSLayoutConstraint constraintWithItem:tempView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
            [self addConstraints:@[temp_top,temp_bottom]];
            
            NSLayoutConstraint *image_left = [NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:tempView attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
            NSLayoutConstraint *image_width = [NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:imageSize.width];
            NSLayoutConstraint *image_height = [NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:imageSize.height];
            NSLayoutConstraint *image_centerY =  [NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:tempView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
            [_imageView addConstraints:@[image_width,image_height]];
            [tempView addConstraints:@[image_centerY,image_left]];
            
            
            NSLayoutConstraint *label_left = [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_imageView attribute:NSLayoutAttributeRight multiplier:1 constant:midmargin];
          NSLayoutConstraint *label_centerY =  [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:tempView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
            NSLayoutConstraint *label_right = [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:tempView attribute:NSLayoutAttributeRight multiplier:1 constant:0];
            [tempView addConstraints:@[label_left,label_centerY,label_right]];
            
            
        }
        
        if (type == SQCustomButtonTopImageType) {
            
            _titleLabel.textAlignment = NSTextAlignmentCenter;
            
          
            
            NSLayoutConstraint *image_top = [NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:tempView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
              NSLayoutConstraint *image_width = [NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:imageSize.width];
             NSLayoutConstraint *image_height = [NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:imageSize.height];
            NSLayoutConstraint *image_centerX =  [NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:tempView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
            [_imageView addConstraints:@[image_width,image_height]];
            [tempView addConstraints:@[image_centerX,image_top]];
            
            
             NSLayoutConstraint *label_top = [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_imageView attribute:NSLayoutAttributeBottom multiplier:1 constant:midmargin];
             NSLayoutConstraint *label_left = [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:tempView attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
            NSLayoutConstraint *label_right = [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:tempView attribute:NSLayoutAttributeRight multiplier:1 constant:0];
            NSLayoutConstraint *label_bottom = [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:tempView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
            [tempView addConstraints:@[label_top,label_left,label_right,label_bottom]];
            
        }
        
        if (type == SQCustomButtonRightImageType) {
            
            [self removeConstraint:temp_centerY];
            NSLayoutConstraint *temp_top = [NSLayoutConstraint constraintWithItem:tempView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0];
            NSLayoutConstraint *temp_bottom = [NSLayoutConstraint constraintWithItem:tempView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
            [self addConstraints:@[temp_top,temp_bottom]];
            
            NSLayoutConstraint *image_right = [NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:tempView attribute:NSLayoutAttributeRight multiplier:1 constant:0];
            NSLayoutConstraint *image_width = [NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:imageSize.width];
            NSLayoutConstraint *image_height = [NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:imageSize.height];
            NSLayoutConstraint *image_centerY =  [NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:tempView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
            [_imageView addConstraints:@[image_width,image_height]];
            [tempView addConstraints:@[image_centerY,image_right]];
            
            
            NSLayoutConstraint *label_left = [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:tempView attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
            NSLayoutConstraint *label_centerY =  [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:tempView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
            NSLayoutConstraint *label_right = [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_imageView attribute:NSLayoutAttributeLeft multiplier:1 constant:-(midmargin)];
            [tempView addConstraints:@[label_left,label_centerY,label_right]];

            
        }
        
    }
    return self;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.touchBlock) {
        self.touchBlock(self);
    }
    if (self.isShowSelectBackgroudColor) {
        self.backgroudView.hidden = NO;
    }
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.isShowSelectBackgroudColor) {
        self.backgroudView.hidden = YES;
    }
}




- (void)touchAction:(void (^)(SQCustomButton * _Nonnull))block{
    self.touchBlock = block;
}

- (void)setSelecetedImage:(UIImage *)selecetedImage{
    _selecetedImage = selecetedImage;
}

- (void)setNormalImage:(UIImage *)normalImage{
    _normalImage = normalImage;
    self.imageView.image = normalImage;
}

- (void)setSelected:(BOOL)selected{
    _selected = selected;
    if(self.isSelected){
        self.imageView.image = self.selecetedImage;
        self.titleLabel.text = self.selecetdTitleStr;
    }else{
        self.imageView.image = self.normalImage;
        self.titleLabel.text = self.normalTitleStr;
    }
}

- (void)setSelecetdTitleStr:(NSString *)selecetdTitleStr{
    _selecetdTitleStr = selecetdTitleStr;
}

- (void)setNormalTitleStr:(NSString *)normalTitleStr{
    _normalTitleStr = normalTitleStr;
    self.titleLabel.text = normalTitleStr;
}

 

@end
