//
//  MyOrderCell.m
//  531Mall
//
//  Created by 王涛 on 2020/5/21.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "MyOrderCell.h"
#import "MyOrderModel.h"

@interface MyOrderCell ()
{
    UIView      *_bac;
    UIImageView *_shopImageView;
    UILabel     *_shopName,*_price,*_num,*_waybillNum;

    
}
@property(nonatomic, strong)    UIButton    *waitButton,
                                            *returnButton,
                                            *signForButton,
                                            *signForAfterButton;
@property(nonatomic, strong)    UIButton    *waitPayButton;
/// 取消订单
@property(nonatomic, strong)    UIButton    *cancelOrderButton;
/// 取消显示  已签收状态时展示
@property(nonatomic, strong)    UIButton    *cancelShowButton;
@end

@implementation MyOrderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.backgroundColor = rgba(250, 250, 250, 1);
        [self createUI];
    }
    return self;
}

#pragma mark - action
-(void)signForClick:(UIButton *)btn{
    if([self.delegate respondsToSelector:@selector(signForClick:)]){
        [self.delegate signForClick:btn];
    }
}

-(void)returnClick:(UIButton *)btn{
    if([self.delegate respondsToSelector:@selector(returnClick:)]){
        [self.delegate returnClick:btn];
    }
}

-(void)payClick:(UIButton *)btn{
    if([self.delegate respondsToSelector:@selector(payClick:)]){
        [self.delegate payClick:btn];
    }
}

-(void)cancelClick:(UIButton *)btn{
    if([self.delegate respondsToSelector:@selector(cancelClick:)]){
        [self.delegate cancelClick:btn];
    }
}

-(void)cancelShowClick:(UIButton *)btn{
    if([self.delegate respondsToSelector:@selector(cancelShowClick:)]){
        [self.delegate cancelShowClick:btn];
    }
}


- (void)createUI{
    _bac = [UIView new];
  //  _bac.backgroundColor = KWhiteColor;
//    _bac.layer.shadowColor = [UIColor colorWithRed:153/255.0 green:174/255.0 blue:223/255.0 alpha:0.2].CGColor;
//    _bac.layer.shadowOffset = CGSizeMake(0,5);
//    _bac.layer.shadowOpacity = 1;
//    _bac.layer.shadowRadius = 9;
//    _bac.layer.cornerRadius = 5;
    [self addSubview:_bac];
    
    _shopImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mren"]];
    _shopImageView.layer.contentMode = UIViewContentModeScaleAspectFit;
    [_bac addSubview:_shopImageView];
    
    _shopName = [UILabel new];
    _shopName.text = @"--";
    _shopName.numberOfLines = 1;
    _shopName.textColor = rgba(51, 51, 51, 1);
    _shopName.font = tFont(15);
    [_bac addSubview:_shopName];
    
    _price = [UILabel new];
    _price.text = @"--";
    _price.textColor = MainColor;
    _price.font = tFont(12);
    [_bac addSubview:_price];
    
    _waybillNum = [UILabel new];
    _waybillNum.text = @"物流单号:--12312312312312312312312313";
    _waybillNum.numberOfLines = 0;
    _waybillNum.textColor = rgba(153, 153, 153, 1);
    _waybillNum.font = tFont(12);
    [_bac addSubview:_waybillNum];
    
    _num = [UILabel new];
    _num.text = @"数量:";
    _num.textColor = rgba(153, 153, 153, 1);
    _num.font = tFont(12);
    [_bac addSubview:_num];
    
    
}


