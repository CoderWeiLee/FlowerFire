//
//  AnnouncementCell.m
//  FlowerFire
//
//  Created by 王涛 on 2020/9/2.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "AnnouncementCell.h"

@interface AnnouncementCell ()
{
    WTLabel     *_time;
    WTBacView   *_whiteBac;
    UILabel     *_title;
    WTLabel     *_details;
    WTBacView   *_line;
}
@end

@implementation AnnouncementCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self createUI];
        [self layoutSubview];
    }
    return self;
}

- (void)createUI{
    _time = [[WTLabel alloc] initWithFrame:CGRectZero Text:@"--" Font:tFont(13) textColor:grayTextColor parentView:self.contentView];
    
    _whiteBac = [[WTBacView alloc] initWithFrame:CGRectZero backGroundColor:KWhiteColor parentView:self.contentView];
    _whiteBac.layer.cornerRadius = 5;
    _whiteBac.layer.borderColor = FlowerFirexianColor.CGColor;
    _whiteBac.layer.borderWidth = 1;
    
    _title = [[UILabel alloc] initWithFrame:CGRectZero];
    _title.text = @"123123\n\n\n\n121233122312321231232112112131133123123123123123123";
    _title.font = [UIFont boldSystemFontOfSize:18];
    _time.textColor = KBlackColor;
    [_whiteBac addSubview:_title];
                                      // Text:@"123123\n\n\n\n121233122312321231232112112131133123123123123123123" Font: textColor:KBlackColor parentView:_whiteBac];
    _title.numberOfLines = 0;
    
    _line = [[WTBacView alloc] initWithFrame:CGRectZero backGroundColor:FlowerFirexianColor parentView:_whiteBac];
    
    _details = [[WTLabel alloc] initWithFrame:CGRectZero Text:LocalizationKey(@"578Tip152") Font:tFont(15) textColor:grayTextColor parentView:_whiteBac];
    
}

- (void)layoutSubview{
    [_time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(15);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
    }];
    
    [_whiteBac mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_time.mas_bottom).offset(15);
        make.left.mas_equalTo(self.contentView.mas_left).offset(OverAllLeft_OR_RightSpace);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-OverAllLeft_OR_RightSpace);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-OverAllLeft_OR_RightSpace);
    }];
    
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_whiteBac.mas_top).offset(20);
        make.left.mas_equalTo(_whiteBac.mas_left).offset(20);
        make.right.mas_equalTo(_whiteBac.mas_right).offset(-20);
         
    }];
    
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_title.mas_bottom).offset(20);
        make.left.mas_equalTo(_whiteBac.mas_left);
        make.right.mas_equalTo(_whiteBac.mas_right);
        make.height.mas_equalTo(1);
    }];

    [_details mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_line.mas_bottom).offset(15);
        make.left.mas_equalTo(_title.mas_left);
        make.right.mas_equalTo(_title.mas_right);
        make.bottom.mas_equalTo(_whiteBac.mas_bottom).offset(-15);
    }];
}

- (void)setCellData:(id)dic{
//    AnnouncementModel *model = (AnnouncementModel *)dic;
//    _title.text = model.title;
//    _time.text = model.create_time;
    NoteModel *model = (NoteModel *)dic;
    _title.text = model.title;
    _time.text = model.addtime;
}

@end
