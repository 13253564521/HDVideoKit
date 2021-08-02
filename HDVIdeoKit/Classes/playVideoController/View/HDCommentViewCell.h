//
//  HDCommentViewCell.h
//  HDVideoKit
//
//  Created by ^-^ on 2020/9/15.
//  Copyright © 2020 LiuGaoSheng. All rights reserved.
//一级评论视图cell

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN
@class HDCommentCellModel;
@class HDSeedCellModel;
@protocol HDCommentViewCellDelegate <NSObject>

-(void)hd_CommentViewCellhuifuWithModel:(HDCommentCellModel *)model lastPinglunId:(NSString *)lastPinglunId;

@optional
///一级视图的位置
///二级视图所需要的参数
-(void)tablefooterViewIndex:(NSInteger)cellindex videoUUID:(NSString *)videoUUID pinglunId:(NSString *)pinglunId islikeVideo:(BOOL)islikeVideo;
@end

@interface HDCommentViewCell : UITableViewCell
@property(nonatomic, strong)HDCommentCellModel *model;
@property(nonatomic, weak)id <HDCommentViewCellDelegate>delegate;
@property(nonatomic , copy)NSString *videUUID;
@property(nonatomic , assign)NSInteger cellindex;
-(void)setupwenwrok;
@property(nonatomic, assign)BOOL islikeVideo;

@end

NS_ASSUME_NONNULL_END
