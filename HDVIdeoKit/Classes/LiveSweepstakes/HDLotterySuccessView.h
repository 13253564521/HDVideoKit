//
//  HDLotterySuccessView.h
//  HDVideoKitDemok
//
//  Created by liugaosheng on 2021/7/17.
//  Copyright © 2021 刘高升. All rights reserved.
//抽奖成功视图

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HDLotterySuccessViewDelegate <NSObject>
/**
 点击提交
 */
- (void)hd_LotterySuccessViewDidClicksubmit:(NSString *)name phone:(NSString *)phone address:(NSString *)address;

/**
 点击关闭
 */
- (void)hd_LotterySuccessViewDidClickclose;
@end

@interface HDLotterySuccessView : UIView
/** 代理 */
@property(nonatomic,weak) id<HDLotterySuccessViewDelegate> delegate;

/** 获奖信息 */
@property(nonatomic,copy) NSString *lotteryInfo;
/** 获奖图片链接 */
@property(nonatomic,copy) NSString *lotteryImageUrlStr;
@end

NS_ASSUME_NONNULL_END
