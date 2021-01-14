//
//  MJCTitlesScollView.m
//  MJCSegmentInterface
//
//  Created by mjc on 16/11/21.
//  Copyright © 2016年 MJC. All rights reserved.
//

#import "MJCTitlesView.h"
#import "UIView+MJCClassExtension.h"
#import "MJCIndicatorView.h"
#import "UIColor+MJCClassExtension.h"
#import "MJCSegmentInterface.h"

#define DELAYTIMES (0.000001)
#define DELAYTIMESTWO (0.1)

static CGFloat const defaultShowCountItem = 4;
static CGFloat const defaultItemFontSize = 14;
static CGFloat const defaultIndicatorH = 1;

@interface MJCTitlesView ()
@property (nonatomic,strong) MJCIndicatorView *indicatorView;
@property (nonatomic, strong) NSMutableArray<MJCTabItem*> *titleButtonsArr;
@property (nonatomic,weak) UIImageView *backgroudView;
@property (nonatomic,weak) MJCTabItem *selectedTitleButton;
@property (nonatomic,weak) MJCTabItem *tabItem;
@property (nonatomic,assign) BOOL zoomBigEnabled;
@property (nonatomic,assign) CGFloat tabItemTitleMaxfont;
@property (nonatomic,assign) BOOL isLoadIndicatorFrame;
@property (nonatomic,weak) MJCTabItem *oldsSelectedItem;
@property (nonatomic,weak) MJCTabItem *newsSelectedItem;
@property (nonatomic,weak) NSArray *normalColorRgbaArr;
@property (nonatomic,weak) NSArray *selectedColorRgbaArr;
@property (nonatomic,weak) NSArray *gradientRgbaArr;
@property (nonatomic,assign) NSInteger selectedTag;
@property (nonatomic,assign) BOOL sizeToFitIsEnabled;
@property (nonatomic,assign) BOOL heightToFitIsEnabled;
@property (nonatomic,assign) BOOL widthToFitIsEnabled;

@property (nonatomic,assign) CGFloat tabItemW;
@property (nonatomic,assign) CGFloat itemNewX;
@property (nonatomic,assign)CGFloat maxTopMargin;
@property (nonatomic,assign)CGFloat maxBottomMargin;
@property (nonatomic,assign)CGFloat maxleftMargin;
@property (nonatomic,assign)CGFloat maxRightMargin;
@property (nonatomic,assign)CGFloat lineMargin;

@end

@implementation MJCTitlesView

- (NSMutableArray *)titleButtonsArr
{
    if (!_titleButtonsArr) {
        _titleButtonsArr = [NSMutableArray array];
    }
    return _titleButtonsArr;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupBasic];
    }
    return self;
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setupBasic];
}
-(void)setupBasic
{
    _indicatorView = [MJCIndicatorView buttonWithType:UIButtonTypeCustom];
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.backgroundColor = [UIColor whiteColor];
    UIImageView *backgroudView = [[UIImageView alloc]init];
    [self addSubview:backgroudView];
    _backgroudView = backgroudView;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    _backgroudView.frame = self.bounds;
}

-(void)setDefaultSelectedIndex:(NSInteger)defaultSelectedIndex
{
    _defaultSelectedIndex = defaultSelectedIndex;    
    if (defaultSelectedIndex >= _titlesArray.count) {
        MJCTabItem *titlesButton = _titleButtonsArr[0];
        [self defaultSelectedItemClick:titlesButton];
        return;
    }
    MJCTabItem *titlesButton = _titleButtonsArr[defaultSelectedIndex];
    [self defaultSelectedItemClick:titlesButton];

}

-(void)defaultSelectedItemClick:(MJCTabItem *)selectedTitleButton
{
    [self setupClickAndScrollEndWith:selectedTitleButton isIndicatorsAnimals:NO];
    if (_defaultSelectedItemBlock) {
        _defaultSelectedItemBlock(_selectedTitleButton);
    }
}

-(void)setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex
{
    _selectedSegmentIndex = selectedSegmentIndex;
    
    if (selectedSegmentIndex >= _titlesArray.count) {
        MJCTabItem *titlesButton = _titleButtonsArr[0];
        [self selectedItemClick:titlesButton];
        return;
    }
    MJCTabItem *titlesButton = _titleButtonsArr[selectedSegmentIndex];
    [self selectedItemClick:titlesButton];    
}

