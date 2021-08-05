//
//  HDVideoConfigurationEntry.m
//  HDVideoKitDemok
//
//  Created by liugaosheng on 2021/8/4.
//  Copyright © 2021 刘高升. All rights reserved.
//

#import "HDVideoConfigurationEntry.h"
#import "HDServicesManager.h"
#import "UKNetworkHelper.h"
#import "UKRequestURLPath.h"
#import "HDUkeInfoCenter.h"
#import "Macro.h"

@implementation HDVideoConfigurationEntry
+ (void)configUserNickName:(NSString *)nickName userName:(NSString *)userName token:(NSString *)token avatar:(NSString *)avatar HTTPType:(HDNetEnvironmentType)HTTPType carSource:(int)carSource dentityStatus:(int)dentityStatus {
    HDUkeConfigurationModel *model = [[HDUkeConfigurationModel alloc]init];
    model.HTTPType = HTTPType;
    model.carSource = carSource;
    model.nickName = nickName;
    model.username= userName;
    model.avatar = avatar;
    model.token = token;
    
    [HDVideoConfigurationEntry settingConfiguration:model];
    
}


+ (void)settingConfiguration:(HDUkeConfigurationModel *)configuration {

    HDUkeInfoCenterModel *model = [[HDUkeInfoCenterModel alloc]init];
    model.nickName = configuration.nickName;
    model.username = configuration.username;
    model.token = configuration.token;
    model.avatar = configuration.avatar;
//    model.token1 = configuration.token;
    
    [HDUkeInfoCenter sharedCenter].userModel = model;
    [HDUkeInfoCenter sharedCenter].configurationModel = configuration;
    [HDUkeInfoCenter sharedCenter].configurationModel.token1 = configuration.token;

    if (configuration.HTTPType == HDNetEnvironmentType_Test) {
        [HDUkeInfoCenter sharedCenter].configurationModel.shareURL = @"http://sy.aerozhonghuan.com:81/test/yiqi/web/share/index.html?";
        [HDUkeInfoCenter sharedCenter].configurationModel.HTTPURL  = @"http://sy.smartlink-tech.com.cn:81/dspfawapi/mobile";//新测试地址
        
//        if (configuration.carSource == 1) {
//            [HDUkeInfoCenter sharedCenter].configurationModel.shareURL = @"http://sy.smartlink-tech.com.cn:81/dspqdfawshare/index.html?";
//            [HDUkeInfoCenter sharedCenter].configurationModel.HTTPURL  = @"http://sy.smartlink-tech.com.cn:81/dspqdfawapi/mobile";
//        }else {
//            [HDUkeInfoCenter sharedCenter].configurationModel.shareURL = @"http://sy.smartlink-tech.com.cn:81/dspfawshare/index.html?";
//            [HDUkeInfoCenter sharedCenter].configurationModel.HTTPURL  = @"http://sy.smartlink-tech.com.cn:81/dspfawapi/mobile";
//        }

    }
    else if (configuration.HTTPType == HDNetEnvironmentType_Uat) {
        if (configuration.carSource == 1) {
        
            [HDUkeInfoCenter sharedCenter].configurationModel.HTTPURL  = @"https://uat-iov-ec.fawjiefang.com.cn/dspqdfawapi/mobile";
            [HDUkeInfoCenter sharedCenter].configurationModel.shareURL = @"https://uat-iov-ec.fawjiefang.com.cn/dspqdfawshare/index.html?";

        }else {
            [HDUkeInfoCenter sharedCenter].configurationModel.HTTPURL  = @"https://uat-iov-ec.fawjiefang.com.cn/dspapi/mobile";
            [HDUkeInfoCenter sharedCenter].configurationModel.shareURL = @"https://uat-iov-ec.fawjiefang.com.cn/dspshare/index.html?";
            
        }

    }
    else if (configuration.HTTPType == HDNetEnvironmentType_Releases) {
        
        if (configuration.carSource == 1) {
            [HDUkeInfoCenter sharedCenter].configurationModel.HTTPURL  = @"https://jfvideo.fawjiefang.com.cn/dspqdfawapi/mobile";
            [HDUkeInfoCenter sharedCenter].configurationModel.shareURL = @"https://iov-ec.fawjiefang.com.cn/dspqdfawshare/index.html?";
        }else {
            [HDUkeInfoCenter sharedCenter].configurationModel.HTTPURL  = @"https://jfvideo.fawjiefang.com.cn/dspfawapi/mobile";
            [HDUkeInfoCenter sharedCenter].configurationModel.shareURL = @"https://iov-ec.fawjiefang.com.cn/dspfawshare/index.html?";
        }
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"username"] = [HDUkeInfoCenter sharedCenter].userModel.username;
    dic[@"nickName"] = [HDUkeInfoCenter sharedCenter].userModel.nickName;
    dic[@"avatar"] = [HDUkeInfoCenter sharedCenter].userModel.avatar;
    dic[@"token"] = [HDUkeInfoCenter sharedCenter].userModel.token;
    [SVProgressHUD show];
    [UKNetworkHelper POST:UKURL_GET_APP_UPDATE_passportlogin parameters:dic success:^(UKBaseRequest * _Nonnull request, id  _Nonnull response) {

        NSNumber *code = response[@"code"];
        if ([[code stringValue] isEqualToString:@"0"]) {
            [HDUkeInfoCenter sharedCenter].userModel = [HDUkeInfoCenterModel mj_objectWithKeyValues:response[@"data"]];
            
            [UKNetworkHelper GET:UKURL_GET_APP_UPDATE_usercenterprofile parameters:nil success:^(UKBaseRequest * _Nonnull request, id  _Nonnull response) {
                  NSLog(@"UKURL_GET_APP_UPDATE_usercenterprofile:%@",response);
                  NSNumber *code = response[@"code"];
                  if ([[code stringValue] isEqualToString:@"0"]) {
                      [HDUkeInfoCenter sharedCenter].userModel.nickName = response[@"data"][@"nickName"];
                      [HDUkeInfoCenter sharedCenter].userModel.username = response[@"data"][@"username"];
                      return ;
                  }

                } failure:^(UKBaseRequest * _Nonnull request, id _Nonnull error) {
            }];
            NSNumber *state =[HDUkeInfoCenter sharedCenter].userModel.state;
            if ([state intValue] == 3) {
                UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:@"由于您多次违规操作，已被禁用该功能" preferredStyle:UIAlertControllerStyleAlert];

                   UIAlertAction *sureBtn = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull   action) {
                       [[self lgs_findVisibleViewController].navigationController popViewControllerAnimated:YES];
                   }];

                   [alertVc addAction:sureBtn];
                   //展示
                   [[self lgs_findVisibleViewController] presentViewController:alertVc animated:YES completion:nil];
            }else {
                ///设置成功
                [[self lgs_findVisibleViewController].view makeToast:@"设置测试环境成功"];
            }
        }

        NSLog(@"%@",response);
        [SVProgressHUD dismiss];
    } failure:^(UKBaseRequest * _Nonnull request, id _Nonnull error) {
        [SVProgressHUD dismiss];
        NSLog(@"error:%@",error);
       
        if ([error isKindOfClass:[NSDictionary class]]) {
            NSNumber *num = error[@"code"];
            if ([num intValue] == 4010000) {
                [SVProgressHUD showErrorWithStatus:error[@"message"]];
                [[self lgs_findVisibleViewController].navigationController popViewControllerAnimated:YES];
            }else if ([num intValue] == 4000103) {
                UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:@"由于您多次违规操作，已被禁用该功能" preferredStyle:UIAlertControllerStyleAlert];

                   UIAlertAction *sureBtn = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull   action) {
                       [[self lgs_findVisibleViewController].navigationController popViewControllerAnimated:YES];
                   }];

                   [alertVc addAction:sureBtn];
                   //展示
                   [[self lgs_findVisibleViewController] presentViewController:alertVc animated:YES completion:nil];
            }
        }else {
            return [SVProgressHUD showErrorWithStatus:@"网络异常，请检查网络状态"];
        }
    }];
    
   
    
}

+ (UIViewController *)lgs_getRootViewController{

    UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
    NSAssert(window, @"The window is empty");
    return window.rootViewController;
}

+ (UIViewController *)lgs_findVisibleViewController {
    
    UIViewController *currentViewController = [self lgs_getRootViewController];

    BOOL runLoopFind = YES;
    while (runLoopFind) {
        if (currentViewController.presentedViewController) {
            currentViewController = currentViewController.presentedViewController;
        } else {
            if ([currentViewController isKindOfClass:[UINavigationController class]]) {
                currentViewController = ((UINavigationController *)currentViewController).visibleViewController;
            } else if ([currentViewController isKindOfClass:[UITabBarController class]]) {
                currentViewController = ((UITabBarController* )currentViewController).selectedViewController;
            } else {
                break;
            }
        }
    }
    
    return currentViewController;
}

@end
