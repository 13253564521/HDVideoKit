//
//  HDTakeVideoTableViewCell.h
//  HDVideoKitDemok
//
//  Created by liugaosheng on 2021/7/14.
//  Copyright © 2021 刘高升. All rights reserved.
//发视频界面cell

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HDTakeVideoModel;
@interface HDTakeVideoTableViewCell : UITableViewCell
@property(nonatomic, strong) HDTakeVideoModel *model;

@end

NS_ASSUME_NONNULL_END