- (void)setCellData:(MyOrderModel *)model GoodsInfoModel:(nonnull MyOrderGoodInfoModel *)goodsInfoModel orderType:(MyOrderType)type isLastRow:(BOOL)isLastRow{
    [_shopImageView sd_setImageWithURL:[NSURL URLWithString:goodsInfoModel.good_img]];
    _shopName.text = goodsInfoModel.good_name; 
   
    [[UniversalViewMethod sharedInstance] priceAddqCouponStr:_price priceStr:goodsInfoModel.price CouponStr:goodsInfoModel.three_price];
    
    //TODO: 物流单号
    _waybillNum.text = NSStringFormat(@"物流单号:--");
    _waybillNum.hidden = YES;
    
    _num.text = NSStringFormat(@"数量:%@",goodsInfoModel.good_amount);
   
    switch (type) {
        case MyOrderTypeAll:
        {
            switch ([model.state integerValue]) {
                case 1://待支付
                {
                    if(isLastRow){
                        self.waitPayButton.hidden = NO;
                        self.cancelOrderButton.hidden = NO;
                    }else{
                        self.waitPayButton.hidden = YES;
                        self.cancelOrderButton.hidden = YES;
                    }
                   break;
                }
                case 3://待发货
                {
                    if(isLastRow){
                        self.waitButton.hidden = NO;
                        self.cancelOrderButton.hidden = NO;
                    }else{
                        self.waitButton.hidden = YES;
                        self.cancelOrderButton.hidden = YES;
                    }
                  break;
                }
                case 5: //已发货
                {
                   if(isLastRow){
                       self.returnButton.hidden = NO;
                       self.signForButton.hidden = NO;
                   }else{
                       self.returnButton.hidden = YES;
                       self.signForButton.hidden = YES;
                   }
                    break;
                }
                case 7: //已完成
                {
                   if(isLastRow){
                       self.signForAfterButton.hidden = NO;
                   }else{
                       self.signForAfterButton.hidden = YES;
                   }
                    break;
                }
                case 9://退货申请中
//                    if(isLastRow){
//                        self.stateButton.hidden = NO;
//                    }else{
//                        self.stateButton.hidden = YES;
//                    }
//                    break;
                case 17://交易关闭
                default:
                {
                    if(isLastRow){
                        self.stateButton.hidden = NO;
                        self.cancelShowButton.hidden = NO;
                    }else{
                        self.stateButton.hidden = YES;
                        self.cancelShowButton.hidden = YES;
                    }
                    break;
                }
            }
        }
            break;
        case MyOrderTypeWaitPay:
        {
            if(isLastRow){
                self.waitPayButton.hidden = NO;
                self.cancelOrderButton.hidden = NO;
            }else{
                self.waitPayButton.hidden = YES;
                self.cancelOrderButton.hidden = YES;
            }
        }
            break;
        case MyOrderTypeWaitShip:
        {
            if(isLastRow){
               self.waitButton.hidden = NO;
               self.cancelOrderButton.hidden = NO;
            }else{
               self.waitButton.hidden = YES;
               self.cancelOrderButton.hidden = YES;
            }
        }
            break;
        case MyOrderTypeShipped:
        {
            if(isLastRow){
                self.returnButton.hidden = NO;
                self.signForButton.hidden = NO;
            }else{
                self.returnButton.hidden = YES;
                self.signForButton.hidden = YES;
            }
        }
            break;
        default:
        {
            if(isLastRow){
                self.signForAfterButton.hidden = NO;
            }else{
                self.signForAfterButton.hidden = YES;
            }
        }
            break;
    }
}
 
