//
//  suocangcell.m
//  FlowerFire
//
//  Created by work on 2020/12/5.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "suocangcell.h"

@implementation suocangcell

+(suocangcell *)cellwithtableview:(UITableView *)tableview{
    suocangcell *cell = [tableview dequeueReusableCellWithIdentifier:@"suocangcell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"suocangcell" owner:self options:nil].lastObject;
    }
    return cell;
}

@end
