//
//  HDLikeView.h
//  HDVideoKit
//
//  Created by LiuGaoSheng on 2020/8/31.
//  Copyright © 2020 LiuGaoSheng. All rights reserved.
//点赞动画试图

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HDLikeViewdelegate <NSObject>

-(void)dianshi:(BOOL)isdianzan;

@end

@interface HDLikeView : UIView
@property (nonatomic, strong) UIImageView *likeBefore;
@property (nonatomic, strong) UIImageView *likeAfter;
@property (nonatomic, strong) UILabel     *likeCount;
@property (nonatomic, assign) CGFloat     likeDuration;
@property (nonatomic, strong) UIColor     *hdFillColor;
@property (nonatomic, weak) id<HDLikeViewdelegate> delegate;
@end

NS_ASSUME_NONNULL_END