-(void)layoutWaitPaySubview{
      [_bac mas_makeConstraints:^(MASConstraintMaker *make) {
          make.top.mas_equalTo(self.mas_top).offset(0);
          make.left.mas_equalTo(self.mas_left).offset(OverAllLeft_OR_RightSpace);
          make.right.mas_equalTo(self.mas_right).offset(-OverAllLeft_OR_RightSpace);
          make.bottom.mas_equalTo(self.mas_bottom).offset(-0);
      }];
      
      [_shopImageView mas_makeConstraints:^(MASConstraintMaker *make) {
          make.top.mas_equalTo(_bac.mas_top).offset(15);
          make.left.mas_equalTo(_bac.mas_left).offset(10);
          make.bottom.mas_equalTo(_bac.mas_bottom).offset(-15);
          make.size.mas_equalTo(CGSizeMake(65, 65));
      }];
      
      [_shopName mas_makeConstraints:^(MASConstraintMaker *make) {
          make.top.mas_equalTo(_shopImageView.mas_top).offset(0);
          make.left.mas_equalTo(_shopImageView.mas_right).offset(11.5);
          make.right.mas_equalTo(self.mas_right).offset(-OverAllLeft_OR_RightSpace);
      }];
      
      [_price mas_makeConstraints:^(MASConstraintMaker *make) {
          make.centerY.mas_equalTo(_shopImageView.mas_centerY).offset(0);
          make.left.mas_equalTo(_shopName.mas_left);
      }];
      
      [_num mas_makeConstraints:^(MASConstraintMaker *make) {
          make.left.mas_equalTo(_shopName.mas_left);
          make.top.mas_equalTo(_price.mas_bottom).offset(9);
          make.bottom.mas_equalTo(_shopImageView.mas_bottom) ;
    
      }];
      
      [self.waitPayButton mas_makeConstraints:^(MASConstraintMaker *make) {
          make.right.mas_equalTo(_bac.mas_right).offset(-12);
          make.bottom.mas_equalTo(_shopImageView.mas_bottom);
          make.size.mas_equalTo(CGSizeMake([HelpManager getLabelWidth:12 labelTxt:self.waitPayButton.titleLabel.text].width + 25, 20));
      }];
    
    [self.cancelOrderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.waitPayButton.mas_left).offset(-10);
        make.centerY.mas_equalTo(self.waitPayButton);
        make.size.mas_equalTo(CGSizeMake([HelpManager getLabelWidth:12 labelTxt:self.cancelOrderButton.titleLabel.text].width + 25, 20));
    }];
}

- (void)layoutWaitShipSubview{
    [_bac mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.left.mas_equalTo(self.mas_left).offset(OverAllLeft_OR_RightSpace);
        make.right.mas_equalTo(self.mas_right).offset(-OverAllLeft_OR_RightSpace);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-0);
    }];
    
    [_shopImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_bac.mas_top).offset(15);
        make.left.mas_equalTo(_bac.mas_left).offset(10);
        make.bottom.mas_equalTo(_bac.mas_bottom).offset(-15);
        make.size.mas_equalTo(CGSizeMake(65, 65));
    }];
    
    [_shopName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_shopImageView.mas_top).offset(0);
        make.left.mas_equalTo(_shopImageView.mas_right).offset(11.5);
        make.right.mas_equalTo(self.mas_right).offset(-OverAllLeft_OR_RightSpace);
    }];
    
    [_price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_shopImageView.mas_centerY).offset(0);
        make.left.mas_equalTo(_shopName.mas_left);
    }];
    
    [_num mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_shopName.mas_left);
        make.top.mas_equalTo(_price.mas_bottom).offset(9);
        make.bottom.mas_equalTo(_bac.mas_bottom).offset(-12.5);
  
    }];
    
    [self.waitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_bac.mas_right).offset(-12);
        make.bottom.mas_equalTo(_shopImageView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake([HelpManager getLabelWidth:12 labelTxt:self.waitButton.titleLabel.text].width + 25, 20));
    }];
    
    [self.cancelOrderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.waitButton.mas_left).offset(-10);
        make.centerY.mas_equalTo(self.waitButton);
        make.size.mas_equalTo(CGSizeMake([HelpManager getLabelWidth:12 labelTxt:self.cancelOrderButton.titleLabel.text].width + 25, 20));
    }];
}

