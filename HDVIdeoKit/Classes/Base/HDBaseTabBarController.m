//
//  HDBaseTabBarController.m
//  HDVideoKit
//
//  Created by LiuGaoSheng on 2020/8/28.
//  Copyright © 2020 LiuGaoSheng. All rights reserved.
//

#import "HDBaseTabBarController.h"
#import "HDBaseNavigationController.h"
#import "HDCustomTabBar.h"
#import "HDDiscoverViewController.h"
#import "HDCompilationViewController.h"
#import "HDMessageViewController.h"
#import "HDMyViewController.h"
#import "Macro.h"

#import "HDSearchViewController.h"
#import "HDDiscoverBaseViewController.h"
#import "HDShootViewController.h"
#import "HDUserReportViewController.h"

#import "HDUkeInfoCenter.h"
#import "UKNetworkHelper.h"
#import "UKRequestURLPath.h"
#import <PLShortVideoKit/PLShortVideoKit.h>
#import "HDAlertView.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "HDServicesManager.h"

#import <PLMediaStreamingKit/PLMediaStreamingKit.h>
#import "HDtuiliuVideoViewController.h"
#import "LHDAFNetworkReachabilityManager.h"

@interface HDBaseTabBarController ()<HDCustomTabBarDelegate,HDDiscoverBaseViewControllerdelegate>

@end

@implementation HDBaseTabBarController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    if (@available(iOS 13.0, *)) {
        UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleDarkContent;
    } else {
        UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleDefault;
    }

}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleLightContent;

}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configSetting];
    
}
- (void)configSetting {
    
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;

    [SVProgressHUD setMinimumDismissTimeInterval:1.5];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];

    NSLog(@"%@",self.configuration.username);
   
    
    self.tabBar.translucent = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didpopView) name:@"leftpopView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabbarselection) name:@"tabbarselection" object:nil];
    
    [PLStreamingEnv initEnv];
    
    
//    [PLStreamingEnv setLogLevel:PLStreamLogLevelDebug];
    
//    [PLStreamingEnv enableFileLogging];
    
    

#if defined(__IPHONE_13_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0
   if(@available(iOS 13.0,*)){
       [UIApplication sharedApplication].keyWindow.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
   }
#endif
    
}


-(void)didpopView {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)tabbarselection {
    [self setSelectedIndex:3];
}

- (void)setConfiguration:(HDUkeConfigurationModel *)configuration {
    _configuration = configuration;
    
    HDUkeInfoCenterModel *model = [[HDUkeInfoCenterModel alloc]init];
    model.nickName = configuration.nickName;
    model.username = configuration.username;
    model.token = configuration.token;
    model.avatar = configuration.avatar;
//    model.token1 = configuration.token;
    
    [HDUkeInfoCenter sharedCenter].userModel = model;
    [HDUkeInfoCenter sharedCenter].configurationModel = configuration;
    [HDUkeInfoCenter sharedCenter].configurationModel.token1 = configuration.token;

    if (configuration.HTTPType == HTTPtest) {
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
    else if (configuration.HTTPType == HTTPuat) {
        if (configuration.carSource == 1) {
        
            [HDUkeInfoCenter sharedCenter].configurationModel.HTTPURL  = @"https://uat-iov-ec.fawjiefang.com.cn/dspqdfawapi/mobile";
            [HDUkeInfoCenter sharedCenter].configurationModel.shareURL = @"https://uat-iov-ec.fawjiefang.com.cn/dspqdfawshare/index.html?";

        }else {
            [HDUkeInfoCenter sharedCenter].configurationModel.HTTPURL  = @"https://uat-iov-ec.fawjiefang.com.cn/dspapi/mobile";
            [HDUkeInfoCenter sharedCenter].configurationModel.shareURL = @"https://uat-iov-ec.fawjiefang.com.cn/dspshare/index.html?";
            
        }

    }
    else if (configuration.HTTPType == HTTPreleases) {
        
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
                       [self.navigationController popViewControllerAnimated:YES];
                   }];

                   [alertVc addAction:sureBtn];
                   //展示
                   [self presentViewController:alertVc animated:YES completion:nil];
            }else {
                [self setsubViewControllers];
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
                [self.navigationController popViewControllerAnimated:YES];
            }else if ([num intValue] == 4000103) {
                UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:@"由于您多次违规操作，已被禁用该功能" preferredStyle:UIAlertControllerStyleAlert];

                   UIAlertAction *sureBtn = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull   action) {
                       [self.navigationController popViewControllerAnimated:YES];
                   }];

                   [alertVc addAction:sureBtn];
                   //展示
                   [self presentViewController:alertVc animated:YES completion:nil];
            }
        }else {
            return [SVProgressHUD showErrorWithStatus:@"网络异常，请检查网络状态"];
        }
    }];
    
   
    
}

