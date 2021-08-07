//
//  HDVideoMessageListView.h
//  HDVideoKitDemok
//
//  Created by ^-^ on 2020/11/5.
//

#import <UIKit/UIKit.h>
#import "HDVideoMessageListModel.h"

NS_ASSUME_NONNULL_BEGIN


// 刷新消息方式
typedef NS_ENUM(NSUInteger, NDReloadLiveMsgRoomType) {
    NDReloadLiveMsgRoom_Time = 0, // 0.5秒刷新一次消息
    NDReloadLiveMsgRoom_Direct,   // 直接刷新
};

@interface HDVideoMessageListView : UIView

@property (nonatomic, assign) NDReloadLiveMsgRoomType reloadType;

/** 添加新的消息 */
- (void)addNewMsg:(HDVideoMessageListModel *)msgModel;

//清空消息重置
- (void)reset;
@end

NS_ASSUME_NONNULL_END