-(void)selectedItemClick:(MJCTabItem *)selectedTitleButton
{
    [self setupClickAndScrollEndWith:selectedTitleButton isIndicatorsAnimals:_isIndicatorsAnimals];
    if (_selectedItemClickBlock) {
        _selectedItemClickBlock(_selectedTitleButton);
    }
}

-(void)setItemEdgeinsets:(MJCItemEdgeInsets)itemEdgeinsets
{
    _itemEdgeinsets = itemEdgeinsets;
    _maxTopMargin = itemEdgeinsets.maxTop;
    _maxBottomMargin = itemEdgeinsets.maxBottom;
    _maxleftMargin = itemEdgeinsets.maxLeft;
    _maxRightMargin = itemEdgeinsets.maxRight;
    _lineMargin = itemEdgeinsets.lineMargin;
}

-(void)setTitlesArray:(NSArray *)titlesArray
{
    _titlesArray = titlesArray;
    
    CGFloat tabItemW;
    if (_titlesBarStyles == MJCTitlesScrollStyle ) {
        if (_defaultShowItemCount) {
            if (_defaultShowItemCount > titlesArray.count) {
                if (titlesArray.count < defaultShowCountItem) {
                    tabItemW = self.jc_width/titlesArray.count;
                }else{
                    tabItemW = self.jc_width/defaultShowCountItem;
                }
            }else{
                tabItemW = self.jc_width/_defaultShowItemCount;
            }
        }else{
            if (_titlesArray.count <= defaultShowCountItem) {
                tabItemW = self.jc_width/_titlesArray.count;
            }else{
                tabItemW = self.jc_width/defaultShowCountItem;
            }
        }
    }else{
        tabItemW = self.jc_width/titlesArray.count;
    }
    _tabItemW = tabItemW;
    CGFloat tabItemH = self.jc_height;
    for (NSUInteger i = 0 ; i < titlesArray.count; i++) {
        MJCTabItem *tabbutton = [MJCTabItem buttonWithType:UIButtonTypeCustom];
        tabbutton.scaleLayoutEnabled = _scaleLayoutEnabled;
        tabbutton.tag = i;
        [self setupButton:tabbutton];
        if (_titlesBarStyles == 0) {
            NSInteger  maxCount = titlesArray.count;
            NSInteger loc = i % maxCount;
            CGFloat itemW = (self.jc_width  - _maxleftMargin - _maxRightMargin - (titlesArray.count - 1)*_lineMargin) / titlesArray.count;
            CGFloat x = _maxleftMargin + (_lineMargin +itemW) * loc;
            CGFloat tabY = _maxTopMargin;
            CGFloat tabH = tabItemH - _maxBottomMargin - _maxTopMargin;
            tabbutton.frame = CGRectMake(x,tabY,itemW,tabH);
        }else{
            if (_sizeToFitIsEnabled && (_heightToFitIsEnabled || _widthToFitIsEnabled)) {
                [tabbutton sizeToFit];
                CGFloat tabX = 0;CGFloat tabH = 0;CGFloat tabY = 0;
                if (_widthToFitIsEnabled) {
                    tabX =  _itemNewX + _maxleftMargin;
                    tabbutton.jc_width = tabbutton.jc_width + _tabItemExcessSize.width;
                    _itemNewX +=   tabbutton.jc_width + _lineMargin;
                }else{
                    tabX =  tabItemW * i + _maxleftMargin;
                    tabbutton.jc_width = tabItemW - _lineMargin;
                }
                if (_heightToFitIsEnabled) {
                    tabH = tabbutton.jc_height + _tabItemExcessSize.height;
//                    tabH = tabbutton.itemHeight + _tabItemExcessSize.height;
                }else{
                    tabY = _maxTopMargin;
                    tabH = tabItemH - _maxBottomMargin - _maxTopMargin;
                }
                [tabbutton setupItemFrameTabX:tabX tabY:tabY tabH:tabH];
                tabbutton.jc_centerY = self.jc_centerY;
            }else{
                CGFloat tabX = tabItemW * i + _maxleftMargin;
                CGFloat tabY = _maxTopMargin;
                CGFloat tabH = tabItemH - _maxBottomMargin - _maxTopMargin;
                tabbutton.frame = CGRectMake(tabX,tabY, tabItemW - _lineMargin,tabH);
            }
        }
        [tabbutton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:tabbutton];
        [self.titleButtonsArr addObject:tabbutton];
    }
    
    
    if (_titlesBarStyles == 0) {
        self.contentSize = CGSizeMake(titlesArray.count * tabItemW,0);
    }else{
        if (_scaleLayoutEnabled) {
            if (_sizeToFitIsEnabled && _widthToFitIsEnabled) {
                if ([MJCCommontools isIphonePlusBounds]) { //plus适配
                    self.contentSize = CGSizeMake(_itemNewX * plusScalsW + _maxRightMargin + _maxleftMargin - _lineMargin,0);
                }else if ([MJCCommontools isIphoneSEBounds]){ //5的适配
                    self.contentSize = CGSizeMake(_itemNewX * i5scalsW + _maxRightMargin + _maxleftMargin - _lineMargin,0);
                }else{
                    self.contentSize = CGSizeMake(_itemNewX + _maxRightMargin + _maxleftMargin - _lineMargin,0);
                }
            }else{
                self.contentSize = CGSizeMake(titlesArray.count * tabItemW + _maxRightMargin + _maxleftMargin - _lineMargin,0);
            }
        }else{
            if (_sizeToFitIsEnabled && _widthToFitIsEnabled) {
                self.contentSize = CGSizeMake(_itemNewX + _maxRightMargin + _maxleftMargin - _lineMargin,0);
            }else{
                self.contentSize = CGSizeMake(titlesArray.count * tabItemW + _maxRightMargin + _maxleftMargin - _lineMargin,0);
            }
        }
    }
    
    [self addSubview:_indicatorView];
    
    
    if (_tabItemArrBlock) {
        _tabItemArrBlock(_titleButtonsArr);
    };

    
}