-(void)layoutShippedView{
      [_bac mas_makeConstraints:^(MASConstraintMaker *make) {
          make.top.mas_equalTo(self.mas_top).offset(0);
          make.left.mas_equalTo(self.mas_left).offset(OverAllLeft_OR_RightSpace);
          make.right.mas_equalTo(self.mas_right).offset(-OverAllLeft_OR_RightSpace);
          make.bottom.mas_equalTo(self.mas_bottom).offset(-0);
      }];
      
      [_shopImageView mas_makeConstraints:^(MASConstraintMaker *make) {
          make.top.mas_equalTo(_bac.mas_top).offset(15);
          make.left.mas_equalTo(_bac.mas_left).offset(10);
          make.bottom.mas_equalTo(_bac.mas_bottom).offset(-15);
          make.size.mas_equalTo(CGSizeMake(65, 65));
      }];
      
      [_shopName mas_makeConstraints:^(MASConstraintMaker *make) {
          make.top.mas_equalTo(_shopImageView.mas_top).offset(0);
          make.left.mas_equalTo(_shopImageView.mas_right).offset(11.5);
          make.right.mas_equalTo(self.mas_right).offset(-OverAllLeft_OR_RightSpace);
      }];
      
      [_price mas_makeConstraints:^(MASConstraintMaker *make) {
          make.top.mas_equalTo(_shopName.mas_bottom).offset(6);
          make.left.mas_equalTo(_shopName.mas_left);
      }];
    
    [_waybillNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_price.mas_bottom).offset(5.5);
        make.left.mas_equalTo(_shopName.mas_left);
    }];
    
    [_num mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_shopName.mas_left);
        make.top.mas_equalTo(_waybillNum.mas_bottom).offset(4.5);
        make.bottom.mas_equalTo(_bac.mas_bottom).offset(-12.5);
    
    }];
      
    [self.signForButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_bac.mas_right).offset(-12);
        make.bottom.mas_equalTo(_shopImageView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake([HelpManager getLabelWidth:12 labelTxt:self.signForButton.titleLabel.text].width + 25, 20));
    }];
  
    [self.returnButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.signForButton.mas_left).offset(-10);
        make.centerY.mas_equalTo(self.signForButton);
        make.size.mas_equalTo(CGSizeMake([HelpManager getLabelWidth:12 labelTxt:self.returnButton.titleLabel.text].width + 25, 20));
    }];
}

-(void)layoutOverView{
      [_bac mas_makeConstraints:^(MASConstraintMaker *make) {
          make.top.mas_equalTo(self.mas_top).offset(0);
          make.left.mas_equalTo(self.mas_left).offset(OverAllLeft_OR_RightSpace);
          make.right.mas_equalTo(self.mas_right).offset(-OverAllLeft_OR_RightSpace);
          make.bottom.mas_equalTo(self.mas_bottom).offset(-0);
      }];
      
      [_shopImageView mas_makeConstraints:^(MASConstraintMaker *make) {
          make.top.mas_equalTo(_bac.mas_top).offset(15);
          make.left.mas_equalTo(_bac.mas_left).offset(10);
          make.bottom.mas_equalTo(_bac.mas_bottom).offset(-15);
          make.size.mas_equalTo(CGSizeMake(65, 65));
      }];
      
      [_shopName mas_makeConstraints:^(MASConstraintMaker *make) {
          make.top.mas_equalTo(_shopImageView.mas_top).offset(0);
          make.left.mas_equalTo(_shopImageView.mas_right).offset(11.5);
          make.right.mas_equalTo(self.mas_right).offset(-OverAllLeft_OR_RightSpace);
      }];
      
      [_price mas_makeConstraints:^(MASConstraintMaker *make) {
          make.top.mas_equalTo(_shopName.mas_bottom).offset(6);
          make.left.mas_equalTo(_shopName.mas_left);
      }];
    
      [_waybillNum mas_makeConstraints:^(MASConstraintMaker *make) {
          make.top.mas_equalTo(_price.mas_bottom).offset(5.5);
          make.left.mas_equalTo(_shopName.mas_left);
      }];
    
      [_num mas_makeConstraints:^(MASConstraintMaker *make) {
          make.left.mas_equalTo(_shopName.mas_left);
          make.top.mas_equalTo(_waybillNum.mas_bottom).offset(4.5);
          make.bottom.mas_equalTo(_bac.mas_bottom).offset(-12.5);
    
      }];
      
      [self.signForAfterButton mas_makeConstraints:^(MASConstraintMaker *make) {
          make.right.mas_equalTo(_bac.mas_right).offset(-12);
          make.bottom.mas_equalTo(_shopImageView.mas_bottom);
          make.size.mas_equalTo(CGSizeMake([HelpManager getLabelWidth:12 labelTxt:self.signForAfterButton.titleLabel.text].width + 25, 20));
      }];
     
      [self.cancelShowButton mas_makeConstraints:^(MASConstraintMaker *make) {
          make.right.mas_equalTo(self.signForAfterButton.mas_left).offset(-10);
          make.centerY.mas_equalTo(self.signForAfterButton);
          make.size.mas_equalTo(CGSizeMake([HelpManager getLabelWidth:12 labelTxt:self.cancelShowButton.titleLabel.text].width + 25, 20));
      }];
    
}

