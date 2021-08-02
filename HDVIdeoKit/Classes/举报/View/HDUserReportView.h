//
//  HDUserReportView.h
//  HDVideoKitDemok
//
//  Created by liugaosheng on 2021/7/18.
//  Copyright © 2021 刘高升. All rights reserved.
//用户举报View

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol HDUserReportViewDelegate <NSObject>

/**
 添加截图
 */
- (void)hd_UserReportViewDidClickAddImage;

/**
 点击提交
 */
- (void)hd_UserReportViewDidClickSubmitWithReason:(NSArray *)reason text:(NSString *)text;
@end

@interface HDUserReportView : UIView
@property (nonatomic ,strong) NSMutableArray *photosArray;
@property (nonatomic ,strong) NSMutableArray *assestArray;

/** 代理 */
@property(nonatomic,weak) id<HDUserReportViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