-(void)setupButton:(MJCTabItem *)tabbutton
{
    if (!_isItemTitleTextHidden) {
        tabbutton.itemText = _titlesArray[tabbutton.tag];
    }
    tabbutton.backgroundColor = _itemBackColor;
    tabbutton.itemBackColorSelected = _itemBackColorSelected;
    tabbutton.itemImageSize = _itemImageSize;
    tabbutton.itemTextFontSize = _itemTextFontSize;
    tabbutton.itemTitleNormalColor = _itemTextNormalColor;
    tabbutton.itemTitleSelectedColor = _itemTextSelectedColor;
    tabbutton.itemBackNormalImage = _itemBackNormalImage;
    tabbutton.itemBackSelectedImage = _itemBackSelectedImage;
    tabbutton.itemNormalBackImageArray = _itemNormalBackImageArray;
    tabbutton.itemSelectedBackImageArray = _itemSelectedBackImageArray;
    tabbutton.itemImageNormal = _itemImageNormal;
    tabbutton.tabItemImageSelected = _itemImageSelected;
    tabbutton.tabItemNormalImageArray = _itemImageNormalArray;
    tabbutton.tabItemSelectedImageArray = _itemImageSelectedArray;
    tabbutton.imageEffectStyles = _imageEffectStyles;
    tabbutton.itemTextsEdgeInsets = _itemTextsEdgeInsets;
    tabbutton.itemImagesEdgeInsets = _itemImagesEdgeInsets;
    tabbutton.itemTitleNormalColorArray = _itemTitleNormalColorArray;
    tabbutton.itemTitleSelectedColorArray = _itemTitleSelectedColorArray;
}

- (void)titleClick:(MJCTabItem *)titleButton
{
    [self setupClickAndScrollEndWith:titleButton isIndicatorsAnimals:_isIndicatorsAnimals];
    
    if (_tabItemClickBlock) {
        _tabItemClickBlock(_selectedTitleButton);
    }
}

