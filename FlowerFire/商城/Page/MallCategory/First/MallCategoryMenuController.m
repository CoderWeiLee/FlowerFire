//
//  MallCategoryMenuController.m
//  MallCategory
//
//  Created by mengxiang on 2019/11/21.
//

#import "MallCategoryMenuController.h"
#import "MallCategoryParams.h"
#import "GradientView.h"

#define kAdjustsScrollViewInsetNever(controller,view) if(@available(iOS 11.0, *)) {view.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;} else if([controller isKindOfClass:[UIViewController class]]) {controller.automaticallyAdjustsScrollViewInsets = false;}
#define kTableViewEstimateHeight(view)  if(@available(iOS 11.0, *)) {view.estimatedRowHeight = 0;view.estimatedSectionFooterHeight = 0;view.estimatedSectionHeaderHeight = 0;}

@interface MallCategoryMenuController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSIndexPath * selectedIndexPath;
@end

@implementation MallCategoryMenuController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 返回本页面时，重新选中原来的选项
    //    [self.tableView selectRowAtIndexPath:_selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = KWhiteColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.bounces = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        kTableViewEstimateHeight(_tableView);
        kAdjustsScrollViewInsetNever(self, _tableView);
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KWhiteColor;
    [self.view addSubview:self.tableView];
    [self.tableView setFrame:CGRectMake(0, 0, CATEGORYMENU_WIDTH, ScreenHeight - Height_NavBar - Height_TabBar)];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(willDislayHeaderView:)
                                                name:MALL_CATEGORY_DETAIL_WILLDISPLAY_HEADER
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(didEndDislayHeaderView:)
                                                name:MALL_CATEGORY_DETAIL_DIDENDDISPLAY_HEADER
                                              object:nil];
    
    
}



- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)willDislayHeaderView:(NSNotification *)noti{
    NSIndexPath * indexPath  = noti.object;
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.section inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}

- (void)didEndDislayHeaderView:(NSNotification *)noti{
    NSIndexPath * indexPath  = noti.object;
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.section+1 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}

#pragma mark - 懒加载
//- (NSMutableArray *)categoryList{
//    if (!_categoryList) {
//        _categoryList = [NSMutableArray array];
//
//    }
//    return _categoryList;
//}

- (void)setCategoryList:(NSMutableArray *)categoryList{
    _categoryList = categoryList;
    [self.tableView reloadData];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        // 选中第一个
        [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                    animated:NO
                              scrollPosition:UITableViewScrollPositionNone];
    });
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CATEGORYMENU_CELL_H;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.categoryList.count;
}


- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.selectedIndexPath isEqual:indexPath]) {
        return;
    }
    self.selectedIndexPath = indexPath;
    [tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:MALL_CATEGORY_MENU_DIDSELECTROWATINDEXPATH object:indexPath];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseID = @"MallCategoryMenuCell";
    MallCategoryMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[MallCategoryMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    if(self.categoryList.count >0){
        cell.categoryTitleLabel.text = self.categoryList[indexPath.row][@"name"];
    }
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end



@interface MallCategoryMenuCell()

@property (nonatomic, strong) UIView * blockView;
@property (nonatomic, strong) GradientView * whiteBgView;

@end

@implementation MallCategoryMenuCell

- (UILabel *)categoryTitleLabel{
    if (!_categoryTitleLabel) {
        _categoryTitleLabel = [[UILabel alloc]init];
        _categoryTitleLabel.textAlignment = NSTextAlignmentCenter;
        _categoryTitleLabel.text = @"Fattuned";
        _categoryTitleLabel.font = [UIFont fontWithName:(@"Arial-BoldMT") size:(13)];
    }
    return _categoryTitleLabel;
}

- (UIView *)blockView{
    if (!_blockView) {
        _blockView = [[UIView alloc]init];
        _blockView.backgroundColor = MALLHEXCOLOR(@"FB3F49");
        _blockView.hidden = YES;
    }
    return _blockView;
}
- (GradientView *)whiteBgView{
    if (!_whiteBgView) {
        _whiteBgView = [[GradientView alloc]initWithFrame:CGRectMake(7.5, (45-22)/2, CATEGORYMENU_WIDTH - 7.5 * 2, 22) gradientColorImageFromColors:MaingradientColor gradientType:GradientTypeLeftToRight];
        _whiteBgView.layer.cornerRadius = 11;
        _whiteBgView.layer.masksToBounds = YES;
    }
    return _whiteBgView;
}
-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    if (selected == YES) {
        self.categoryTitleLabel.textColor = KWhiteColor;
        [self.whiteBgView setGradientColorImageFromColors:MaingradientColor gradientType:GradientTypeLeftToRight];
    }else{
        self.categoryTitleLabel.textColor = rgba(88, 88, 88, 1);
        self.whiteBgView.image = [UIImage imageWithColor:KWhiteColor];
    }
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.whiteBgView];
        [self.whiteBgView addSubview:self.categoryTitleLabel];
        [self.whiteBgView addSubview:self.blockView];
        self.categoryTitleLabel.frame = CGRectMake(0, 0, self.whiteBgView.width, self.whiteBgView.height);
    }
    return self;
}


@end