-(void)layoutOtherView{
    [_bac mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.mas_equalTo(self.mas_top).offset(0);
         make.left.mas_equalTo(self.mas_left).offset(OverAllLeft_OR_RightSpace);
         make.right.mas_equalTo(self.mas_right).offset(-OverAllLeft_OR_RightSpace);
         make.bottom.mas_equalTo(self.mas_bottom).offset(-0);
     }];
     
     [_shopImageView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.mas_equalTo(_bac.mas_top).offset(15);
         make.left.mas_equalTo(_bac.mas_left).offset(10);
         make.bottom.mas_equalTo(_bac.mas_bottom).offset(-15);
         make.size.mas_equalTo(CGSizeMake(65, 65));
     }];
     
     [_shopName mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.mas_equalTo(_shopImageView.mas_top).offset(0);
         make.left.mas_equalTo(_shopImageView.mas_right).offset(11.5);
         make.right.mas_equalTo(self.mas_right).offset(-OverAllLeft_OR_RightSpace);
     }];
     
     [_price mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerY.mas_equalTo(_shopImageView.mas_centerY).offset(0);
         make.left.mas_equalTo(_shopName.mas_left);
     }];
     
     [_num mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.mas_equalTo(_shopName.mas_left);
         make.top.mas_equalTo(_price.mas_bottom).offset(9);
         make.bottom.mas_equalTo(_shopImageView.mas_bottom) ;
   
     }];
     
     [self.stateButton mas_makeConstraints:^(MASConstraintMaker *make) {
         make.right.mas_equalTo(_bac.mas_right).offset(-12);
         make.bottom.mas_equalTo(_shopImageView.mas_bottom);
         make.size.mas_equalTo(CGSizeMake([HelpManager getLabelWidth:12 labelTxt:self.stateButton.titleLabel.text].width + 25, 20));
     }];
        
     [self.cancelShowButton mas_makeConstraints:^(MASConstraintMaker *make) {
         make.right.mas_equalTo(self.stateButton.mas_left).offset(-10);
         make.centerY.mas_equalTo(self.stateButton);
         make.size.mas_equalTo(CGSizeMake([HelpManager getLabelWidth:12 labelTxt:self.cancelShowButton.titleLabel.text].width + 25, 20));
     }];
}

-(UIButton *)waitButton{
    if(!_waitButton){
        _waitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_waitButton setTitle:@"待发货" forState:UIControlStateNormal];
        [_waitButton.titleLabel setFont:tFont(12)];
        _waitButton.layer.borderWidth = 0.5;
        _waitButton.layer.borderColor = MainColor.CGColor;
        _waitButton.layer.cornerRadius = 5;
        _waitButton.layer.masksToBounds = YES;
        [_waitButton setTitleColor:MainColor forState:UIControlStateNormal];
        [_bac addSubview:_waitButton];
    }
    return _waitButton;
}

-(UIButton *)cancelOrderButton{
    if(!_cancelOrderButton){
        _cancelOrderButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelOrderButton setTitle:@"取消订单" forState:UIControlStateNormal];
        [_cancelOrderButton.titleLabel setFont:tFont(12)];
        _cancelOrderButton.layer.borderWidth = 0.5;
        _cancelOrderButton.layer.borderColor = rgba(255, 174, 0, 1).CGColor;
        _cancelOrderButton.layer.cornerRadius = 5;
        _cancelOrderButton.layer.masksToBounds = YES;
        [_cancelOrderButton setTitleColor:rgba(255, 174, 0, 1) forState:UIControlStateNormal];
        [_cancelOrderButton addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bac addSubview:_cancelOrderButton];
    }
    return _cancelOrderButton;
}


-(UIButton *)waitPayButton{
    if(!_waitPayButton){
        _waitPayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_waitPayButton setTitle:@"待付款" forState:UIControlStateNormal];
        [_waitPayButton.titleLabel setFont:tFont(12)];
        _waitPayButton.layer.borderWidth = 0.5;
        _waitPayButton.layer.borderColor = MainColor.CGColor;
        _waitPayButton.layer.cornerRadius = 5;
        _waitPayButton.layer.masksToBounds = YES;
        [_waitPayButton setTitleColor:MainColor forState:UIControlStateNormal];
        [_waitPayButton addTarget:self action:@selector(payClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bac addSubview:_waitPayButton];
    }
    return _waitPayButton;
}

