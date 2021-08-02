//
//  HDBaseNavigationBar.m
//  HDVideoKit
//
//  Created by liugaosheng on 2020/8/30.
//  Copyright © 2020 LiuGaoSheng. All rights reserved.
//

#import "HDBaseNavigationBar.h"
#import "Macro.h"

@implementation HDBaseNavigationBar
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 设置默认透明度
        self.hd_navBarBackgroundAlpha = 1.0;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 这里为了适配iOS11，需要遍历所有的子控件，并向下移动状态栏的高度
    if (@available(iOS 11.0, *)) {
        [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:NSClassFromString(@"_UIBarBackground")]) {
                CGRect frame = obj.frame;
                frame.size.height = self.frame.size.height;
                obj.frame = frame;
            }else {
                CGFloat width  = [UIScreen mainScreen].bounds.size.width;
                CGFloat height = [UIScreen mainScreen].bounds.size.height;
                
                CGFloat y = 0;
                
                if (width > height) {   // 横屏
                    if (iPhoneX) {
                        y = 0;
                    }else {
                        y = self.hd_statusBarHidden ? 0 : GS_StatusBarHeight;
                    }
                }else {
                    y = self.hd_statusBarHidden ? GS_SAFEAREA_TOP : GS_StatusBarHeight;
                }
        
                CGRect frame   = obj.frame;
                frame.origin.y = y;
                obj.frame      = frame;
            }
        }];
    }
    
    // 重新设置透明度，解决iOS11的bug
    self.hd_navBarBackgroundAlpha = self.hd_navBarBackgroundAlpha;
    
    // 显隐分割线
    [self hd_navLineHideOrShow];
}

- (void)hd_navLineHideOrShow {
    UIView *backgroundView = self.subviews.firstObject;
    
    for (UIView *view in backgroundView.subviews) {
        if (view.frame.size.height <= 1.0 && view.frame.size.height > 0) {
            view.hidden = self.hd_navLineHidden;
        }
    }
}

- (void)sethd_navBarBackgroundAlpha:(CGFloat)hd_navBarBackgroundAlpha {
    _hd_navBarBackgroundAlpha = hd_navBarBackgroundAlpha;
    
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (@available(iOS 10.0, *)) {
            if ([obj isKindOfClass:NSClassFromString(@"_UIBarBackground")]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (obj.alpha != hd_navBarBackgroundAlpha) {
                        obj.alpha = hd_navBarBackgroundAlpha;
                    }
                });
            }
        }else if ([obj isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (obj.alpha != hd_navBarBackgroundAlpha) {
                    obj.alpha = hd_navBarBackgroundAlpha;
                }
            });
        }
    }];
    
    BOOL isClipsToBounds = (hd_navBarBackgroundAlpha == 0.0f);
    if (self.clipsToBounds != isClipsToBounds) {
        self.clipsToBounds = isClipsToBounds;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