- (void)setupTitleCenter:(UIButton *)titleButton
{
    CGFloat offsetX = titleButton.center.x - self.frame.size.width * 0.5;
    if (offsetX < 0) {
        offsetX = 0;
    }
    CGFloat maxOffsetX = self.contentSize.width - self.frame.size.width;
    //    CGFloat maxOffsetX = self.titlesScrollView.contentSize.width - MJCScreenWidth + _titleCenterMargin;
    if (offsetX > maxOffsetX) {
        offsetX = maxOffsetX;
    }
    [self setContentOffset: CGPointMake(offsetX, 0) animated:YES];
}
- (NSArray *)gradientRgbaArr
{
    if (!_gradientRgbaArr) {
        NSArray *gradientRgbaArr = [UIColor jc_gradientRGBAWith:self.normalColorRgbaArr selectedColorRGBA:self.selectedColorRgbaArr];
        _gradientRgbaArr = gradientRgbaArr;
    }
    return _gradientRgbaArr;
}
- (NSArray *)normalColorRgbaArr
{
    if (!_normalColorRgbaArr) {
        if (!_itemTextNormalColor) {
            _itemTextNormalColor = [UIColor grayColor];
        }
        NSArray *normalColorRgbaArr = [UIColor jc_getNeedColorRgbaArr:_itemTextNormalColor];
        _normalColorRgbaArr = normalColorRgbaArr;
    }
    return  _normalColorRgbaArr;
}
- (NSArray *)selectedColorRgbaArr
{
    if (!_selectedColorRgbaArr) {
        if (!_itemTextSelectedColor) {
            _itemTextSelectedColor = [UIColor blackColor];
        }
        NSArray *selectedColorRgbaArr = [UIColor jc_getNeedColorRgbaArr:_itemTextSelectedColor];
        _selectedColorRgbaArr = selectedColorRgbaArr;
    }
    return  _selectedColorRgbaArr;
}
-(void)jc_scrollViewDidScroll:(UIScrollView *)scrollView isIndicatorFollow:(BOOL)isIndicatorFollow
{
    if (_isIndicatorFollow == YES) {
        CGFloat value = scrollView.contentOffset.x / scrollView.frame.size.width;
        if (value >= _titlesArray.count - 1) return;
        if (value <= 0) return;
        CGFloat scaleRight = 0;
        CGFloat scaleLeft = 0;
        NSUInteger leftIndex = (int)value;
        NSUInteger rightIndex = leftIndex + 1;
        scaleRight = value - leftIndex;
        scaleLeft  = 1 - scaleRight;
        if (scaleLeft == 1 && scaleRight == 0)return;
        MJCTabItem *rightItem;
        MJCTabItem *leftItem = _titleButtonsArr[leftIndex];
        if (rightIndex < _titlesArray.count) {
            rightItem = _titleButtonsArr[rightIndex];
        }
        _indicatorView.jc_centerX = leftItem.jc_centerX + (rightItem.jc_centerX - leftItem.jc_centerX) * scaleRight;
    }
    if (_isFontGradient && _isItemTitleTextHidden == NO && _itemTitleNormalColorArray.count == 0 && _itemTitleSelectedColorArray.count == 0) {
        CGFloat value = scrollView.contentOffset.x / scrollView.frame.size.width;
        if (value >= _titlesArray.count - 1) return;
        if (value <= 0) return;
        CGFloat scaleRight = 0;
      //  CGFloat scaleLeft = 0;
        NSUInteger leftIndex = (int)value;
        NSUInteger rightIndex = leftIndex + 1;
        scaleRight = value - leftIndex;
      //  scaleLeft  = 1 - scaleRight;
        MJCTabItem *rightItem;
        MJCTabItem *leftItem = _titleButtonsArr[leftIndex];
        if (rightIndex < _titlesArray.count) {
            rightItem = _titleButtonsArr[rightIndex];
        }
        [self setupGramientWithValueTag:value leftItem:leftItem rightItem:rightItem scaleRight:scaleRight];
    }
}

-(void)setupGramientWithValueTag:(NSInteger)value leftItem:(MJCTabItem*)leftItem rightItem:(MJCTabItem*)rightItem scaleRight:(CGFloat)scaleRight
{
    if (value > _selectedTag || value == _selectedTag) {
        leftItem.itemTitleSelectedColor = [UIColor oldColorWithSelectedColorRGBA:self.selectedColorRgbaArr deltaRGBA:self.gradientRgbaArr scale:scaleRight];
        _oldsSelectedItem =  leftItem;
        rightItem.itemTitleNormalColor = [UIColor newColorWithNormalColorRGBARGBA:self.normalColorRgbaArr deltaRGBA:self.gradientRgbaArr scale:scaleRight];
        _newsSelectedItem = rightItem;
    }else{
        leftItem.itemTitleNormalColor = [UIColor oldColorWithSelectedColorRGBA:self.selectedColorRgbaArr deltaRGBA:self.gradientRgbaArr scale:scaleRight];
        _newsSelectedItem = leftItem;
        rightItem.itemTitleSelectedColor = [UIColor newColorWithNormalColorRGBARGBA:self.normalColorRgbaArr deltaRGBA:self.gradientRgbaArr scale:scaleRight];
        _oldsSelectedItem =  rightItem;
    }
}
- (void)jc_scrollViewDidEndDragging:(UIScrollView *)scrollView itemTextNormalColor:(UIColor *)itemTextNormalColor
{
    _oldsSelectedItem.itemTitleNormalColor = itemTextNormalColor;
}
- (void)jc_scrollViewWillEndDragging:(UIScrollView *)scrollView itemTextNormalColor:(UIColor *)itemTextNormalColor
{
    _oldsSelectedItem.itemTitleNormalColor = itemTextNormalColor;
}
- (void)jc_scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSUInteger index = scrollView.contentOffset.x / scrollView.jc_width;
    MJCTabItem *titleButton = _titleButtonsArr[index];
    [self setupClickAndScrollEndWith:titleButton isIndicatorsAnimals:_isIndicatorsAnimals];
    //    [self titleClick:titleButton];
    if (_itemTitleSelectedColorArray.count == 0 && _itemTitleNormalColorArray.count == 0) {
        [_titleButtonsArr enumerateObjectsUsingBlock:^(MJCTabItem*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.itemTitleNormalColor = _itemTextNormalColor;
        }];
    }
    if (_scrollDidEndBlock) {
        _scrollDidEndBlock(titleButton);
    }
}

