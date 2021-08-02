//
//  HDBaseNavigationController.m
//  HDVideoKit
//
//  Created by LiuGaoSheng on 2020/8/28.
//  Copyright © 2020 LiuGaoSheng. All rights reserved.
//

#import "HDBaseNavigationController.h"
#import "HDNavigationProtocol.h"
#import "HDAttentionViewController.h"
#import "Macro.h"
#import "HDbuttonView.h"

@interface HDBaseNavigationController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>
@property(nonatomic,weak) UIViewController* currentShowVC;

@end

@implementation HDBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //        导航栏颜色
    UINavigationBar *nav = [UINavigationBar appearance];
    
//    nav.barTintColor = [UIColor colorWithRed:22.0 / 255 green:154.0 / 255 blue:218.0 / 255 alpha:1.0];
//    nav.barTintColor = [UIColor whiteColor];
//    nav.barTintColor =  [UIColor colorWithRed:116.0 / 255 green:156.0 / 255 blue:255.0 / 255 alpha:1.0];
    
    nav.translucent = NO;
//    [nav setBarTintColor:RGB(255, 255, 255)];
    [nav setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20],
                                  NSForegroundColorAttributeName:[UIColor blackColor]}];
    self.delegate = self;

}



- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
//    HDbuttonView *button = [[HDbuttonView alloc]init];
//
//    button.frame = CGRectMake(0, 0, button.currentBackgroundImage.size.width, button.currentBackgroundImage.size.height );
//    [button setBackgroundImage:[UIImage imageNamed:@"HDVideoKitResources.bundle/navgation/btn_back1" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(backAciotn) forControlEvents:UIControlEventTouchUpInside];

    UIButton *button = [[UIButton alloc]init];
    [button setTitle:@"    " forState:0];
    [button setImage:[UIImage imageNamed:HDBundleImage(@"navgation/btn_back1")] forState:0];
    [button addTarget:self action:@selector(backAciotn) forControlEvents:UIControlEventTouchUpInside];
    viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    if (self.viewControllers.count >= 1) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:YES];
    
}


- (void)backAciotn {
    if (self.viewControllers.count == 1) {
        [self.tabBarController.navigationController popViewControllerAnimated:NO];
    }else{
      [self popViewControllerAnimated:YES];
    }
    
    
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    UIViewController *topVC = self.topViewController;
    if ([topVC isKindOfClass:[UITabBarController class]]) {
        return ((UITabBarController *)topVC).selectedViewController;
    }
    return topVC;
}

#pragma mark - UIGestureRecognizerDelegate
//这个方法在视图控制器完成push的时候调用
-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (navigationController.viewControllers.count == 1){
        //如果堆栈内的视图控制器数量为1 说明只有根控制器，将currentShowVC 清空，为了下面的方法禁用侧滑手势
        self.currentShowVC = Nil;
    }
    else{
        //将push进来的视图控制器赋值给currentShowVC
        self.currentShowVC = viewController;
    }
}
//这个方法是在手势将要激活前调用：返回YES允许侧滑手势的激活，返回NO不允许侧滑手势的激活
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    //首先在这确定是不是我们需要管理的侧滑返回手势
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        if (self.currentShowVC == self.topViewController) {
            //如果 currentShowVC 存在说明堆栈内的控制器数量大于 1 ，允许激活侧滑手势
            return YES;
        }
        //如果 currentShowVC 不存在，禁用侧滑手势。如果在根控制器中不禁用侧滑手势，而且不小心触发了侧滑手势，会导致存放控制器的堆栈混乱，直接的效果就是你发现你的应用假死了，点哪都没反应，感兴趣是神马效果的朋友可以自己试试 = =。
        return NO;
    }
    
    //这里就是非侧滑手势调用的方法啦，统一允许激活
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    
    //如果控制器遵守了DLNoNav协议，则需要隐藏导航栏
    BOOL noNav = [[viewController class] conformsToProtocol:@protocol(HDNavigationProtocol)];

    //隐藏导航栏后会导致边缘右滑返回的手势失效，需要重新设置一下这个代理
    self.interactivePopGestureRecognizer.delegate = self;
    //设置控制器是否要隐藏导航栏
    [self setNavigationBarHidden:noNav animated:YES];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return self.childViewControllers.count > 1;
}


@end