- (void)setsubViewControllers {
    HDDiscoverBaseViewController *vc = [[HDDiscoverBaseViewController alloc]init];
    vc.delegate = self;
    [self setUpChildViewController:vc title:@"发现" tabBarTitle:@"发现" image:HDBundleImage(@"tabbar/discover_normal") selectImage:HDBundleImage(@"tabbar/discover_selected")];
    [self setUpChildViewController:[[HDCompilationViewController alloc]init] title:@"合辑" tabBarTitle:@"合辑" image:HDBundleImage(@"tabbar/compliation_normal") selectImage:HDBundleImage(@"tabbar/compliation_selected")];
    [self setUpChildViewController:[[HDMessageViewController alloc]init] title:@"消息" tabBarTitle:@"消息" image:HDBundleImage(@"tabbar/messages_normal")  selectImage:HDBundleImage(@"tabbar/messages_selected")];
    [self setUpChildViewController:[[HDMyViewController alloc]init] title:@"我的" tabBarTitle:@"我的" image:HDBundleImage(@"tabbar/mine_normal")  selectImage:HDBundleImage(@"tabbar/mine_selected")];
    
    HDCustomTabBar *cusTomBar = [HDCustomTabBar sharedManager];
    cusTomBar.delegate = self;
    [self setValue:cusTomBar forKey:@"tabBar"];
    
    
}

- (void)setUpChildViewController:(UIViewController *)viewController title:(NSString *)title tabBarTitle:(NSString *)tabBarTitle image:(NSString *)image selectImage:(NSString *)selectImage {
    viewController.title = title;
    HDBaseNavigationController *nav = [[HDBaseNavigationController alloc]initWithRootViewController:viewController];
//    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:viewController];
    [nav.tabBarItem setImage:[[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [nav.tabBarItem setSelectedImage:[[UIImage imageNamed:selectImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    nav.tabBarItem.title = tabBarTitle;
    [self addChildViewController:nav];
    self.tabBar.translucent = NO;
    
}

#pragma mark - GSCustomTabBarDelegate
- (void)addButtonClick:(HDCustomTabBar *)tabBar clickItem:(UIButton *)item {
    
    if ([HDUkeInfoCenter sharedCenter].configurationModel.dentityStatus == 1) {
        
        NSString *mediaType = AVMediaTypeVideo;
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
                        
        if(authStatus == AVAuthorizationStatusRestricted ||
           authStatus == AVAuthorizationStatusDenied){
                        
            UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"系统相机尚未打开，请到【设定-隐私】中手动打开" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * tipsAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
                // 跳转到设置 - 相机 / 该应用的设置界面
                NSURL *url1 = [NSURL URLWithString:@"App-Prefs:root=Privacy&path=CAMERA"];
                // iOS10也可以使用url2访问，不过使用url1更好一些，可具体根据业务需求自行选择
                NSURL *url2 = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if (@available(iOS 11.0, *)) {
                    [[UIApplication sharedApplication] openURL:url2 options:@{} completionHandler:nil];
                } else {
                    if ([[UIApplication sharedApplication] canOpenURL:url1]){
                        if (@available(iOS 10.0, *)) {
                            [[UIApplication sharedApplication] openURL:url1 options:@{} completionHandler:nil];
                        } else {
                            [[UIApplication sharedApplication] openURL:url1];
                        }
                    }
                }
            }];
            [alertVC addAction:tipsAction];
            [self presentViewController:alertVC animated:YES completion:nil];
            return;
            
        }
        
        
        HDShootViewController *vc = [[HDShootViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:@"您还未实名认证无法使用拍摄功能，请返回至解放行APP首页，进入我的页面选择实名认证模块完成响应操作" preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *sureBtn = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull   action) {

       }];
       [alertVc addAction:sureBtn];
       [self presentViewController:alertVc animated:YES completion:nil];
    }

}

-(void)popviewcontrooler {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSLog(@"%@", item.title);
    
    if ([item.title isEqualToString:@"我的"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"usetmedidselecti" object:nil];

    }
}

@end