-(void)setupClickAndScrollEndWith:(MJCTabItem *)titleButton isIndicatorsAnimals:(BOOL)isIndicatorsAnimals
{
    _selectedTag = titleButton.tag;
    
    
    if (_titlesArray.count >=3 &&  self.contentSize.width > self.frame.size.width) {
        [self setupTitleCenter:titleButton];
    }
    if (titleButton == _selectedTitleButton){
        _selectedTitleButton.selected = YES;
        return;
    };
    
    
    if (_itemTextFontSize) {
        _selectedTitleButton.itemTextFontSize = _itemTextFontSize;
    }else{
        _selectedTitleButton.itemTextFontSize = defaultItemFontSize;
    }
    
    if (_selectedTitleButton) {
        _selectedTitleButton.selected = NO;
        if (_tabItemClickCancelBlock) {
            _tabItemClickCancelBlock(_selectedTitleButton);
        }
    }
    
    titleButton.selected = YES;
    if (_itemTitleSelectedColorArray.count == 0 && _itemTitleNormalColorArray.count == 0) {
        titleButton.itemTitleSelectedColor = _itemTextSelectedColor;
    }
    if (_isIndicatorColorEqualTextColor) {
        _indicatorView.backgroundColor = titleButton.titleLabel.textColor;
    }
    
    if (_zoomBigEnabled) {
        titleButton.itemTextFontSize = _tabItemTitleMaxfont;
    }
    _selectedTitleButton = titleButton;
    
    if ((_titlesBarStyles == 1 && _zoomBigEnabled && _sizeToFitIsEnabled) && ( _widthToFitIsEnabled || _heightToFitIsEnabled)) {
        _itemNewX = 0;
        CGFloat tabItemH = self.jc_height;
        [_titleButtonsArr enumerateObjectsUsingBlock:^(MJCTabItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (_sizeToFitIsEnabled) {
                [obj sizeToFit];
                CGFloat tabX = 0;CGFloat tabH = 0;CGFloat tabY = 0;
                if (_widthToFitIsEnabled) {
                    tabX =  _itemNewX + _maxleftMargin;
                    obj.jc_width = obj.jc_width + _tabItemExcessSize.width;
                    _itemNewX +=   obj.jc_width + _lineMargin;
                }else{
                    tabX =  _tabItemW * obj.tag + _maxleftMargin;
                    obj.jc_width = _tabItemW - _lineMargin;
                }
                if (_heightToFitIsEnabled) {
                    tabH = obj.jc_height+_tabItemExcessSize.height;
//                    tabH = obj.itemHeight+_tabItemExcessSize.height;
                }else{
                    tabY = _maxTopMargin;
                    tabH= tabItemH - _maxBottomMargin - _maxTopMargin;
                }
                [obj setupItemFrameTabX:tabX tabY:tabY tabH:tabH];
                obj.jc_centerY = self.jc_centerY;
            }else{
                CGFloat tabX = _tabItemW * obj.tag + _maxleftMargin;
                CGFloat tabY = _maxTopMargin;
                CGFloat tabH = tabItemH - _maxBottomMargin - _maxTopMargin;
                obj.frame = CGRectMake(tabX,tabY,_tabItemW - _lineMargin,tabH);
            }
            if (idx == _titlesArray.count - 1) {
                CGFloat maxX = CGRectGetMaxX(obj.frame);
                self.contentSize = CGSizeMake(maxX + _maxRightMargin,0);
                if (_titlesArray.count >=3 &&  self.contentSize.width > self.frame.size.width) {
                    [self setupTitleCenter:titleButton];
                }
            }
            if (_heightToFitIsEnabled != 0) {
                obj.jc_centerY = self.jc_centerY;
            }
        }];
    }
    
    [self setupIndicatorViewCenterAndWidthWith:isIndicatorsAnimals];
    
    if (_itemTextBoldFontSizeSelected) {
        titleButton.titleLabel.font  = [UIFont fontWithName:@"Helvetica-Bold" size:_itemTextBoldFontSizeSelected];
    }
    
}

