//
//  FFAcountDetailsViewController.m
//  FlowerFire
//
//  Created by 王涛 on 2020/8/25.
//  Copyright © 2020 Celery. All rights reserved.
//  账号想起

#import "FFAcountDetailsViewController.h"
#import "WTTableStyleValue1Cell.h"
#import "FFSaveMnemonicViewController.h"
#import "AESCipher.h"
#import "SettingFundPwdViewController.h"

@interface FFAcountDetailsViewController ()

@end

@implementation FFAcountDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self createNavBar];
    [self createUI];
    [self initData];
}
  
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
     
    if([HelpManager isBlankString:[WTUserInfo shareUserInfo].paypass]){
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:LocalizationKey(@"578Tip121") message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:LocalizationKey(@"Go to set") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            SettingFundPwdViewController *svc = [SettingFundPwdViewController new];
            [self.navigationController pushViewController:svc animated:YES];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:LocalizationKey(@"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self closeVC];
        }];
        [actionSheet addAction:action2];
        [actionSheet addAction:action1];
        [self presentViewController:actionSheet animated:YES completion:nil];
    }

}

- (void)createNavBar{
    self.gk_navigationItem.title = LocalizationKey(@"578Tip61");
}

- (void)createUI{
    self.tableView.frame = CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight - Height_NavBar);
    [self.view addSubview:self.tableView];
    self.tableView.bounces = NO;
    self.tableView.rowHeight = 50;
}

- (void)initData{
    self.dataArray = @[@{@"title":LocalizationKey(@"578Tip58")},
                       @{@"title":LocalizationKey(@"578Tip59")},
                       @{@"title":LocalizationKey(@"578Tip60")},].copy;
}

- (void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    if([type isEqualToString:@"1"]){//备份助记词
        NSString *mnemonic = dict[@"data"][@"mnemonic"];
        //复制出来解密
        mnemonic = aesDecryptString(mnemonic, AES_KEY);
        [HelpManager copyStringOnPasteboard:mnemonic];
    }else if([type isEqualToString:@"2"]){//备份私钥
        NSString *private_key = dict[@"data"][@"private_key"];
        private_key = aesDecryptString(private_key, AES_KEY);
        [HelpManager copyStringOnPasteboard:private_key];
    }
}

#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        return;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请输入交易密码" message:@"" preferredStyle:UIAlertControllerStyleAlert];
      //增加确定按钮；
      [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //获取第1个输入框；
          UITextField *userNameTextField = alertController.textFields.firstObject;
            
          NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:1];
          md[@"paypass"] = userNameTextField.text;
          [self.afnetWork jsonPostDict:@"/api/user/getPrivateKey" JsonDict:md Tag:NSStringFormat(@"%ld",(long)indexPath.row)];
      }]];
      
      //增加取消按钮；
      [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
      
      //定义第一个输入框；
      [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
          textField.secureTextEntry = YES;
          textField.placeholder = @"请输入交易密码";
      }];
      
      [self presentViewController:alertController animated:true completion:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    [self.tableView registerClass:[WTTableStyleValue1Cell class] forCellReuseIdentifier:identifier];
    WTTableStyleValue1Cell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if(indexPath.row == 0){
        cell.rightLabel.text = self.userName;
    }else{
        UIImageView *arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xyy"]];
        arrowImage.frame = CGRectMake(0, 0, 15, 15);
        cell.accessoryView = arrowImage;
    }
    if(self.dataArray.count>0){
        cell.textLabel.text = self.dataArray[indexPath.row][@"title"];
    }
    cell.textLabel.font = tFont(15);
    
    return cell;
}


@end
