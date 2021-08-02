//
//  HDbuttonView.m
//  HDVideoKitDemok
//
//  Created by ^-^ on 2020/10/9.
//

#import "HDbuttonView.h"

@implementation HDbuttonView

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect bounds = self.bounds;
    
    // 扩大点击区域
    bounds = CGRectInset(bounds, -20, -20);
    
    // 若点击的点在新的bounds里面。就返回yes
    return CGRectContainsPoint(bounds, point);
}

@end