-(void)setupIndicatorViewCenterAndWidthWith:(BOOL)isIndicatorsAnimals
{
    [_indicatorView setupIndicatorViewCenterAndWidthIsAnimal:isIndicatorsAnimals indicatorStyles:_indicatorStyles selectedTitleButton:_selectedTitleButton indicatorFrame:_indicatorFrame];
}

-(void)scrollDidEndBlock:(ScrollDidEndBlock)scrollDidEndBlock
{
    _scrollDidEndBlock = scrollDidEndBlock;
}

-(void)setBackgroudImage:(UIImage *)backgroudImage
{
    _backgroudImage = backgroudImage;
    _backgroudView.image = backgroudImage;
}
-(void)setTitlesViewBackColor:(UIColor *)titlesViewBackColor
{
    _titlesViewBackColor = titlesViewBackColor;
    self.backgroundColor = titlesViewBackColor;
}
-(void)setIndicatorFrame:(CGRect)indicatorFrame
{
    _indicatorFrame = indicatorFrame;
    if (indicatorFrame.size.height == 0 && indicatorFrame.size.width == 0 && indicatorFrame.origin.x == 0 && indicatorFrame.origin.y == 0) {
        if (_indicatorImage) {
            _indicatorView.jc_y = self.frame.size.height - _indicatorImage.size.height;
            _indicatorView.jc_height = _indicatorImage.size.height;
        }else{
            _indicatorView.jc_y = self.frame.size.height - defaultIndicatorH;
            _indicatorView.jc_height = defaultIndicatorH;
        }
    }else{
        _indicatorView.frame = indicatorFrame;
    }
}

-(void)setIndicatorColor:(UIColor *)indicatorColor
{
    _indicatorColor = indicatorColor;
    if (indicatorColor) {
        _indicatorView.backgroundColor  = indicatorColor;
    }else{
        _indicatorView.backgroundColor  = [UIColor blackColor];
    }
}

-(void)setIndicatorImage:(UIImage *)indicatorImage
{
    _indicatorImage = indicatorImage;
    _indicatorView.indicatorImage = indicatorImage;
    if (_indicatorFrame.size.height == 0 && _indicatorFrame.size.width == 0 && _indicatorFrame.origin.x == 0 && _indicatorFrame.origin.y == 0) {
        _indicatorView.jc_y = self.frame.size.height - indicatorImage.size.height;
        _indicatorView.jc_height = indicatorImage.size.height;
    }else{
        _indicatorView.frame = _indicatorFrame;
    }
}
-(void)setIndicatorHidden:(BOOL)indicatorHidden
{
    _indicatorHidden = indicatorHidden;
    _indicatorView.hidden = indicatorHidden;
}
-(void)tabItemTitlezoomBigEnabled:(BOOL)zoomBigEnabled tabItemTitleMaxfont:(CGFloat)tabItemTitleMaxfont
{
    _zoomBigEnabled = zoomBigEnabled;
    _tabItemTitleMaxfont = tabItemTitleMaxfont;
}
-(void)tabItemSizeToFitIsEnabled:(BOOL)sizeToFitIsEnabled itemHeightToFitIsEnabled:(BOOL)heightToFitIsEnabled itemWidthToFitIsEnabled:(BOOL)widthToFitIsEnabled;
{
    _sizeToFitIsEnabled = sizeToFitIsEnabled;
    _heightToFitIsEnabled = heightToFitIsEnabled;
    _widthToFitIsEnabled = widthToFitIsEnabled;
}

-(void)removeFromSuperview
{
    [super removeFromSuperview];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

@end
