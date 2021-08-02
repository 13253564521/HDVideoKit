//
//  HDCommentView.h
//  HDVideoKit
//
//  Created by liugaosheng on 2020/9/6.
//  Copyright © 2020 LiuGaoSheng. All rights reserved.
//评论视图

#import <UIKit/UIKit.h>
#import "HDUserVideoListModel.h"
NS_ASSUME_NONNULL_BEGIN
@protocol HDCommentViewdelegate <NSObject>

-(void)dismmHDCommentView;
-(void)setuppingCount:(int)count;
@end

@interface HDCommentView : UIView
//@property(nonatomic , strong)HDUserVideoListModel *model;
@property(nonatomic, strong)NSString *videoUUID;
@property(nonatomic, assign)BOOL islikeVideo;

@property(nonatomic, weak)id<HDCommentViewdelegate> delegate;

@end

NS_ASSUME_NONNULL_END
