//
//  HDSecondaryCommentCell.h
//  HDVideoKitDemok
//
//  Created by liugaosheng on 2021/7/26.
//  Copyright © 2021 刘高升. All rights reserved.
//二级评论视图

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HDCommentCellModel;
@protocol HDSecondaryCommentCellDelegate <NSObject>

- (void)hd_secondaryCommentCellDidClickHuifuWithModel:(HDCommentCellModel *)model lastPinglunId:(NSString *)lastPinglunId;

@end

@interface HDSecondaryCommentCell : UITableViewCell
@property(nonatomic, strong)HDCommentCellModel *model;
@property(nonatomic, weak)id <HDSecondaryCommentCellDelegate> delegate;
@property(nonatomic , copy)NSString *videUUID;
/**
上级评论的id
 */
@property(nonatomic , copy)NSString *pinglunID;
@property(nonatomic , assign)NSInteger cellindex;
@end

NS_ASSUME_NONNULL_END