-(UIButton *)returnButton{
    if(!_returnButton){
        _returnButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_returnButton setTitle:@"退货" forState:UIControlStateNormal];
        [_returnButton.titleLabel setFont:tFont(12)];
        _returnButton.layer.borderWidth = 0.5;
        _returnButton.layer.borderColor = rgba(255, 174, 0, 1).CGColor;
        _returnButton.layer.cornerRadius = 5;
        _returnButton.layer.masksToBounds = YES;
        [_returnButton setTitleColor:rgba(255, 174, 0, 1) forState:UIControlStateNormal];
        [_returnButton addTarget:self action:@selector(returnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bac addSubview:_returnButton];
    }
    return _returnButton;
}

-(UIButton *)signForButton{
    if(!_signForButton){
        _signForButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_signForButton setTitle:@"签收" forState:UIControlStateNormal];
        [_signForButton.titleLabel setFont:tFont(12)];
        _signForButton.layer.borderWidth = 0.5;
        _signForButton.layer.borderColor = MainColor.CGColor;
        _signForButton.layer.cornerRadius = 5;
        _signForButton.layer.masksToBounds = YES;
        [_signForButton setTitleColor:MainColor forState:UIControlStateNormal];
        [_signForButton addTarget:self action:@selector(signForClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bac addSubview:_signForButton];
    }
    return _signForButton;
}

-(UIButton *)signForAfterButton{
    if(!_signForAfterButton){
        _signForAfterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_signForAfterButton setTitle:@"已签收" forState:UIControlStateNormal];
        [_signForAfterButton.titleLabel setFont:tFont(12)];
        _signForAfterButton.layer.borderWidth = 0.5;
        _signForAfterButton.layer.borderColor = rgba(255, 174, 0, 1).CGColor;
        _signForAfterButton.layer.cornerRadius = 5;
        _signForAfterButton.layer.masksToBounds = YES;
        [_signForAfterButton setTitleColor:rgba(255, 174, 0, 1) forState:UIControlStateNormal];
        [_bac addSubview:_signForAfterButton];
    }
    return _signForAfterButton;
}
 
-(UIButton *)cancelShowButton{
    if(!_cancelShowButton){
        _cancelShowButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelShowButton setTitle:@"删除订单" forState:UIControlStateNormal];
        [_cancelShowButton.titleLabel setFont:tFont(12)];
        _cancelShowButton.layer.borderWidth = 0.5;
        _cancelShowButton.layer.borderColor = MainColor.CGColor;
        _cancelShowButton.layer.cornerRadius = 5;
        _cancelShowButton.layer.masksToBounds = YES;
        [_cancelShowButton setTitleColor:MainColor forState:UIControlStateNormal];
        [_cancelShowButton addTarget:self action:@selector(cancelShowClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bac addSubview:_cancelShowButton];
    }
    return _cancelShowButton;
}

-(UIButton *)stateButton{
    if(!_stateButton){
        _stateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_stateButton.titleLabel setFont:tFont(12)];
        _stateButton.layer.borderWidth = 0.5;
        _stateButton.layer.borderColor = rgba(255, 174, 0, 1).CGColor;
        _stateButton.layer.cornerRadius = 5;
        _stateButton.layer.masksToBounds = YES;
        [_stateButton setTitleColor:rgba(255, 174, 0, 1) forState:UIControlStateNormal]; 
        [_bac addSubview:_stateButton];
    }
    return _stateButton;
}
 
@end
 
@implementation MyOrderCellWaitPay
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self layoutWaitPaySubview];
    }
    return self;
}

@end

@implementation MyOrderCellWaitShip

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self layoutWaitShipSubview];
    }
    return self;
}

@end

@implementation MyOrderCellShipped

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self layoutShippedView];
    }
    return self;
}

@end

@implementation MyOrderCellOver

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self layoutOverView];
    }
    return self;
}

@end
   
@implementation MyOrderCellOther

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self layoutOtherView];
    }
    return self;
}


@end
   
