//
//  Macro.h
//  HDVideoKit
//
//  Created by LiuGaoSheng on 2020/8/28.
//  Copyright © 2020 LiuGaoSheng. All rights reserved.
//

#ifndef Macro_h
#define Macro_h


#import <TZImagePickerController/TZImagePickerController.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <Masonry/Masonry.h>
#import <MJExtension/MJExtension.h>
#import <MJRefresh/MJRefresh.h>
#import <YYWebImage/YYWebImage.h>
#import "NSObject+Extend.h"
#import "UIView+Toast.h"

#pragma mark - 通知
#define StatusBarTouchBeginNotification @"StatusBarTouchBeginNotification"

#pragma mark - 资源路径
#define HDBundleResources [[NSBundle mainBundle]pathForResource:@"HDVideoKitResources" ofType:@"bundle"]
#define HDBundle [NSBundle bundleWithPath:HDBundleResources]
#define HDBundleImage(name)  [NSString stringWithFormat:@"HDVideoKitResources.bundle/%@",name]

/** 获取APP名称 */

#define APP_NAME ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"])

/** 程序版本号 */

#define APP_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

/** 获取APP build版本 */

#define APP_BUILD ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"])

#ifndef UkeColorRGBA
    #define UkeColorRGBA(r, g, b, a) \
            [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]

    #define UkeColorRGB(r, g, b)     UkeColorRGBA(r, g, b, 1.f)
    #define UkeRandomColor \
            UkeColorRGB(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))
#endif

#ifndef UkeColorHexA
    #define UkeColorHexA(_hex_, a) \
            UkeColorRGBA((((_hex_) & 0xFF0000) >> 16), (((_hex_) & 0xFF00) >> 8), ((_hex_) & 0xFF), a)
    #define UkeColorHex(_hex_)   UkeColorHexA(_hex_, 1.0)
#endif

#pragma mark - 色值
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#pragma mark - 常用色值
#define HomeViewBGColor RGB(255,255,255)
#define GSCustomBlack RGB(115,115,115)
#define GSCustomGray  RGB(88, 103, 124)
#define GSTableViewBGColor RGB(238, 238, 238)
#define GSNavBarColor RGB(37, 125, 202)
#define GSBGColor RGBA(0,0,0,0.7)
#define QN_MAIN_COLOR RGB(6.0, 130.0, 255.0)

#pragma mark - 尺寸
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
// iPhone X 宏定义
#define  iPhoneX (kScreenWidth >= 375.f && kScreenHeight >= 812.f ? YES : NO)
#define  iPhoneLow5s (kScreenWidth == 320.f ? YES : NO)

#define  GS_SAFEAREA_TOP                 (iPhoneX ? 24.0f : 0.0f)
// 适配iPhone X 状态栏高度
#define  GS_StatusBarHeight      (iPhoneX ? 44.f : 20.f)
// 适配iPhone X Tabbar高度
#define  GS_TabbarHeight         (iPhoneX ? (49.f+34.f) : 49.f)
// 适配iPhone X Tabbar距离底部的距离
#define  GS_TabbarSafeBottomMargin         (iPhoneX ? 34.f : 0.f)
// 适配iPhone X 导航栏高度
#define  GS_NavHeight  (iPhoneX ? 88.f : 64.f)

#define kScaleWidth     kScreenWidth/375.0
#define kScaleHeight    kScreenHeight/667.0

#define kStatusBarAndNavigationBarHeight (iPhoneX ? 88.f : 64.f)

#define KAUTOSIZE(_wid,_hei)   CGSizeMake(_wid * kScreenWidth / 375.0, _hei * kScreenHeight / 667.0)
#define kAUTOWIDTH(_wid)  _wid * kScreenWidth / 375.0
#define kAUTOHEIGHT(_hei) _hei * kScreenHeight / 667.0

#pragma mark - weakSelf
#define WeakObj(o) autoreleasepool{} __weak typeof(o) o##Weak = o;
#pragma mark - strongSelf
#define StrongObj(o) autoreleasepool{} __strong typeof(o) o = o##Weak;

#pragma mark - deallco信息

#define GSLog_Dealloc NSLog(@"妈耶！%@ dealloc \n", NSStringFromClass([self class]));

#ifdef DEBUG

#define GSLog(FORMAT, ...)  fprintf(stderr,"%s:%d\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

#else

#define NSLog(FORMAT, ...) nil

#endif

#ifndef weakify
    #if DEBUG
        #if __has_feature(objc_arc)
        #define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
        #else
        #define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
        #endif
    #else
        #if __has_feature(objc_arc)
        #define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
        #else
        #define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
        #endif
    #endif
#endif

#ifndef strongify
    #if DEBUG
        #if __has_feature(objc_arc)
        #define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
        #else
        #define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
        #endif
    #else
        #if __has_feature(objc_arc)
        #define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
        #else
        #define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
        #endif
    #endif
#endif



#endif /* Macro_h */
