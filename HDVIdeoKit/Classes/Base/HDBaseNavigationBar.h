//
//  HDBaseNavigationBar.h
//  HDVideoKit
//
//  Created by liugaosheng on 2020/8/30.
//  Copyright © 2020 LiuGaoSheng. All rights reserved.
//自定义的导航条

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDBaseNavigationBar : UINavigationBar
// 当前控制器
@property (nonatomic, assign) BOOL      hd_statusBarHidden;

/** 导航栏背景色透明度，默认是1.0 */
@property (nonatomic, assign) CGFloat   hd_navBarBackgroundAlpha;

@property (nonatomic, assign) BOOL      hd_navLineHidden;

- (void)hd_navLineHideOrShow;
@end

NS_ASSUME_NONNULL_END
