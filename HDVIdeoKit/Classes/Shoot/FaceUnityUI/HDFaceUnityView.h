//
//  HDFaceUnityView.h
//  HDVideoKit
//
//  Created by ^-^ on 2020/9/12.
//  Copyright © 2020 LiuGaoSheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSUInteger, HDFaceUnityType) {
    HDFaceUnityTypemoren = 0,
    HDFaceUnityTypedayan = 1,
    HDFaceUnityTypeshoulian = 2,
    HDFaceUnityTypemopi = 3,
    HDFaceUnityTypemeibai = 4,
    
};

@protocol HDFaceUnityViewDelegate <NSObject>

- (void)faceSetVaule:(float)value type:(HDFaceUnityType )type;

@end

@interface HDFaceUnityView : UIView
@property (nonatomic, weak) id<HDFaceUnityViewDelegate> delegate;
/**
 重置效果
 */
- (void)resetSeting;
/**
 恢复默认选项
 */
- (void)showNmalSeting;
@end

NS_ASSUME_NONNULL_END
