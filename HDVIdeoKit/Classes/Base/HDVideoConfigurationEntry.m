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
#import "HDNativeNetWorking.h"
#import "Macro.h"

#import <PLMediaStreamingKit/PLMediaStreamingKit.h>

@implementation HDVideoConfigurationEntry
+ (void)configUserNickName:(NSString *)nickName userName:(NSString *)userName token:(NSString *)token avatar:(NSString *)avatar HTTPType:(HDNetEnvironmentType)HTTPType dentityStatus:(int)dentityStatus {
    HDUkeConfigurationModel *model = [[HDUkeConfigurationModel alloc]init];
    model.HTTPType = HTTPType;
    model.nickName = nickName;
    model.username= userName;
    model.avatar = avatar;
    model.token = token;
    
    [HDVideoConfigurationEntry settingConfiguration:model];
    [PLStreamingEnv initEnv];
}


+ (void)settingConfiguration:(HDUkeConfigurationModel *)configuration {

    HDUkeInfoCenterModel *model = [[HDUkeInfoCenterModel alloc]init];
    model.nickName = configuration.nickName;
    model.phone = configuration.username;
    model.token = configuration.token;
    model.avatar = configuration.avatar;

    
    [HDUkeInfoCenter sharedCenter].userModel = model;
    [HDUkeInfoCenter sharedCenter].configurationModel = configuration;
    [HDUkeInfoCenter sharedCenter].configurationModel.token1 = configuration.token;

    if (configuration.HTTPType == HDNetEnvironmentType_Test) {
        [HDUkeInfoCenter sharedCenter].configurationModel.shareURL = @"http://sy.aerozhonghuan.com:81/test/yiqi/web/share/index.html?";
        [HDUkeInfoCenter sharedCenter].configurationModel.HTTPURL  = @"http://sy.smartlink-tech.com.cn:81/dspfawapi/mobile";//新测试地址
        

    }
    else if (configuration.HTTPType == HDNetEnvironmentType_Uat) {
        [HDUkeInfoCenter sharedCenter].configurationModel.shareURL = @"http://sy.aerozhonghuan.com:81/test/yiqi/web/share/index.html?";
        [HDUkeInfoCenter sharedCenter].configurationModel.HTTPURL  = @"http://sy.smartlink-tech.com.cn:81/dspfawapi/mobile";//新测试地址
        

    }
    else if (configuration.HTTPType == HDNetEnvironmentType_Releases) {
        
        [HDUkeInfoCenter sharedCenter].configurationModel.shareURL = @"http://sy.aerozhonghuan.com:81/test/yiqi/web/share/index.html?";
        [HDUkeInfoCenter sharedCenter].configurationModel.HTTPURL  = @"http://sy.smartlink-tech.com.cn:81/dspfawapi/mobile";//新测试地址
        
    }
    
    [UKNetworkHelper GET:UKURL_GET_APP_UPDATE_usercenterprofile parameters:nil success:^(UKBaseRequest * _Nonnull request, id  _Nonnull response) {
            NSNumber *code = response[@"code"];
            if ([[code stringValue] isEqualToString:@"0"]) {
                HDUserCenterProfileModel *profileModel = [HDUserCenterProfileModel mj_objectWithKeyValues:response[@"data"]];
                [HDUkeInfoCenter sharedCenter].userModel.uuid = profileModel.uuid;
                [HDUkeInfoCenter sharedCenter].userModel.phone = profileModel.username;
                [HDUkeInfoCenter sharedCenter].userModel.state = profileModel.state;
                [HDUkeInfoCenter sharedCenter].userModel.videoLength = profileModel.videoLength;
                [HDUkeInfoCenter sharedCenter].userModel.nickName = profileModel.nickName;
                [HDUkeInfoCenter sharedCenter].userModel.liveVideoDevice = profileModel.liveVideoDevice;
                [HDUkeInfoCenter sharedCenter].userModel.avatar = profileModel.avatar;
            }else{
                [SVProgressHUD showErrorWithStatus:@"获取用户信息失败，请重试!"];
            }

          } failure:^(UKBaseRequest * _Nonnull request, id _Nonnull error) {
              [SVProgressHUD showErrorWithStatus:@"获取用户信息失败，请重试!"];
      }];
    
}
+ (void)configUserName:(NSString *)userName password:(NSString *)password  HTTPType:(HDNetEnvironmentType)HTTPType  dentityStatus:(int)dentityStatus {
    [PLStreamingEnv initEnv];
    
    HDUkeConfigurationModel *model = [[HDUkeConfigurationModel alloc]init];
    model.HTTPType = HTTPType;
    model.username= userName;

    [HDUkeInfoCenter sharedCenter].configurationModel = model;
    if (HTTPType == HDNetEnvironmentType_Test) {
        [HDUkeInfoCenter sharedCenter].configurationModel.shareURL = @"http://sy.aerozhonghuan.com:81/test/yiqi/web/share/index.html?";
        [HDUkeInfoCenter sharedCenter].configurationModel.HTTPURL  = @"http://sy.smartlink-tech.com.cn:81/dspfawapi/mobile";//新测试地址
        

    }
    else if (HTTPType == HDNetEnvironmentType_Uat) {
        [HDUkeInfoCenter sharedCenter].configurationModel.shareURL = @"http://sy.aerozhonghuan.com:81/test/yiqi/web/share/index.html?";
        [HDUkeInfoCenter sharedCenter].configurationModel.HTTPURL  = @"http://sy.smartlink-tech.com.cn:81/dspfawapi/mobile";//新测试地址
        

    }
    else if (HTTPType == HDNetEnvironmentType_Releases) {
        
        [HDUkeInfoCenter sharedCenter].configurationModel.shareURL = @"http://sy.aerozhonghuan.com:81/test/yiqi/web/share/index.html?";
        [HDUkeInfoCenter sharedCenter].configurationModel.HTTPURL  = @"http://sy.smartlink-tech.com.cn:81/dspfawapi/mobile";//新测试地址
        
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"loginName"] = userName;
    dic[@"password"] = password;
    dic[@"product"] = @"qingqi";
    dic[@"deviceType"] = @"0";
    [SVProgressHUD show];
    [HDNativeNetWorking PostWithHeaderurl:@"https://sy.smartlink.com.cn:44300/test/faw/drv/api/user/app/login" Params:dic success:^(id  _Nonnull responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            NSDictionary *responseDic = (NSDictionary *)responseObject;
            NSLog(@"%@",responseDic);
            [[self lgs_findVisibleViewController].view makeToast:[NSString stringWithFormat:@"%@",responseDic]];
            NSNumber *code = responseDic[@"code"];
            if ([code integerValue] == 200) {
                [HDUkeInfoCenter sharedCenter].userModel = [HDUkeInfoCenterModel mj_objectWithKeyValues:responseDic[@"data"]];
                [UKNetworkHelper GET:UKURL_GET_APP_UPDATE_usercenterprofile parameters:nil success:^(UKBaseRequest * _Nonnull request, id  _Nonnull response) {
                        NSNumber *code = response[@"code"];
                        if ([[code stringValue] isEqualToString:@"0"]) {
                            HDUserCenterProfileModel *profileModel = [HDUserCenterProfileModel mj_objectWithKeyValues:response[@"data"]];
                            [HDUkeInfoCenter sharedCenter].userModel.uuid = profileModel.uuid;
                            [HDUkeInfoCenter sharedCenter].userModel.phone = profileModel.username;
                            [HDUkeInfoCenter sharedCenter].userModel.state = profileModel.state;
                            [HDUkeInfoCenter sharedCenter].userModel.videoLength = profileModel.videoLength;
                            [HDUkeInfoCenter sharedCenter].userModel.nickName = profileModel.nickName;
                            [HDUkeInfoCenter sharedCenter].userModel.liveVideoDevice = profileModel.liveVideoDevice;
                            [HDUkeInfoCenter sharedCenter].userModel.avatar = profileModel.avatar;
                        }else{
                            [SVProgressHUD showErrorWithStatus:@"获取用户信息失败，请重试!"];
                        }

                      } failure:^(UKBaseRequest * _Nonnull request, id _Nonnull error) {
                          [SVProgressHUD showErrorWithStatus:@"获取用户信息失败，请重试!"];
                  }];
            }
        });
    } failure:^(NSString * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            return [SVProgressHUD showErrorWithStatus:error];
        });
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
