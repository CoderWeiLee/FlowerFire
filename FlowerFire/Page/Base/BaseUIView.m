//
//  BaseUIView.m
//  FireCoin
//
//  Created by 王涛 on 2019/5/30.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "BaseUIView.h"
 
@implementation BaseUIView
 
 
-(void)initData{
    
}

-(void)getHttpData_array:(NSDictionary *)dict response:(Response)flag Tag:(NSString *)tag {
    [MBManager hideAlert];
    if (flag == Success) {
        switch ([dict[@"code"] integerValue]) {
            case 0:
               
                break;
            case 1:
                [self dataNormal:dict type:tag];
                break;
            case 200:
            { 
                [[WTPageRouterManager sharedInstance] jumpLoginViewController:[self viewController] isModalMode:YES whatProject:0];
            }
                break;
            case 201:
             
                break;
            case 300:
         
                break;
            default:
          
                break;
        }
    }
    
}

-(void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    
}

-(AFNetworkClass *)afnetWork{
    if(!_afnetWork){
        _afnetWork = [AFNetworkClass new];
        _afnetWork.delegate = self;
    }
    return _afnetWork;
}


@end
