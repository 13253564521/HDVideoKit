//
//  HDSecondaryCommentView.h
//  HDVideoKitDemok
//
//  Created by liugaosheng on 2021/7/26.
//  Copyright © 2021 刘高升. All rights reserved.
//二级评论视图

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol HDSecondaryCommentViewDelegate <NSObject>

-(void)dismmHDSecondaryCommentView;
-(void)setuppingCount:(int)count;
@end

@interface HDSecondaryCommentView : UIView

@property(nonatomic, weak)id<HDSecondaryCommentViewDelegate> delegate;
@property(nonatomic, copy)NSString *videoUUID;
///上一级的评论id
@property(nonatomic, copy)NSString *pinglunID;
@property(nonatomic, assign)BOOL islikeVideo;
///请求二级列表数据
-(void)setupNwrwork;
@end

NS_ASSUME_NONNULL_END
