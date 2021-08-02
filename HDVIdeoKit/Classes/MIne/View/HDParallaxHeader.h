//
//  HDParallaxHeader.h
//  HDVideoKit
//
//  Created by liugaosheng on 2020/9/5.
//  Copyright © 2020 LiuGaoSheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol HDParallaxHeaderDelegate;

@interface HDParallaxHeader : NSObject
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) CGFloat ratio;
@property (nonatomic, readonly) CGFloat progress;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGFloat minimumHeight; // 待实现

@property (nonatomic,weak,nullable) id<HDParallaxHeaderDelegate> delegate;
@end
@protocol HDParallaxHeaderDelegate <NSObject>

@optional

- (void)parallaxHeaderDidScroll:(HDParallaxHeader *)parallaxHeader;

@end


/**
 A UIScrollView category with a HDParallaxHeader.
 */
@interface UIScrollView (HDParallaxHeader)

/**
 The parallax header.
 */
@property (nonatomic, strong) HDParallaxHeader *parallaxHeader;

@end
NS_ASSUME_NONNULL_END
