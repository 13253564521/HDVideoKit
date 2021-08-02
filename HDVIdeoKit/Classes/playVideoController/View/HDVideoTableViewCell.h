//
//  HDVideoTableViewCell.h
//  HDVideoKit
//
//  Created by LiuGaoSheng on 2020/8/31.
//  Copyright © 2020 LiuGaoSheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDUserVideoListModel.h"
#import "HDTopImageBottomTextButton.h"
#import "AVPlayerView.h"

typedef void (^OnPlayerReady)(void);

NS_ASSUME_NONNULL_BEGIN

@protocol HDVideoTableViewCellDelegate <NSObject>

- (void)hd_VideoTableViewCellDidClickUserIcon:(NSString *)userID;
- (void)hd_VideoTableViewCellDidClicklikeState:(BOOL)state;
- (void)hd_VideoTableViewCellDidClickComment:(NSString *)commentCount;
- (void)hd_VideoTableViewCellDidClickForward;
- (void)hd_VideoTableViewCellDidClickReport;
- (void)hd_VideoTableViewCellDidClickFoucsSender:(UIButton *)sender userID:(NSString *)userID publisherId:(NSString *)publisherId flag:(NSString *)flag;///关注
- (void)hd_Videodel;
@end

@interface HDVideoTableViewCell : UITableViewCell
/** 代理 */
@property(nonatomic,weak) id<HDVideoTableViewCellDelegate> delegate;

@property (nonatomic, strong) AVPlayerView     *playerView;
@property (nonatomic, assign) BOOL             isPlayerReady;
@property (nonatomic, strong) OnPlayerReady    onPlayerReady;
@property (nonatomic, strong) HDUserVideoListModel    *model;
@property(nonatomic,strong) UIImageView *backImageView;
/** 评论 */
@property(nonatomic,strong) HDTopImageBottomTextButton *commentButton;
- (void)play;
- (void)pause;
- (void)replay;
- (void)startDownloadBackgroundTask;

@end

NS_ASSUME_NONNULL_END
