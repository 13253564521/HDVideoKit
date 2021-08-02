//
//  HDCommentCellModel.h
//  HDVideoKit
//
//  Created by ^-^ on 2020/9/15.
//  Copyright © 2020 LiuGaoSheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class HDSeedCellModel;
NS_ASSUME_NONNULL_BEGIN

@interface HDCommentCellModel : NSObject
@property (nonatomic, copy)NSString *userUuid;
/** 原为 id */
@property (nonatomic, copy)NSString *pinglunID;
@property (nonatomic, copy)NSString *nickName;
@property (nonatomic, copy)NSString *content;
@property (nonatomic, strong)NSNumber *createTime;
@property (nonatomic, copy)NSString *pinstate;
@property (nonatomic, copy)NSString *avatar;
@property (nonatomic, strong)NSNumber *replyCount;
@property (nonatomic, strong)NSArray<HDCommentCellModel *> *children;

@property (nonatomic, assign)CGFloat CellHeight;//评论cell高度

@property (nonatomic, assign)CGFloat CellTableViewHeight;//二级回复 回复TableView高度


//当前用户点击了展开评论按钮 并且数据为0
@property(nonatomic , assign)BOOL isUserSelect;

@property(nonatomic , assign)BOOL isUserSelect1;//最新的评论
@end

@interface HDSeedCellModel : NSObject
@property (nonatomic, strong)NSString *userUuid;
@property (nonatomic, strong)NSString *pinglunID;
@property (nonatomic, strong)NSString *nickName;
@property (nonatomic, strong)NSString *content;

@property (nonatomic, strong)NSString *replyCount;
@property (nonatomic, strong)NSString *createTime;
@property (nonatomic, strong)NSString *pinstate;
@property (nonatomic, strong)NSString *targetNickName;
@property (nonatomic, strong)NSString *targetUserUuid;
@property (nonatomic, assign)CGFloat CellSeedHeight;//回复cell高度
//@property (nonatomic, assign)CGFloat cellMaxNumber;//最多显示几个cell


@end
NS_ASSUME_NONNULL_END
