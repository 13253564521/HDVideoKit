//
//  HDLiveReleaseView.h
//  HDVideoKitDemok
//
//  Created by liugaosheng on 2021/7/14.
//  Copyright © 2021 刘高升. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol HDLiveReleaseViewDelegate <NSObject>
/**
 点击下一步
 */
- (void)liveReleaseViewDidClickNextButtonTitle:(NSString *)title livePrewTimeString:(NSString *)livePrewTimeString liveType:(NSNumber *)liveType useForm:(NSNumber *)useForm activityId:(NSString *)activityId;

/**
 点击复制链接
 */
- (void)liveReleaseViewDidClickCopyUrl:(NSString *)url;
/**
点击添加封面视图操作
 */
- (void)liveReleaseViewDidClickAddcoverImage;
/**
话题点击
 */
- (void)liveReleaseViewDidClickhuatiViewGes;
/**
直播预告设置时间
 */
- (void)liveReleaseViewDidClicklivepreViewGes;

/**
是否使用位置信息
 */
- (void)liveReleaseViewDidClickisUselocation:(UIButton *)sender;

@end
@interface HDLiveReleaseView : UIView
/**立即开始直播 */
@property(nonatomic,strong) UIButton  *liveStartButton;
/**直播直播预告 */
@property(nonatomic,strong) UIButton  *livepreviewButton;

/**手机直播直播 */
@property(nonatomic,strong) UIButton  *phoneliveButton;
/**硬件直播直播 */
@property(nonatomic,strong) UIButton  *hardwareliveButton;
/** 代理 */
@property(nonatomic,weak) id<HDLiveReleaseViewDelegate> delegate;

/** 直播 时间 */
@property(nonatomic,copy) NSString *livePrewTimeString;

/** 位置信息 */
@property(nonatomic,copy) NSString *locationStr;
/** 选中话题信息*/
@property(nonatomic,copy) NSString *selectedHuatiText;

/** 选中图片 */
@property (nonatomic, strong) UIImage *selectImage;


@end

NS_ASSUME_NONNULL_END
